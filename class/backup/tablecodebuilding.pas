unit TableCodeBuilding;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Dialogs;

type

    { Tcampos }

    TCampos = class
    strict private
      FTabela : String;
      FCampo  : TDataSet;
      procedure SetDataSet(AValue: TDataSet);
    private
      property Field: TDataSet read Fcampo write SetDataSet;
    public
      constructor Create(sTabela: String);
      procedure primeiro;
      procedure proximo;
      function EOF: Boolean;
      function Vazio: Boolean;
      function count: Integer;
      function PK: String;
      function Nome(CalmeCase: Boolean = False): String;
      function Value: Variant;
      function TodosFields: String;
      function Tipo: String;
      function NotNull: Boolean;
      function isUnique: Boolean;
      function Tamanho: Integer;
    end;

    { TDependencia }

    TDependencia = class
    strict private
      FTabela : String;
      FDependencia : TDataSet;
      procedure SetDataSet(AValue: TDataSet);
    private
      property Dependencia: TDataSet read FDependencia write SetDataSet;
    public
      constructor Create(sTabela: String);
      procedure primeiro;
      procedure proximo;
      function EOF: Boolean;
      function Vazio: Boolean;
      function count: Integer;
      function TABELA(CalmeCase: Boolean = False): String;
      function FIELD(CalmeCase: Boolean = False): String;
      function CONSTRAINT(CalmeCase: Boolean = False): String;
      function FIELD_REF(CalmeCase: Boolean = False): String;
    end;

    { TForeignKeys }

    TForeignKeys = class
    strict private
      FTabela : String;
      FRelacionamento  : TDataSet;
      procedure SetDataSet(AValue: TDataSet);
    private
      property Relacionamento: TDataSet read FRelacionamento write SetDataSet;
    public
      constructor Create(sTabela: String);
      procedure primeiro;
      procedure proximo;
      function EOF: Boolean;
      function Vazio: Boolean;
      function count: Integer;
      function FK_NAME(CalmeCase: Boolean = False): String;
      function FIELD(CalmeCase: Boolean = False): String;
      function FK_TABLE(CalmeCase: Boolean = False): String;
      function FK_FIELD(CalmeCase: Boolean = False): String;
      function UPDATE: String;
      function DELETE: String;
    end;

    { TUnique }

    TUnique = class
    strict private
      FTabela : String;
      FUnique  : TDataSet;
      procedure SetDataSet(AValue: TDataSet);
    private
      property Unique: TDataSet read FUnique write SetDataSet;
    public
      constructor Create(sTabela: String);
      procedure primeiro;
      procedure proximo;
      function EOF: Boolean;
      function Vazio: Boolean;
      function count: Integer;
      function FK_NAME(CalmeCase: Boolean = False): String;
      function FIELD(CalmeCase: Boolean = False): String;
      function FK_TABLE(CalmeCase: Boolean = False): String;
      function FK_FIELD(CalmeCase: Boolean = False): String;
      function UPDATE: String;
      function DELETE: String;
    end;


    { TCodeBuildingTabela }

    TCodeBuildingTabela = class
    strict private
      Fcampos: Tcampos;
      FPK: String;
      FForeignKeys : TForeignKeys;
      FUnique      : TUnique;
      FDependencias : TDependencia;
      FTabelas: TDataSet;
      procedure SetDataSet(AValue: TDataSet);
    private
      procedure SetPK(AValue: String);
      property Tabela: TDataSet read FTabelas write SetDataSet;
    public
      constructor Create;
      procedure primeiro;
      procedure proximo;
      function EOF: Boolean;
      function Vazio: Boolean;
      function Selecionada: Boolean;
      property PK : String read FPK;
      property campo : Tcampos read Fcampos write Fcampos;
      property Relacionamento : TForeignKeys read FForeignKeys write FForeignKeys;
      property Unique : TUnique read FUnique write FUnique;
      property Dependencias : TDependencia read FDependencias write FDependencias;
      function Nome(CalmeCase: Boolean = False): String;
    end;

