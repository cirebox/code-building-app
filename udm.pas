unit udm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, CodeBuildingClass, ZSqlProcessor, ZDataset,
  memds, db;

type

  { Tdm }

  Tdm = class(TDataModule)
    Banco: TMemDataset;
    Fields: TMemDataset;
    ForeignKeys: TMemDataset;
    Dependencias: TMemDataset;
    Dados: TMemDataset;
    Unique: TMemDataset;
    qryScript: TZSQLProcessor;
    Tabelas: TMemDataset;
    Zqry: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure TabelasAfterScroll(DataSet: TDataSet);
  private

  public
    CodeBuilding : TCodeBuilding;
  end;

var
  dm: Tdm;

implementation

uses uPrincipal, ConexaoCodeBuilding;

{$R *.lfm}

{ Tdm }

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  try
    CodeBuilding := TCodeBuilding.Create;
  finally
  end;
end;

procedure Tdm.TabelasAfterScroll(DataSet: TDataSet);
begin
  if not DataSet.IsEmpty then
  begin
    TConexaoCodeBuilding.GetInstance.ListarFields(DataSet.FieldByName('nome').AsString);
    TConexaoCodeBuilding.GetInstance.ListarRelacionamento(DataSet.FieldByName('nome').AsString);
    TConexaoCodeBuilding.GetInstance.ListarUnique(DataSet.FieldByName('nome').AsString);
    TConexaoCodeBuilding.GetInstance.ListarDependencias(DataSet.FieldByName('nome').AsString);

    if Trim(DataSet.FieldByName('nome').AsString) <> '' then
      TConexaoCodeBuilding.GetInstance.ListarDados(DataSet.FieldByName('nome').AsString);

    FPrincipal.lbTotalFields.Caption := 'Fields: ' + Fields.RecordCount.ToString();

    Unique.First;
    if not Unique.IsEmpty then
    begin
      while not Unique.EOF do
      begin
        Fields.First;
        while not Fields.EOF do
        begin
          if UpperCase(Unique.FieldByName('field').AsString) = UpperCase(Fields.FieldByName('campo').AsString) then
          begin
            Fields.Edit;
            Fields.FieldByName('Unique').AsBoolean := True;
            Fields.Post;
          end;
          Fields.Next;
        end;
        Unique.Next;
      end;
      Fields.First;
      Unique.First;
    end;
  end
  else
  begin
    Fields.Close;
    Fields.CreateTable;
    ForeignKeys.Close;
    ForeignKeys.CreateTable;
    Unique.Close;
    Unique.CreateTable;
    Dependencias.Close;
    Dependencias.CreateTable;
    Dados.Close;
    Dados.CreateTable;
  end;
end;

end.

