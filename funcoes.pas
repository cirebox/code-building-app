unit Funcoes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function getFieldNome: String;

implementation

uses udm;

function getFieldNome: String;
begin
  try
    result := LowerCase(dm.Fields.FieldByName('CAMPO').AsString);
  except
    result := '';
  end;
end;

end.