implementation

uses udm, SGDB_Ctrl;

{ TUnique }

procedure TUnique.SetDataSet(AValue: TDataSet);
begin

end;

constructor TUnique.Create(sTabela: String);
begin
  if not(Trim(sTabela) <> '') then
    raise Exception.Create('Nome tabela não definido!');

  Self.FTabela := sTabela;
  Self.SetDataSet(dm.Unique);
  Self.primeiro;
end;

procedure TUnique.primeiro;
begin
  try
    dm.Unique.First;
  except
  end;
end;

procedure TUnique.proximo;
begin
  try
    dm.Unique.Next;
  except
  end;
end;

function TUnique.EOF: Boolean;
begin
  try
    result := dm.Unique.EOF;
  except
    result := true;
  end;
end;

function TUnique.Vazio: Boolean;
begin
  try
    Result := dm.Unique.IsEmpty;
  except
    Result := False;
  end;
end;

function TUnique.count: Integer;
begin
  try
    Result := dm.Unique.RecordCount;
  except
    Result := 0;
  end;
end;

function TUnique.FK_NAME(CalmeCase: Boolean): String;
begin
  try
    if CalmeCase then
      Result := UpperCase(copy(dm.Unique.FieldByName('FK_NAME').AsString, 1,1))+ LowerCase(copy(dm.Unique.FieldByName('FK_NAME').AsString, 2, length(dm.Unique.FieldByName('FK_NAME').AsString)))
    else
      Result := LowerCase(dm.Unique.FieldByName('FK_NAME').AsString);
  except
    Result := '';
  end;
end;

function TUnique.FIELD(CalmeCase: Boolean): String;
begin
   try
    if CalmeCase then
      Result := UpperCase(copy(dm.Unique.FieldByName('FIELD').AsString, 1,1))+ LowerCase(copy(dm.Unique.FieldByName('FIELD').AsString, 2, length(dm.Unique.FieldByName('FIELD').AsString)))
    else
      Result := LowerCase(dm.Unique.FieldByName('FIELD').AsString);
  except
    Result := '';
  end;
end;

function TUnique.FK_TABLE(CalmeCase: Boolean): String;
begin
  try
    if CalmeCase then
      Result := UpperCase(copy(dm.Unique.FieldByName('FK_TABLE').AsString, 1,1))+ LowerCase(copy(dm.Unique.FieldByName('FK_TABLE').AsString, 2, length(dm.Unique.FieldByName('FK_TABLE').AsString)))
    else
      Result := LowerCase(dm.Unique.FieldByName('FK_TABLE').AsString);
  except
    Result := '';
  end;
end;

function TUnique.FK_FIELD(CalmeCase: Boolean): String;
begin
  try
    if CalmeCase then
      Result := UpperCase(copy(dm.Unique.FieldByName('FK_FIELD').AsString, 1,1))+ LowerCase(copy(dm.Unique.FieldByName('FK_FIELD').AsString, 2, length(dm.Unique.FieldByName('FK_FIELD').AsString)))
    else
      Result := LowerCase(dm.Unique.FieldByName('FK_FIELD').AsString);
  except
    Result := '';
  end;
end;

function TUnique.UPDATE: String;
begin
  Result := '';
end;

function TUnique.DELETE: String;
begin
  Result := '';
end;

{ TDependencia }

procedure TDependencia.SetDataSet(AValue: TDataSet);
begin
  if FDependencia = AValue then
    Exit;

  FDependencia := AValue;
end;

constructor TDependencia.Create(sTabela: String);
begin
  if not(Trim(sTabela) <> '') then
    raise Exception.Create('Nome tabela não definido!');

  Self.FTabela := sTabela;
  Self.SetDataSet(dm.Dependencias);
  Self.primeiro;
