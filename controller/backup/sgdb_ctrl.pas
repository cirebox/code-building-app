unit SGDB_Ctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, TypeCodeBuilding;

type

  { TSGDB_Ctrl }

  TSGDB_Ctrl = class
    strict private
      FSGDB : TSGDB;
      class var FInstance: TSGDB_Ctrl;
      constructor CreatePrivate;
    private
    public
      constructor Create;
      destructor  Destroy; override;
      class function GetInstance: TSGDB_Ctrl;
      function GetDados(sTabela: String): String;
      function GetSQL_Tabelas: String;
      function GetSQL_Fields(sTabela: String): String;
      function GetSQL_Relacionamento(sTabela: String): String;
      function GetSQL_Unique(sTabela: String): String;
      function GetSQL_Dependencias(sTabela: String): String;
      function GetSQL_Bancos:String;
  end;


implementation

uses CodeBuilding, PostGres_Ctrl, Firebird_Ctrl, MySql_Ctrl, udm;

{ TSGDB_Ctrl }

constructor TSGDB_Ctrl.CreatePrivate;
begin
  inherited Create;
end;

constructor TSGDB_Ctrl.Create;
begin
  raise Exception.Create('Objeto Singleton');
end;

destructor TSGDB_Ctrl.Destroy;
begin
  inherited Destroy;
end;

class function TSGDB_Ctrl.GetInstance: TSGDB_Ctrl;
begin
  if not Assigned(FInstance) then
    FInstance := TSGDB_Ctrl.CreatePrivate;

  FInstance.FSGDB := dm.CodeBuilding.Conexao.SGDB;

  Result := FInstance;
end;

function TSGDB_Ctrl.GetDados(sTabela: String): String;
begin
  case FSGDB of
    firebird: Result := TFirebird_Ctrl.GetInstance.GetDados(sTabela);
    mysql   : Result := TMySql_Ctrl.GetInstance.GetDados(sTabela);
    postgres: Result := TPostGres_Ctrl.GetInstance.GetDados(sTabela);
  end;
end;

function TSGDB_Ctrl.GetSQL_Tabelas: String;
begin
  case FSGDB of
    firebird: Result := TFirebird_Ctrl.GetInstance.GetSQL_Tabelas;
    mysql   : Result := TMySql_Ctrl.GetInstance.GetSQL_Tabelas;
    postgres: Result := TPostGres_Ctrl.GetInstance.GetSQL_Tabelas;
  end;
end;

function TSGDB_Ctrl.GetSQL_Fields(sTabela: String): String;
begin
  case FSGDB of
    firebird: Result := TFirebird_Ctrl.GetInstance.GetSQL_Fields(sTabela);
    mysql   : Result := TMySql_Ctrl.GetInstance.GetSQL_Fields(sTabela);
    postgres: Result := TPostGres_Ctrl.GetInstance.GetSQL_Fields(sTabela);
  end;
end;

function TSGDB_Ctrl.GetSQL_Relacionamento(sTabela: String): String;
begin
  case FSGDB of
    firebird: Result := TFirebird_Ctrl.GetInstance.GetSQL_Relacionamento(sTabela);
    mysql   : raise Exception.Create('Não existe este método');
    postgres: Result := TPostGres_Ctrl.GetInstance.GetSQL_Relacionamento(sTabela);
  end;
end;

function TSGDB_Ctrl.GetSQL_Unique(sTabela: String): String;
begin
  case FSGDB of
    firebird: Result := TFirebird_Ctrl.GetInstance.GetSQL_Unique(sTabela);
    mysql   : raise Exception.Create('Não existe este método');
    postgres: Result := TPostGres_Ctrl.GetInstance.GetSQL_Unique(sTabela);
  end;
end;

function TSGDB_Ctrl.GetSQL_Dependencias(sTabela: String): String;
begin
  case FSGDB of
    firebird: raise Exception.Create('Não existe este método');
    mysql   : raise Exception.Create('Não existe este método');
    postgres: Result := TPostGres_Ctrl.GetInstance.GetSQL_Dependencias(sTabela);
  end;
end;

function TSGDB_Ctrl.GetSQL_Bancos: String;
begin
  case FSGDB of
    firebird: raise Exception.Create('Não existe este método');
    mysql   : Result := TMySql_Ctrl.GetInstance.GetSQL_Bancos;
    postgres: Result := TPostGres_Ctrl.GetInstance.GetSQL_Bancos;
  end;
end;

end.

