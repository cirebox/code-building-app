unit TypeCodeBuilding;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TSGDB      = (firebird, mysql, postgres);
  TLinguagem = (php, delphi, lazarus, java);
  TPadrao    = (DesignPattern, MVC);

function SgdbToStr(SGDB: TSGDB): String;
function StrToSgdb(SGDB: String): TSGDB;
function LinguagemToStr(Ling: TLinguagem): String;
function StrToLinguagem(Ling: String): TLinguagem;


implementation

function SgdbToStr(SGDB: TSGDB): String;
begin
  case SGDB of
    firebird: Result := 'firebird';
    mysql   : Result := 'mysql';
    postgres: Result := 'postgres';
  end;
end;

function StrToSgdb(SGDB: String): TSGDB;
begin
  SGDB := Lowercase(Trim(SGDB));
  if SGDB = 'firebird' then
    Result := firebird
  else if SGDB = 'mysql' then
    Result := mysql
  else if SGDB = 'postgres' then
    Result := postgres
  else
    Result := firebird;
end;

function LinguagemToStr(Ling: TLinguagem): String;
begin
  case Ling of
    php    : Result := 'php';
    delphi : Result := 'delphi';
    lazarus: Result := 'lazarus';
    java   : Result := 'java';
  end;
end;

function StrToLinguagem(Ling: String): TLinguagem;
begin
  Ling := Lowercase(Trim(Ling));
  if Ling = 'php' then
    Result := php
  else if Ling = 'delphi' then
    Result := delphi
  else if Ling = 'lazarus' then
    Result := lazarus
  else if Ling = 'java' then
    Result := java
  else
    Result := delphi;
end;

end.