end;

procedure TDependencia.primeiro;
begin
  try
    dm.Dependencias.First;
  except
  end;
end;

procedure TDependencia.proximo;
begin
  try
    dm.Dependencias.Next;
  except
  end;
end;

function TDependencia.EOF: Boolean;
begin
  try
    Result := dm.Dependencias.EOF;
  except
    Result := True;
  end;
end;

function TDependencia.Vazio: Boolean;
begin
  try
    Result := dm.Dependencias.IsEmpty;
  except
    Result := False;
  end;
end;

function TDependencia.count: Integer;
begin
  try
    Result := dm.Dependencias.RecordCount;
  except
    Result := 0;
  end;
end;

function TDependencia.TABELA(CalmeCase: Boolean): String;
begin
  try
    if CalmeCase then
      Result := UpperCase(copy(dm.Dependencias.FieldByName('TABELA').AsString, 1,1))+ LowerCase(copy(dm.Dependencias.FieldByName('TABELA').AsString, 2, length(dm.Dependencias.FieldByName('TABELA').AsString)))
    else
      Result := LowerCase(dm.Dependencias.FieldByName('TABELA').AsString);
  except
    Result := '';
  end;
end;

function TDependencia.FIELD(CalmeCase: Boolean): String;
begin
  try
    if CalmeCase then
      Result := UpperCase(copy(dm.Dependencias.FieldByName('FIELD').AsString, 1,1))+ LowerCase(copy(dm.Dependencias.FieldByName('FIELD').AsString, 2, length(dm.Dependencias.FieldByName('FIELD').AsString)))
    else
      Result := LowerCase(dm.Dependencias.FieldByName('FIELD').AsString);
  except
    Result := '';
  end;
end;

function TDependencia.CONSTRAINT(CalmeCase: Boolean): String;
begin
  try
    if CalmeCase then
      Result := UpperCase(copy(dm.Dependencias.FieldByName('CONSTRAINT').AsString, 1,1))+ LowerCase(copy(dm.Dependencias.FieldByName('CONSTRAINT').AsString, 2, length(dm.Dependencias.FieldByName('CONSTRAINT').AsString)))
    else
      Result := LowerCase(dm.Dependencias.FieldByName('CONSTRAINT').AsString);
  except
    Result := '';
  end;
end;

function TDependencia.FIELD_REF(CalmeCase: Boolean): String;
begin
  try
    if CalmeCase then
      Result := UpperCase(copy(dm.Dependencias.FieldByName('FIELD_REF').AsString, 1,1))+ LowerCase(copy(dm.Dependencias.FieldByName('FIELD_REF').AsString, 2, length(dm.Dependencias.FieldByName('FIELD_REF').AsString)))
    else
      Result := LowerCase(dm.Dependencias.FieldByName('FIELD_REF').AsString);
  except
    Result := '';
  end;
end;

{ TForeignKeys }

procedure TForeignKeys.SetDataSet(AValue: TDataSet);
begin
  if FRelacionamento = AValue then
    Exit;

  FRelacionamento := AValue
end;

constructor TForeignKeys.Create(sTabela: String);
begin
  if not(Trim(sTabela) <> '') then
    raise Exception.Create('Nome tabela não definido!');

  Self.FTabela := sTabela;
  Self.SetDataSet(dm.ForeignKeys);
  Self.primeiro;
end;

procedure TForeignKeys.primeiro;
begin
  try
    dm.ForeignKeys.First;
  except
  end;
end;

procedure TForeignKeys.proximo;
begin
  try
    dm.ForeignKeys.Next;
  except
  end;
end;

function TForeignKeys.EOF: Boolean;
begin
  try
    Result := dm.ForeignKeys.EOF;
  except
    Result := True;
  end;
end;

function TForeignKeys.Vazio: Boolean;
begin
  try
    Result := dm.ForeignKeys.IsEmpty;
  except
    Result := False;
  end;
