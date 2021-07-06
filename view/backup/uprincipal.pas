unit uprincipal;

{$mode objfpc}{$H+}

interface

uses
  Types, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, LazUtils, StdCtrls, ComCtrls, Menus, Buttons, DBGrids,
  TypeCodeBuilding, DB, StrUtils;

type

  { TPageControl }

  TPageControl = class(ComCtrls.TPageControl)
  private
    {$IFDEF WIN32}
      procedure TCMAdjustRect(var Msg: TMessage); message TCM_ADJUSTRECT;
    {$ENDIF}
  end;

  { TFPrincipal }

  TFPrincipal = class(TForm)
    btDesmarcarTodos: TButton;
    btMarcarTodos: TButton;
    cbTipo: TComboBox;
    cbTipo1: TComboBox;
    DBGrid1: TDBGrid;
    dsDados: TDataSource;
    dsDependencias: TDataSource;
    dsFields: TDataSource;
    dsForeignKeys: TDataSource;
    dsTabela: TDataSource;
    dsUnique: TDataSource;
    edDescricao: TMemo;
    edHost: TLabeledEdit;
    edPorta: TLabeledEdit;
    edSenha: TLabeledEdit;
    edUsuario: TLabeledEdit;
    GridFields: TDBGrid;
    GridFields1: TDBGrid;
    GridFields2: TDBGrid;
    GridFields3: TDBGrid;
    GridTabelas: TDBGrid;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    lbTotalFields: TLabel;
    lbTotalSelecionado: TLabel;
    lbTotalTabelas: TLabel;
    PageControl1: TPageControl;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    pgNavegacao: TPageControl;
    Panel1: TPanel;
    btnCriar: TSpeedButton;
    pgUnique: TTabSheet;
    rbOrm: TRadioGroup;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    btnCancelarGeracao: TSpeedButton;
    btnGerarCodigo: TSpeedButton;
    btConectar: TSpeedButton;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    tbPrincipal: TTabSheet;
    tbModelo: TTabSheet;
    tbDB: TTabSheet;
    tbTabelas: TTabSheet;
    procedure btDesmarcarTodosClick(Sender: TObject);
    procedure btMarcarTodosClick(Sender: TObject);
    procedure btnCriarClick(Sender: TObject);
    procedure cbTipoSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure GridTabelasCellClick(Column: TColumn);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure btnCancelarGeracaoClick(Sender: TObject);
    procedure btnGerarCodigoClick(Sender: TObject);
    procedure btConectarClick(Sender: TObject);
    procedure tbPrincipalShow(Sender: TObject);
  private
    function inicializa: Boolean;
    procedure selecionardatabase;
    var
      iSelecionados: Integer;
  public

  end;

var
  FPrincipal: TFPrincipal;

implementation

uses udm, Sequelize_Ctrl, NodeJS_Ctrl, useleciona_banco, ConexaoCodeBuilding;

{$R *.lfm}

{$IFDEF WIN32}
{ TPageControl }
procedure TPageControl.TCMAdjustRect(var Msg: TMessage);
begin
  inherited;
  if Msg.WParam = 0 then
    InflateRect(PRect(Msg.LParam)^, 4, 8)
  else
    InflateRect(PRect(Msg.LParam)^, -4, -4);
end;
{$ENDIF}

{ TFPrincipal }

procedure TFPrincipal.FormCreate(Sender: TObject);
begin
  pgNavegacao.TabIndex := 0;
  pgNavegacao.ShowTabs := False;
  inicializa;
end;

