unit MySql_Ctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, TypeCodeBuilding;

type

  { TMySql_Ctrl }

  TMySql_Ctrl = class
    strict private
      class var FInstance: TMySql_Ctrl;
      constructor CreatePrivate;
    private
    public
      constructor Create;
      destructor  Destroy; override;
      class function GetInstance: TMySql_Ctrl;
      function GetDados(sTabela: String): String;
      function GetSQL_Tabelas: String;
      function GetSQL_Fields(sTabela: String): String;
      function GetSQL_Bancos: String;
  end;


implementation

uses Firebird_Ctrl;

{ TConexao }

constructor TMySql_Ctrl.CreatePrivate;
begin
  inherited Create;
end;

constructor TMySql_Ctrl.Create;
begin
  raise Exception.Create('Objeto Singleton');
end;

destructor TMySql_Ctrl.Destroy;
begin
  inherited Destroy;
end;

class function TMySql_Ctrl.GetInstance: TMySql_Ctrl;
begin
  if not Assigned(FInstance) then
    FInstance := TMySql_Ctrl.CreatePrivate;

  Result := FInstance;
end;

function TMySql_Ctrl.GetDados(sTabela: String): String;
begin
  Result := 'select * from '+sTabela + ' limit 1';
end;

function TMySql_Ctrl.GetSQL_Tabelas: String;
begin
  Result := 'select table_name as tabela from information_schema.tables where table_schema = database();';
end;

function TMySql_Ctrl.GetSQL_Fields(sTabela: String): String;
begin
  Result :=' SELECT   '+
           '  COLUMN_NAME as CAMPO,  '+
           '  if(is_nullable = ''NO'',True,False) as NOTNULL, '+
           '  CASE   '+
           '  WHEN DATA_TYPE = ''int'' then  '+
           '    ''Integer''  '+
           '  WHEN DATA_TYPE = ''tinyint'' then  '+
           '    ''Integer''  '+
           '  WHEN DATA_TYPE = ''bigint'' then  '+
           '    ''Integer''  '+
           '  WHEN DATA_TYPE = ''mediumint'' then  '+
           '    ''Integer''  '+
           '  WHEN DATA_TYPE = ''smallint'' then  '+
           '    ''Integer''  '+
           '  WHEN DATA_TYPE = ''varchar'' then  '+
           '    ''String''  '+
           '  WHEN DATA_TYPE = ''blob'' then  '+
           '    ''String''  '+
           '  WHEN DATA_TYPE = ''binary'' then  '+
           '    ''String''  '+
           '  WHEN DATA_TYPE = ''char'' then  '+
           '    ''String''  '+
           '  WHEN DATA_TYPE = ''text'' then  '+
           '    ''String''  '+
           '  WHEN DATA_TYPE = ''timestamp'' then  '+
           '    ''TDateTime''  '+
           '  WHEN DATA_TYPE = ''datetime'' then  '+
           '    ''TDateTime''  '+
           '  WHEN DATA_TYPE = ''date'' then  '+
           '    ''TDate''  '+
           '  WHEN DATA_TYPE = ''time'' then  '+
           '    ''TTime''  '+
           '  WHEN DATA_TYPE = ''decimal'' then  '+
           '    ''Extended''  '+
           '  WHEN DATA_TYPE = ''double'' then  '+
           '    ''Extended''  '+
           '  WHEN DATA_TYPE = ''float'' then  '+
           '    ''Extended''    '+
           '  else  '+
           '    ''Desconhecido''  '+
           '  end as TIPO,  '+
           '  coalesce(CHARACTER_MAXIMUM_LENGTH,0) as CAMPO_TAMANHO,  '+
           '  COALESCE((SELECT  COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS c  '+
           '   WHERE TABLE_SCHEMA = database() AND TABLE_NAME = '+QuotedStr(sTabela)+' AND COLUMN_KEY = ''PRI''),'''') as CHAVE,  '+
           '  COLUMN_COMMENT as comentario  '+
           ' FROM INFORMATION_SCHEMA.COLUMNS   '+
           ' WHERE TABLE_SCHEMA = database() AND TABLE_NAME = '+QuotedStr(sTabela);
end;

function TMySql_Ctrl.GetSQL_Bancos: String;
begin
  Result := 'show databases;';
end;

end.