end;

function TForeignKeys.count: Integer;
begin
  try
    Result := dm.ForeignKeys.RecordCount;
  except
    Result := 0;
  end;
end;

function TForeignKeys.FK_NAME(CalmeCase: Boolean): String;
begin
  try
    if CalmeCase then
      Result := UpperCase(copy(dm.ForeignKeys.FieldByName('FK_NAME').AsString, 1,1))+ LowerCase(copy(dm.ForeignKeys.FieldByName('FK_NAME').AsString, 2, length(dm.ForeignKeys.FieldByName('FK_NAME').AsString)))
    else
      Result := LowerCase(dm.ForeignKeys.FieldByName('FK_NAME').AsString);
  except
    Result := '';
  end;
end;

function TForeignKeys.FIELD(CalmeCase: Boolean): String;
begin
  try
    if CalmeCase then
      Result := UpperCase(copy(dm.ForeignKeys.FieldByName('FIELD').AsString, 1,1))+ LowerCase(copy(dm.ForeignKeys.FieldByName('FIELD').AsString, 2, length(dm.ForeignKeys.FieldByName('FIELD').AsString)))
    else
      Result := LowerCase(dm.ForeignKeys.FieldByName('FIELD').AsString);
  except
    Result := '';
  end;
end;

function TForeignKeys.FK_TABLE(CalmeCase: Boolean): String;
begin
  try
    if CalmeCase then
      Result := UpperCase(copy(dm.ForeignKeys.FieldByName('FK_TABLE').AsString, 1,1))+ LowerCase(copy(dm.ForeignKeys.FieldByName('FK_TABLE').AsString, 2, length(dm.ForeignKeys.FieldByName('FK_TABLE').AsString)))
    else
      Result := LowerCase(dm.ForeignKeys.FieldByName('FK_TABLE').AsString);
  except
    Result := '';
  end;
end;

function TForeignKeys.FK_FIELD(CalmeCase: Boolean): String;
begin
  try
    if CalmeCase then
      Result := UpperCase(copy(dm.ForeignKeys.FieldByName('FK_FIELD').AsString, 1,1))+ LowerCase(copy(dm.ForeignKeys.FieldByName('FK_FIELD').AsString, 2, length(dm.ForeignKeys.FieldByName('FK_FIELD').AsString)))
    else
      Result := LowerCase(dm.ForeignKeys.FieldByName('FK_FIELD').AsString);
  except
    Result := '';
  end;
end;

function TForeignKeys.UPDATE: String;
begin
  try
    Result := UpperCase(dm.ForeignKeys.FieldByName('UPDATE').AsString);
  except
    Result := '';
  end;
end;

function TForeignKeys.DELETE: String;
begin
  try
    Result := UpperCase(dm.ForeignKeys.FieldByName('DELETE').AsString);
  except
    Result := '';
  end;
end;

{ Tcampos }

procedure TCampos.SetDataSet(AValue: TDataSet);
begin
  if Fcampo = AValue then
    Exit;

  Fcampo := AValue;
end;

constructor TCampos.Create(sTabela: String);
begin
  if not(Trim(sTabela) <> '') then
    raise Exception.Create('Nome tabela não definido!');

  Self.FTabela := sTabela;
  Self.SetDataSet(dm.Fields);
  Self.primeiro;
end;

procedure TCampos.primeiro;
begin
  try
    dm.Fields.First;
  except
  end;
end;

procedure TCampos.proximo;
begin
  try
    dm.Fields.Next;
  except
  end;
end;

function TCampos.EOF: Boolean;
begin
  try
    Result := dm.Fields.EOF;
  except
    Result := True;
  end;
end;

function TCampos.Vazio: Boolean;
begin
  try
    Result := dm.Fields.IsEmpty;
  except
    Result := False;
  end;
end;

