unit useleciona_banco;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ShortPathEdit, Forms, Controls, Graphics,
  Dialogs, Buttons, StdCtrls, TypeCodeBuilding;

type

  { TFSeleciona_Banco }

  TFSeleciona_Banco = class(TForm)
    btSalvar: TBitBtn;
    btCancelar: TBitBtn;
    btBuscaFirebird: TButton;
    cbBanco: TComboBox;
    edFirebird: TEdit;
    procedure btBuscaFirebirdClick(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  FSeleciona_Banco: TFSeleciona_Banco;

implementation

uses udm, ConexaoCodeBuilding;

{$R *.lfm}

{ TFSeleciona_Banco }

procedure TFSeleciona_Banco.btSalvarClick(Sender: TObject);
begin
  if dm.CodeBuilding.Conexao.SGDB = firebird then
    dm.CodeBuilding.Conexao.Banco := edFirebird.Text
  else
    dm.CodeBuilding.Conexao.Banco := cbBanco.Text;
  Close;
end;

procedure TFSeleciona_Banco.btCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TFSeleciona_Banco.btBuscaFirebirdClick(Sender: TObject);
var
  OpenDialgo : TOpenDialog;
begin
  try
    OpenDialgo := TOpenDialog.Create(Self);
    OpenDialgo.Filter := 'Firebid (.FDB)|*.FDB';
    if OpenDialgo.Execute then
      edFirebird.Text := OpenDialgo.FileName;
  finally
    FreeAndNil(OpenDialgo);
  end;
end;

procedure TFSeleciona_Banco.FormShow(Sender: TObject);
begin
  if dm.CodeBuilding.Conexao.SGDB = firebird then
  begin
    if dm.CodeBuilding.Conexao.Banco.Trim <> '' then
      edFirebird.Text       := dm.CodeBuilding.Conexao.Banco.Trim;
    edFirebird.Visible      := True;
    btBuscaFirebird.Visible := True;

  end
  else
  begin
    cbBanco.Clear;
    cbBanco.Visible:= True;
    if TConexaoCodeBuilding.GetInstance.ListarBancos then
    begin
      dm.Banco.First;
      while not dm.Banco.EOF do
      begin
        try
          cbBanco.Items.Add(dm.Banco.FieldByName('nome').AsString);
        finally
          dm.Banco.Next;
        end;
      end;
      if dm.CodeBuilding.Conexao.Banco.Trim <> '' then
        cbBanco.Text  := dm.CodeBuilding.Conexao.Banco.Trim;
    end;
  end;
end;

end.

