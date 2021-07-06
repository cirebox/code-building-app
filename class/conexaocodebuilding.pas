unit ConexaoCodeBuilding;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset, ZSqlUpdate, Dialogs,
  ZSqlProcessor, ZSqlMonitor, db, BufDataset, memds, sqldb, TypeCodeBuilding;

type

  { TConexaoCodeBuilding }

  TConexaoCodeBuilding = class
    strict private
      Conexao : TZConnection;
      class var FInstance: TConexaoCodeBuilding;
      constructor CreatePrivate;
    private
      procedure LoadConexao;
    public
      constructor Create;
      destructor  Destroy; override;
      class function GetInstance: TConexaoCodeBuilding;
      function Conectar: Boolean;
      function ListarDados(sTabela: String): Boolean;
      function ListarBancos: Boolean;
      function ListarTabelas: Boolean;
      function ListarFields(sTabela: String): Boolean;
      function ListarRelacionamento(sTabela: String): Boolean;
      function ListarUnique(sTabela: String): Boolean;
      function ListarDependencias(sTabela: String): Boolean;
      function ExecutarScript(Script: TStringList): Boolean;
  end;


implementation

uses CodeBuildingClass, udm, SGDB_Ctrl;

{ TConexaoCodeBuilding }

constructor TConexaoCodeBuilding.CreatePrivate;
begin
  inherited Create;
end;

procedure TConexaoCodeBuilding.LoadConexao;
begin
  case dm.CodeBuilding.Conexao.SGDB of
    firebird:
    begin
      FInstance.Conexao.Protocol := 'firebird-2.5';
      FInstance.Conexao.LibraryLocation := dm.CodeBuilding.Dir+'bin\fbclient.dll';
    end;
    mysql   :
    begin
      FInstance.Conexao.Protocol := 'mysql-5';
      FInstance.Conexao.LibraryLocation := dm.CodeBuilding.Dir+'bin\libmysql.dll';
    end;
    postgres:
    begin
      FInstance.Conexao.Protocol         := 'postgresql';
      FInstance.Conexao.LibraryLocation  := dm.CodeBuilding.Dir+'bin\libpq.dll';
    end;
  end;
  FInstance.Conexao.AutoEncodeStrings := False;
  FInstance.Conexao.LoginPrompt       := False;
  FInstance.Conexao.HostName          := dm.CodeBuilding.Conexao.Host;
  FInstance.Conexao.Port              := dm.CodeBuilding.Conexao.Porta;
  FInstance.Conexao.Password          := dm.CodeBuilding.Conexao.Senha;
  FInstance.Conexao.User              := dm.CodeBuilding.Conexao.Usuario;
  FInstance.Conexao.Database          := dm.CodeBuilding.Conexao.Banco;
end;

constructor TConexaoCodeBuilding.Create;
begin
  raise Exception.Create('Objeto Singleton');
end;

destructor TConexaoCodeBuilding.Destroy;
begin
  inherited Destroy;
end;

class function TConexaoCodeBuilding.GetInstance: TConexaoCodeBuilding;
begin
  if not Assigned(FInstance) then
    FInstance := TConexaoCodeBuilding.CreatePrivate;

  if not Assigned(FInstance.Conexao) then
    FInstance.Conexao := TZConnection.Create(nil);

  FInstance.LoadConexao;

  Result := FInstance;
end;

function TConexaoCodeBuilding.Conectar: Boolean;
begin
  try
    FreeAndNil(FInstance.Conexao);

    if not Assigned(FInstance.Conexao) then
      FInstance.Conexao := TZConnection.Create(nil);

    LoadConexao;

    Self.Conexao.Connected := True;
    Result := True;
  except
    Result := False;
  end;
end;

function TConexaoCodeBuilding.ListarDados(sTabela: String): Boolean;
var
  qry : TZQuery;
  i : Integer;
begin
  try
    try
      dm.Zqry.Connection := self.Conexao;
      dm.Zqry.Close;
      dm.Zqry.SQL.Text := TSGDB_Ctrl.GetInstance.GetDados(sTabela);
      dm.Zqry.Open;
      dm.Zqry.First;
      Result := True;
    except
      Result := False;
    end;
  finally
    dm.Zqry.EnableControls;
  end;
end;

function TConexaoCodeBuilding.ListarBancos: Boolean;
var
  qry: TZQuery;