function TCampos.count: Integer;
begin
  try
    Result := dm.Fields.RecordCount;
  except
    Result := 0;
  end;
end;

function TCampos.PK: String;
begin
  try
    Result := dm.Fields.FieldByName('chave').AsString;
  except
    Result := '';
  end;
end;

function TCampos.Nome(CalmeCase: Boolean): String;
begin
  try
    if CalmeCase then
      Result := UpperCase(copy(dm.Fields.FieldByName('CAMPO').AsString, 1,1))+ LowerCase(copy(dm.Fields.FieldByName('CAMPO').AsString, 2, length(dm.Fields.FieldByName('CAMPO').AsString)))
    else
      Result := LowerCase(dm.Fields.FieldByName('CAMPO').AsString);
  except
    Result := '';
  end;
end;

function TCampos.Value: Variant;
begin
  try
    if (Self.Tipo = 'String') or
    (Self.Tipo = 'BLOB') or
    (Self.Tipo = 'Real') or
    (Self.Tipo = 'Extended') or
    (Self.Tipo = 'Double') or
    (Self.Tipo = 'Decimal') or
    (Self.Tipo = 'TTime') or
    (Self.Tipo = 'TDate') or
    (Self.Tipo = 'TDateTime')
    then
    begin
      if dm.Zqry.FieldByName(dm.Fields.FieldByName('CAMPO').AsString).AsString <> '' then
        Result := '*              "'+Self.Nome + '": "'+dm.Zqry.FieldByName(dm.Fields.FieldByName('CAMPO').AsString).AsString+'"'
      else
        Result := '*              "'+Self.Nome + '": null';
    end
    else if (Self.Tipo = 'Boolean') or
    (Self.Tipo = 'BigInt') or
    (Self.Tipo = 'Integer')
    then
    begin
      if dm.Zqry.FieldByName(dm.Fields.FieldByName('CAMPO').AsString).AsString <> '' then
        Result := '*              "'+Self.Nome + '": '+ dm.Zqry.FieldByName(dm.Fields.FieldByName('CAMPO').AsString).AsString
      else
        Result := '*              "'+Self.Nome + '": null';
    end
    else
    begin
      if dm.Zqry.FieldByName(dm.Fields.FieldByName('CAMPO').AsString).AsString <> '' then
        Result := '*              "'+Self.Nome + '": "'+dm.Zqry.FieldByName(dm.Fields.FieldByName('CAMPO').AsString).AsString+'"'
      else
        Result := '*              "'+Self.Nome + '": null';
    end;
  except
    Result := '';
  end;
end;

function TCampos.TodosFields: String;
var
  scampos, sVirgula : String;
begin
  try
    try
      scampos  := '';
      sVirgula := '';
      Self.primeiro;
      while not Self.Eof do
      begin
        try
          scampos  := scampos + sVirgula + dm.Fields.FieldByName('CAMPO').AsString;
          sVirgula := ', ';
        finally
          Self.proximo;
        end;
      end;
      Result := scampos;
    except
      Result := '';
    end;
  finally
    Self.primeiro;
  end;
end;

function TCampos.Tipo: String;
var
  sTipo: String;
begin
  try
    if LowerCase(dm.Fields.FieldByName('TIPO').AsString) = 'desconhecido' then
    begin
      ShowMessage(Self.FTabela);
      sTipo  := 'String';//InputBox('Type?',Self.FTabela+'.'+dm.Fields.FieldByName('CAMPO').AsString+': ','');
      dm.Fields.Edit;
      dm.Fields.FieldByName('TIPO').AsString := sTipo;
      dm.Fields.Post;
      Result := sTipo;
    end
    else
      Result := dm.Fields.FieldByName('TIPO').AsString;
  except
    Result := '';
  end;
end;

function TCampos.NotNull: Boolean;
begin
  try
    Result := dm.Fields.FieldByName('notnull').AsBoolean;
  except
    Result := False;
  end;