procedure TFPrincipal.FormKeyPress(Sender: TObject; var Key: char);
begin
  if not(dsTabela.DataSet.IsEmpty) and (pgNavegacao.ActivePage = tbTabelas) then
  begin
    if Key = #42 then
    begin
      if dsTabela.DataSet.FieldByName('check').AsBoolean then
        iSelecionados := iSelecionados - 1
      else
        iSelecionados := iSelecionados + 1;
      dsTabela.DataSet.Edit;
      dsTabela.DataSet.FieldByName('check').AsBoolean := not(dsTabela.DataSet.FieldByName('check').AsBoolean);
      dsTabela.DataSet.Post;
    end
    else if Key = #43 then
    begin
      try
        iSelecionados := 0;
        dsTabela.DataSet.DisableControls;
        dsTabela.DataSet.First;
        while not dsTabela.DataSet.EOF do
        begin
          try
            dsTabela.DataSet.Edit;
            dsTabela.DataSet.FieldByName('check').AsBoolean := True;
            dsTabela.DataSet.Post;
          finally
            dsTabela.DataSet.Next;
            iSelecionados := iSelecionados + 1;
          end;
        end;
      finally
        dsTabela.DataSet.First;
        dsTabela.DataSet.EnableControls;
      end;
    end
    else if Key = #45 then
    begin
      try
        iSelecionados := 0;
        dsTabela.DataSet.DisableControls;
        dsTabela.DataSet.First;
        while not dsTabela.DataSet.EOF do
        begin
          try
            dsTabela.DataSet.Edit;
            dsTabela.DataSet.FieldByName('check').AsBoolean := False;
            dsTabela.DataSet.Post;
          finally
            dsTabela.DataSet.Next;
          end;
        end;
      finally
        dsTabela.DataSet.First;
        dsTabela.DataSet.EnableControls;
      end;
    end;
    lbTotalSelecionado.Caption  := 'Selecionadas ' + IntToStr(iSelecionados);
  end;
end;

procedure TFPrincipal.GridTabelasCellClick(Column: TColumn);
begin
  if (Column = GridTabelas.Columns[0]) then
  begin
    if dsTabela.DataSet.FieldByName('check').AsBoolean then
      iSelecionados := iSelecionados - 1
    else
      iSelecionados := iSelecionados + 1;
    dsTabela.DataSet.Edit;
    dsTabela.DataSet.FieldByName('check').AsBoolean := not(dsTabela.DataSet.FieldByName('check').AsBoolean);
    dsTabela.DataSet.Post;
    lbTotalSelecionado.Caption  := 'Selecionadas: ' + IntToStr(iSelecionados);
  end;
end;

procedure TFPrincipal.SpeedButton1Click(Sender: TObject);
begin
  pgNavegacao.ActivePage := tbPrincipal;
end;

procedure TFPrincipal.SpeedButton2Click(Sender: TObject);
begin
  pgNavegacao.ActivePage := tbDB;
end;

procedure TFPrincipal.SpeedButton3Click(Sender: TObject);
begin
  pgNavegacao.ActivePage := tbModelo;
end;

procedure TFPrincipal.SpeedButton4Click(Sender: TObject);
begin
  pgNavegacao.ActivePage := tbTabelas;
end;

procedure TFPrincipal.btnCancelarGeracaoClick(Sender: TObject);
begin
  pgNavegacao.ActivePage := tbDB;
end;

procedure TFPrincipal.btnGerarCodigoClick(Sender: TObject);
begin
  try
    btnCancelarGeracao.Enabled := False;
    btnGerarCodigo.Enabled     := False;
    if (rbOrm.ItemIndex = 0) then
    begin
      TSequelize_Ctrl.GetInstance.GerarDocumentacao;
      TSequelize_Ctrl.GetInstance.GerarModel;
      TSequelize_Ctrl.GetInstance.GerarRoutes;
      TSequelize_Ctrl.GetInstance.GerarRouta;
      TSequelize_Ctrl.GetInstance.GerarController;
      TSequelize_Ctrl.GetInstance.GerarRepositorio;
    end
    else if (rbOrm.ItemIndex = 1) then
    begin
      TNodeJS_Ctrl.GetInstance.GerarModel;
      TNodeJS_Ctrl.GetInstance.GerarController;
      TNodeJS_Ctrl.GetInstance.GerarRoutes;
      TNodeJS_Ctrl.GetInstance.GerarRouta;
      TNodeJS_Ctrl.GetInstance.GerarDocumentacao;
    end;
    ShowMessage('Gerado com sucesso!');
  finally
    btnCancelarGeracao.Enabled := True;
    btnGerarCodigo.Enabled     := True;
    pgNavegacao.ActivePage     := tbPrincipal;
  end;
end;

