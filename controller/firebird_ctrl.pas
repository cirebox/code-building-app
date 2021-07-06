unit Firebird_Ctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, TypeCodeBuilding;

type

  { TFirebird_Ctrl }

  TFirebird_Ctrl = class
    strict private
      class var FInstance: TFirebird_Ctrl;
      constructor CreatePrivate;
    private
    public
      constructor Create;
      destructor  Destroy; override;
      class function GetInstance: TFirebird_Ctrl;
      function GetDados(sTabela: String): String;
      function GetSQL_Tabelas: String;
      function GetSQL_Fields(sTabela: String): String;
      function GetSQL_Relacionamento(sTabela: String): String;
      function GetSQL_Unique(sTabela: String): String;
  end;


implementation

{ TFirebird_Ctrl }

constructor TFirebird_Ctrl.CreatePrivate;
begin
  inherited Create;
end;

constructor TFirebird_Ctrl.Create;
begin
  raise Exception.Create('Objeto Singleton');
end;

destructor TFirebird_Ctrl.Destroy;
begin
  inherited Destroy;
end;

class function TFirebird_Ctrl.GetInstance: TFirebird_Ctrl;
begin
  if not Assigned(FInstance) then
    FInstance := TFirebird_Ctrl.CreatePrivate;

  Result := FInstance;
end;

function TFirebird_Ctrl.GetDados(sTabela: String): String;
begin
  Result := 'select first 1 * from '+sTabela;
end;

function TFirebird_Ctrl.GetSQL_Tabelas: String;
begin
  Result := 'select rdb$relation_name AS TABELA from rdb$relations where rdb$system_flag = 0 ORDER BY rdb$relation_name';
end;

function TFirebird_Ctrl.GetSQL_Fields(sTabela: String): String;
begin
  Result := ' SELECT '+
            ' DISTINCT '+
            ' CAMPOS.RDB$FIELD_NAME AS CAMPO, '+
            ' CASE'+
            ' WHEN SUBSTRING (DADOSCAMPO.RDB$FIELD_NAME FROM  1 FOR 4) NOT IN (''IBE$'', ''MON$'', ''RDB$'') THEN'+
            '   COALESCE(DADOSCAMPO.RDB$NULL_FLAG,0)'+
            ' WHEN CAMPOS.RDB$NULL_FLAG = 1 THEN'+
            '   1'+
            ' ELSE'+
            '   0'+
            ' END AS NOTNULL,'+
            ' DADOSCAMPO.RDB$FIELD_LENGTH AS CAMPO_TAMANHO, '+
            '  '+
            ' CASE '+
            ' WHEN '+
            ' DADOSCAMPO.RDB$FIELD_PRECISION > 0 THEN     ''Real'' '+
            ' WHEN TIPOS.RDB$TYPE_NAME =     ''LONG''     THEN     ''Integer'' '+
            ' WHEN TIPOS.RDB$TYPE_NAME =     ''SHORT''     THEN     ''Integer'' '+
            ' WHEN TIPOS.RDB$TYPE_NAME =     ''INT64''     THEN     ''Real'' '+
            ' WHEN TIPOS.RDB$TYPE_NAME =     ''VARYING''     THEN    ''String'' '+
            ' WHEN TIPOS.RDB$TYPE_NAME =     ''TEXT''     THEN     ''String'' '+
            ' WHEN TIPOS.RDB$TYPE_NAME =     ''DOUBLE''     THEN     ''Real'' '+
            ' WHEN TIPOS.RDB$TYPE_NAME =     ''FLOAT''     THEN     ''Real'' '+
            ' WHEN TIPOS.RDB$TYPE_NAME =     ''TIMESTAMP''     THEN     ''TTime'' '+
            ' WHEN TIPOS.RDB$TYPE_NAME =     ''TIME''    THEN     ''TTime'' '+
            ' WHEN TIPOS.RDB$TYPE_NAME =     ''DATE''     THEN     ''TDate'' '+
            ' WHEN TIPOS.RDB$TYPE_NAME =     ''BLOB''     THEN     ''BLOB'' '+
            ' ELSE '+
            '  ''Desconhecido'' '+
            ' END AS TIPO, '+
            '  '+
            ' CASE '+
            ' WHEN '+
            ' DADOSCAMPO.RDB$FIELD_PRECISION > 0 THEN 2 '+
            ' WHEN TIPOS.RDB$TYPE_NAME =     ''LONG''     THEN 0 '+
            ' WHEN TIPOS.RDB$TYPE_NAME =     ''SHORT''     THEN 0 '+
            ' WHEN TIPOS.RDB$TYPE_NAME =     ''INT64''     THEN 0 '+
            ' WHEN TIPOS.RDB$TYPE_NAME =     ''VARYING''     THEN 1 '+
            ' WHEN TIPOS.RDB$TYPE_NAME =     ''TEXT''     THEN 1 '+
            ' WHEN TIPOS.RDB$TYPE_NAME =     ''DOUBLE''     THEN 2 '+
            ' WHEN TIPOS.RDB$TYPE_NAME =     ''FLOAT''     THEN 2 '+
            ' WHEN TIPOS.RDB$TYPE_NAME =     ''DATE''     THEN 3 '+
            ' WHEN TIPOS.RDB$TYPE_NAME =     ''TIMESTAMP''     THEN 3 '+
            ' WHEN TIPOS.RDB$TYPE_NAME =     ''BLOB''     THEN 4 '+
            ' else ' +
            ' ''Desconhecido'' '+
            ' END AS STATUS, '+
            '  '+
            ' (SELECT FIRST 1 RDB$FIELD_NAME '+
            '  '+
            ' FROM '+
            '  '+
            ' RDB$RELATION_CONSTRAINTS C, '+
            '  '+
            ' RDB$INDEX_SEGMENTS S '+
            '  '+
            ' WHERE C.RDB$RELATION_NAME = ' + QuotedStr(sTabela) + ' '+
            '  '+
            ' AND C.RDB$CONSTRAINT_TYPE = ''PRIMARY KEY'' '+
            '  '+
            ' AND S.RDB$INDEX_NAME = C.RDB$INDEX_NAME '+
            '  '+
            ' ORDER BY RDB$FIELD_POSITION) AS CHAVE '+
            '  '+
            ' FROM '+
            ' RDB$RELATIONS TABELAS, RDB$RELATION_FIELDS CAMPOS, RDB$FIELDS DADOSCAMPO, RDB$TYPES TIPOS '+
            ' WHERE TABELAS.RDB$RELATION_NAME = ' + QuotedStr(sTabela) +
            ' AND TIPOS.RDB$FIELD_NAME = ''RDB$FIELD_TYPE'' '+
            ' AND TABELAS.RDB$RELATION_NAME = CAMPOS.RDB$RELATION_NAME AND '+
            ' CAMPOS.RDB$FIELD_SOURCE = DADOSCAMPO.RDB$FIELD_NAME AND '+
            ' DADOSCAMPO.RDB$FIELD_TYPE = TIPOS.RDB$TYPE '+
            ' ORDER BY '+
            ' CAMPOS.RDB$FIELD_POSITION ';