end;

function TCampos.isUnique: Boolean;
begin
  try
    Result := dm.Fields.FieldByName('unique').AsBoolean;
  except
    Result := False;
  end;
end;

function TCampos.Tamanho: Integer;
begin
  try
    Result := dm.Fields.FieldByName('campo_tamanho').AsInteger;
  except
    Result := 0;
  end;
end;

{ TTabela }

procedure TCodeBuildingTabela.SetDataSet(AValue: TDataSet);
begin
  if FTabelas = AValue then
    Exit;

  FTabelas := AValue;
end;

procedure TCodeBuildingTabela.SetPK(AValue: String);
begin
  if FPK = AValue then
    Exit;

  FPK := AValue;
end;

constructor TCodeBuildingTabela.Create;
begin
  Self.SetDataSet(dm.Tabelas);

  if Self.Vazio then
    raise Exception.Create('Nenhuma tabela encontrada');

  if not Assigned(Fcampos) then
    Fcampos := Tcampos.Create(Self.Nome);

  if not Assigned(FDependencias) then
    FDependencias := TDependencia.Create(Self.Nome);

  if not Assigned(FForeignKeys) then
    FForeignKeys := TForeignKeys.Create(Self.Nome);

  if not Assigned(FUnique) then
    FUnique := TUnique.Create(Self.Nome);

  Self.primeiro;

  Self.SetPK(Self.campo.PK);
end;

procedure TCodeBuildingTabela.primeiro;
begin
  try
    if Assigned(FCampos) then
      FreeAndNil(FCampos);

    if Assigned(FForeignKeys) then
      FreeAndNil(FForeignKeys);

    if Assigned(FUnique) then
      FreeAndNil(FUnique);

    Self.Tabela.First;

    if not Assigned(Fcampos) then
      Fcampos := Tcampos.Create(Self.Nome);

    if not Assigned(FForeignKeys) then
      FForeignKeys := TForeignKeys.Create(Self.Nome);

    if not Assigned(FUnique) then
      FUnique := TUnique.Create(Self.Nome);

    Self.SetPK(Self.campo.PK);
  except
  end;
end;

procedure TCodeBuildingTabela.proximo;
begin
  try
    if Assigned(FCampos) then
      FreeAndNil(FCampos);

    if Assigned(FForeignKeys) then
      FreeAndNil(FForeignKeys);

    if Assigned(FUnique) then
      FreeAndNil(FUnique);

    Self.Tabela.Next;

    if not Assigned(Fcampos) then
      Fcampos := Tcampos.Create(Self.Nome);

    if not Assigned(FForeignKeys) then
      FForeignKeys := TForeignKeys.Create(Self.Nome);

    if not Assigned(FUnique) then
      FUnique := TUnique.Create(Self.Nome);

    Self.SetPK(Self.campo.PK);
  except
  end;
end;

function TCodeBuildingTabela.EOF: Boolean;
begin
  try
    Result := Self.Tabela.EOF;
  except
    Result := True;
  end;
end;

function TCodeBuildingTabela.Vazio: Boolean;
begin
  try
    Result := Self.Tabela.IsEmpty;
  except
    Result := False;
  end;
end;

function TCodeBuildingTabela.Selecionada: Boolean;
begin
  try
    Result := Self.Tabela.Fields[0].AsBoolean;
  except
    Result := False;
  end;
end;

function TCodeBuildingTabela.Nome(CalmeCase: Boolean = False): String;
begin
  try
    if CalmeCase then
      Result := UpperCase(copy(Self.Tabela.FieldByName('nome').AsString, 1,1))+ LowerCase(copy(dm.Tabelas.FieldByName('nome').AsString, 2, length(dm.Tabelas.FieldByName('nome').AsString)))
    else
      Result := LowerCase(Self.Tabela.FieldByName('nome').AsString);
  except
    Result := '';
  end;
end;

end.

