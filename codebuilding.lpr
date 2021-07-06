program codebuilding;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, zcomponent, memdslaz, uprincipal, useleciona_banco, udm, Funcoes,
  SGDB_Ctrl, Firebird_Ctrl, MySql_Ctrl, NodeJS_Ctrl, PostGres_Ctrl,
  Sequelize_Ctrl
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='Code Building';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TFPrincipal, FPrincipal);
  Application.Run;
end.