end;

function TFirebird_Ctrl.GetSQL_Relacionamento(sTabela: String): String;
begin
  Result := ' SELECT rc.RDB$CONSTRAINT_NAME as fk_name,'+
            '          s.RDB$FIELD_NAME AS field,'+
            '          refc.RDB$UPDATE_RULE AS "Update",'+
            '          refc.RDB$DELETE_RULE AS "Delete",'+
            '          i2.RDB$RELATION_NAME AS fk_table,'+
            '          s2.RDB$FIELD_NAME AS fk_field'+
            '     FROM RDB$INDEX_SEGMENTS s'+
            ' LEFT JOIN RDB$INDICES i ON i.RDB$INDEX_NAME = s.RDB$INDEX_NAME'+
            ' LEFT JOIN RDB$RELATION_CONSTRAINTS rc ON rc.RDB$INDEX_NAME = s.RDB$INDEX_NAME'+
            ' LEFT JOIN RDB$REF_CONSTRAINTS refc ON rc.RDB$CONSTRAINT_NAME = refc.RDB$CONSTRAINT_NAME'+
            ' LEFT JOIN RDB$RELATION_CONSTRAINTS rc2 ON rc2.RDB$CONSTRAINT_NAME = refc.RDB$CONST_NAME_UQ'+
            ' LEFT JOIN RDB$INDICES i2 ON i2.RDB$INDEX_NAME = rc2.RDB$INDEX_NAME'+
            ' LEFT JOIN RDB$INDEX_SEGMENTS s2 ON i2.RDB$INDEX_NAME = s2.RDB$INDEX_NAME'+
            '    WHERE i.RDB$RELATION_NAME='+QuotedStr(sTabela)+
            '      and rc.RDB$CONSTRAINT_TYPE = ''FOREIGN KEY'''+
            '      AND rc.RDB$CONSTRAINT_TYPE IS NOT NULL'+
            ' ORDER BY s.RDB$FIELD_POSITION';
end;

function TFirebird_Ctrl.GetSQL_Unique(sTabela: String): String;
begin
  Result := ' SELECT rc.RDB$CONSTRAINT_NAME as fk_name,'+
            '          s.RDB$FIELD_NAME AS field,'+
            '          refc.RDB$UPDATE_RULE AS "Update",'+
            '          refc.RDB$DELETE_RULE AS "Delete",'+
            '          i2.RDB$RELATION_NAME AS fk_table,'+
            '          s2.RDB$FIELD_NAME AS fk_field'+
            '     FROM RDB$INDEX_SEGMENTS s'+
            ' LEFT JOIN RDB$INDICES i ON i.RDB$INDEX_NAME = s.RDB$INDEX_NAME'+
            ' LEFT JOIN RDB$RELATION_CONSTRAINTS rc ON rc.RDB$INDEX_NAME = s.RDB$INDEX_NAME'+
            ' LEFT JOIN RDB$REF_CONSTRAINTS refc ON rc.RDB$CONSTRAINT_NAME = refc.RDB$CONSTRAINT_NAME'+
            ' LEFT JOIN RDB$RELATION_CONSTRAINTS rc2 ON rc2.RDB$CONSTRAINT_NAME = refc.RDB$CONST_NAME_UQ'+
            ' LEFT JOIN RDB$INDICES i2 ON i2.RDB$INDEX_NAME = rc2.RDB$INDEX_NAME'+
            ' LEFT JOIN RDB$INDEX_SEGMENTS s2 ON i2.RDB$INDEX_NAME = s2.RDB$INDEX_NAME'+
            '    WHERE i.RDB$RELATION_NAME='+QuotedStr(sTabela)+
            '      and rc.RDB$CONSTRAINT_TYPE = ''UNIQUE'''+
            '      AND rc.RDB$CONSTRAINT_TYPE IS NOT NULL'+
            ' ORDER BY s.RDB$FIELD_POSITION';
end;

end.