begin
  if dm.CodeBuilding.Conexao.SGDB = firebird then
    Exit;
  try
    try
      qry            := TZQuery.Create(nil);
      qry.Connection := Self.Conexao;
      qry.Close;
      qry.SQL.Text   := TSGDB_Ctrl.GetInstance.GetSQL_Bancos;
      qry.Open;
      qry.First;
      dm.Banco.Close;
      dm.Banco.CreateTable;
      dm.Banco.Open;
      dm.Banco.DisableControls;
      while not qry.eof do
      begin
        try
          dm.Banco.Append;
          dm.Banco.FieldByName('nome').AsString   := qry.Fields[0].AsString;
          dm.Banco.post;
        finally
          qry.Next;
        end;
      end;
      dm.Banco.First;
      Result := True;
    except
      Result := False;
    end;
  finally
    FreeAndNil(qry);
    dm.Banco.EnableControls;
  end;
end;

function TConexaoCodeBuilding.ListarFields(sTabela: String): Boolean;
var
  qry: TZQuery;
begin
  try
    try
      qry            := TZQuery.Create(nil);
      qry.Connection := Self.Conexao;
      qry.Close;
      qry.SQL.Text   := TSGDB_Ctrl.GetInstance.GetSQL_Fields(sTabela);
      qry.Open;
      qry.First;
      dm.Fields.Close;
      dm.Fields.CreateTable;
      dm.Fields.Open;
      dm.Fields.DisableControls;
      while not qry.eof do
      begin
        try
          dm.Fields.Append;
          dm.Fields.FieldByName('campo').AsString         := qry.FieldByName('campo').AsString;
          dm.Fields.FieldByName('notnull').AsBoolean      := qry.FieldByName('notnull').AsBoolean;
          dm.Fields.FieldByName('unique').AsBoolean       := false;
          dm.Fields.FieldByName('campo_tamanho').AsString := qry.FieldByName('campo_tamanho').AsString;
          dm.Fields.FieldByName('tipo').AsString          := qry.FieldByName('tipo').AsString;
          dm.Fields.FieldByName('chave').AsString         := qry.FieldByName('chave').AsString;
          dm.Fields.FieldByName('pk').AsBoolean           := (LowerCase(qry.FieldByName('campo').AsString) = LowerCase(qry.FieldByName('chave').AsString));
          dm.Fields.post;
        finally
          qry.Next;
        end;
      end;
      dm.Fields.First;
      Result := True;
    except
      Result := False;
    end;
  finally
    dm.Fields.EnableControls;
    FreeAndNil(qry);
  end;
end;

function TConexaoCodeBuilding.ListarRelacionamento(sTabela: String): Boolean;
var
  qry: TZQuery;
begin
  try
    try
      qry            := TZQuery.Create(nil);
      qry.Connection := Self.Conexao;
      qry.Close;
      qry.SQL.Text   := TSGDB_Ctrl.GetInstance.GetSQL_Relacionamento(sTabela);
      qry.Open;
      qry.First;
      dm.ForeignKeys.Close;
      dm.ForeignKeys.CreateTable;
      dm.ForeignKeys.Open;
      dm.ForeignKeys.DisableControls;
      while not qry.eof do
      begin
        try
          dm.ForeignKeys.Append;
          dm.ForeignKeys.FieldByName('fk_name').AsString  := qry.FieldByName('fk_name').AsString;
          dm.ForeignKeys.FieldByName('field').AsString    := qry.FieldByName('field').AsString;
          dm.ForeignKeys.FieldByName('fk_table').AsString := qry.FieldByName('fk_table').AsString;
          dm.ForeignKeys.FieldByName('fk_field').AsString := qry.FieldByName('fk_field').AsString;
          dm.ForeignKeys.FieldByName('Update').AsString   := qry.FieldByName('Update').AsString;
          dm.ForeignKeys.FieldByName('Delete').AsString   := qry.FieldByName('Delete').AsString;
          dm.ForeignKeys.post;
        finally
          qry.Next;
        end;
      end;
      dm.ForeignKeys.First;
      Result := True;
    except
      Result := False;
    end;
  finally
    dm.ForeignKeys.EnableControls;
    FreeAndNil(qry);
  end;
end;

function TConexaoCodeBuilding.ListarUnique(sTabela: String): Boolean;
var
  qry: TZQuery;