procedure TFPrincipal.btConectarClick(Sender: TObject);
begin
  try
    btConectar.Enabled               := False;
    try
      dm.CodeBuilding.Conexao.SGDB     := StrToSgdb(Trim(cbTipo.Text));
    except
    end;
    dm.CodeBuilding.Conexao.Host     := edHost.Text;
    dm.CodeBuilding.Conexao.Porta    := StrToInt(edPorta.Text);
    dm.CodeBuilding.Conexao.Usuario  := edUsuario.Text;
    dm.CodeBuilding.Conexao.Senha    := edSenha.Text;

    if dm.CodeBuilding.Conexao.Banco.Trim() = '' then
    begin
      if (Trim(LowerCase(cbTipo.Text)) <> 'firebird') then
        selecionardatabase;
      if dm.CodeBuilding.Conexao.Banco.Trim() = '' then
        Exit;
    end;

    if dm.CodeBuilding.Conexao.Salve then
    begin
      if TConexaoCodeBuilding.GetInstance.Conectar then
      begin
        TConexaoCodeBuilding.GetInstance.ListarTabelas;
        iSelecionados              := 0;
        lbTotalTabelas.Caption     := 'Tabelas: '+dm.Tabelas.RecordCount.ToString();
        lbTotalSelecionado.Caption := 'Selecionadas: 0';
        dm.CodeBuilding.Conexao.Salve;
        ShowMessage('Conectado com sucesso');
      end
      else
      begin
        ShowMessage('Não foi possivel se conectar ao banco!');
      end;
    end;
  finally
    btConectar.Enabled := True;
  end;
end;

procedure TFPrincipal.tbPrincipalShow(Sender: TObject);
begin
  btnCriar.Enabled := True;
end;

function TFPrincipal.inicializa: Boolean;
begin
  cbTipo.Text    := SgdbToStr(dm.CodeBuilding.Conexao.SGDB);
  edHost.Text    := dm.CodeBuilding.Conexao.Host;
  edPorta.Text   := dm.CodeBuilding.Conexao.Porta.ToString;
  edUsuario.Text := dm.CodeBuilding.Conexao.Usuario;
  edSenha.Text   := dm.CodeBuilding.Conexao.Senha;
end;

procedure TFPrincipal.selecionardatabase;
var
  FOpen_Banco: TFSeleciona_Banco;
begin
  try
    dm.CodeBuilding.Conexao.SGDB     := StrToSgdb(Trim(cbTipo.Text));
    dm.CodeBuilding.Conexao.Host     := edHost.Text;
    dm.CodeBuilding.Conexao.Porta    := StrToInt(edPorta.Text);
    dm.CodeBuilding.Conexao.Usuario  := edUsuario.Text;
    dm.CodeBuilding.Conexao.Senha    := edSenha.Text;

    if dm.CodeBuilding.Conexao.Salve then
    begin
      if not TConexaoCodeBuilding.GetInstance.Conectar then
        dm.CodeBuilding.Conexao.Banco := '';
      try
        FOpen_Banco := TFSeleciona_Banco.Create(nil);
        FOpen_Banco.ShowModal;
      finally
        FreeAndNil(FOpen_Banco);
      end;
    end;
  finally
  end;
end;

procedure TFPrincipal.btnCriarClick(Sender: TObject);
begin
  btnCriar.Enabled       := False;
  pgNavegacao.ActivePage := tbModelo;
end;

procedure TFPrincipal.btMarcarTodosClick(Sender: TObject);
var
  Key: char;
begin
  try
    btMarcarTodos.Enabled := False;
    Key := #43;
    Self.OnKeyPress(nil,Key);
  finally
    btMarcarTodos.Enabled := True;
  end;
end;

procedure TFPrincipal.btDesmarcarTodosClick(Sender: TObject);
var
  Key: char;
begin
  try
    btDesmarcarTodos.Enabled := False;
    Key := #45;
    Self.OnKeyPress(nil,Key);
  finally
    btDesmarcarTodos.Enabled := True;
  end;
end;

procedure TFPrincipal.cbTipoSelect(Sender: TObject);
begin
  dm.CodeBuilding.Conexao.Banco:= '';
  dm.CodeBuilding.Conexao.SGDB := StrToSgdb(cbTipo.Text);
end;

end.