begin
  try
    try
      qry            := TZQuery.Create(nil);
      qry.Connection := Self.Conexao;
      qry.Close;
      qry.SQL.Text   := TSGDB_Ctrl.GetInstance.GetSQL_Unique(sTabela);
      qry.Open;
      qry.First;
      dm.Unique.Close;
      dm.Unique.CreateTable;
      dm.Unique.Open;
      dm.Unique.DisableControls;
      while not qry.eof do
      begin
        try
          dm.Unique.Append;
          dm.Unique.FieldByName('fk_name').AsString  := qry.FieldByName('fk_name').AsString;
          dm.Unique.FieldByName('field').AsString    := qry.FieldByName('field').AsString;
          dm.Unique.FieldByName('fk_table').AsString := qry.FieldByName('fk_table').AsString;
          dm.Unique.FieldByName('fk_field').AsString := qry.FieldByName('fk_field').AsString;
          dm.Unique.FieldByName('Update').AsString   := qry.FieldByName('Update').AsString;
          dm.Unique.FieldByName('Delete').AsString   := qry.FieldByName('Delete').AsString;
          dm.Unique.post;
        finally
          qry.Next;
        end;
      end;
      dm.Unique.First;
      Result := True;
    except
      Result := False;
    end;
  finally
    dm.Unique.EnableControls;
    FreeAndNil(qry);
  end;
end;

function TConexaoCodeBuilding.ListarDependencias(sTabela: String): Boolean;
var
  qry: TZQuery;
begin
  try
    try
      qry            := TZQuery.Create(nil);
      qry.Connection := Self.Conexao;
      qry.Close;
      qry.SQL.Text   := TSGDB_Ctrl.GetInstance.GetSQL_Dependencias(sTabela);
      qry.Open;
      qry.First;
      dm.Dependencias.Close;
      dm.Dependencias.CreateTable;
      dm.Dependencias.Open;
      dm.Dependencias.DisableControls;
      while not qry.eof do
      begin
        try
          dm.Dependencias.Append;
          dm.Dependencias.FieldByName('tabela').AsString     := qry.FieldByName('tabela').AsString;
          dm.Dependencias.FieldByName('field').AsString      := qry.FieldByName('field').AsString;
          dm.Dependencias.FieldByName('constraint').AsString := qry.FieldByName('constraint').AsString;
          dm.Dependencias.FieldByName('field_ref').AsString  := qry.FieldByName('field_ref').AsString;
          dm.Dependencias.post;
        finally
          qry.Next;
        end;
      end;
      dm.Dependencias.First;
      Result := True;
    except
      Result := False;
    end;
  finally
    dm.Dependencias.EnableControls;
    FreeAndNil(qry);
  end;
end;

function TConexaoCodeBuilding.ExecutarScript(Script: TStringList): Boolean;
begin
  try
    try
      Self.Conexao.StartTransaction;
      dm.qryScript.Connection  := Self.Conexao;
      dm.qryScript.Clear;
      dm.qryScript.Script.Text := Script.Text;
      Script.SaveToFile(dm.CodeBuilding.DirSaida+'teste'+'.TXT');
      dm.qryScript.Execute;
      Self.Conexao.Commit;
      Result := True;
    except
      Result := False;
      Self.Conexao.Rollback;
    end;
  finally
  end;
end;

function TConexaoCodeBuilding.ListarTabelas: Boolean;
var
  qry: TZQuery;
begin
  try
    try
      qry            := TZQuery.Create(nil);
      qry.Connection := Self.Conexao;
      qry.Close;
      qry.SQL.Text   := TSGDB_Ctrl.GetInstance.GetSQL_Tabelas;
      qry.Open;
      qry.First;
      dm.Tabelas.Close;
      dm.Tabelas.CreateTable;
      dm.Tabelas.Open;
      dm.Tabelas.DisableControls;
      while not qry.eof do
      begin
        try
          dm.Tabelas.Append;
          dm.Tabelas.FieldByName('check').AsBoolean := False;
          dm.Tabelas.FieldByName('nome').AsString   := qry.FieldByName('tabela').AsString;
          dm.Tabelas.post;
        finally
          qry.Next;
        end;
      end;
      dm.Tabelas.First;
      Result := True;
    except
      Result := False;
    end;
  finally
    FreeAndNil(qry);
    dm.Tabelas.EnableControls;
  end;
end;

end.

