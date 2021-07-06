unit CodeBuildingClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, TypeCodeBuilding, Dialogs;

type

  { TConexaoConfig }

  TConexaoConfig = class
    strict private
      FSGDB : TSGDB;
      FHost : String;
      FPort : Integer;
      FUser : String;
      FPass : String;
      FBase : String;
    public
      constructor Create;
      function Load : Boolean;
      function Salve: Boolean;
      property SGDB : TSGDB    read FSGDB   write FSGDB;
      property Host : String   read FHost   write FHost;
      property Porta: Integer  read FPort   write FPort;
      property Usuario: String read FUser   write FUser;
      property Senha : String  read FPass   write FPass;
      property Banco : String  read FBase   write FBase;
    end;

  { TConfiguracao }

  TConfiguracao = class
    strict private
      FLinguagem : TLinguagem;
      FPadrao    : TPadrao;
    public
      constructor Create;
      property Linguagem : TLinguagem     read FLinguagem   write FLinguagem;
      property Padrao    : TPadrao        read FPadrao      write FPadrao;
  end;

  { TCodeBuilding }

  TCodeBuilding = class
    strict private
      FConexao      : TConexaoConfig;
      FConfiguracao : TConfiguracao;
      FDirectorio   : String;
      FDirSaida     : String;
    public
      constructor Create;
      property Conexao      : TConexaoConfig read FConexao      write FConexao;
      property Configuracao : TConfiguracao  read FConfiguracao write FConfiguracao;
      property Dir          : String         read FDirectorio   write FDirectorio;
      property DirSaida     : String         read FDirSaida     write FDirSaida;
  end;


implementation

uses IniFiles, CriptografiaCodeBuilding;

{ TCodeBuilding }

constructor TCodeBuilding.Create;
begin
  if not Assigned(FConfiguracao) then
    FConfiguracao := TConfiguracao.Create;

  if not Assigned(FConexao) then
    FConexao  := TConexaoConfig.Create;

  FDirectorio := ExtractFileDir(ApplicationName);
  FDirSaida   := FDirectorio+'Saida\';

  if not(FileExists(FDirSaida)) then
    ForceDirectories(FDirSaida);
end;

{ TConfiguracao }

constructor TConfiguracao.Create;
begin
  inherited Create;

  try
    Self.Linguagem := delphi;
    Self.Padrao    := DesignPattern;
  except
  end;
end;

{ conexao }

constructor TConexaoConfig.Create;
begin
  inherited Create;

  Self.Load;
end;

function TConexaoConfig.Load: Boolean;
var
  ini : TIniFile;
begin
   try
    try
      ini := TIniFile.Create(ExtractFilePath(ApplicationName)+'Config.ini');

      Self.SGDB    := StrToSgdb(CriptoHexToText(ini.ReadString('DB','Tipo','firebird')));
      Self.Host    := CriptoHexToText(ini.ReadString('DB','Host','localhost'));
      try
        Self.Porta := StrToInt(CriptoHexToText(ini.ReadString('DB','Porta','3050')));
      finally
        Self.Porta := '';
      end;
      Self.Banco   := CriptoHexToText(ini.ReadString('DB','Banco','Teste'));
      Self.Usuario := CriptoHexToText(ini.ReadString('DB','Usuario','root'));
      Self.Senha   := CriptoHexToText(ini.ReadString('DB','Senha','123456'));
      Result       := True;
    except
      Result       := False;
    end;
  finally
    FreeAndNil(ini);
  end;
end;

function TConexaoConfig.Salve: Boolean;
var
  ini : TIniFile;
begin
   try
    try
      ini := TIniFile.Create(ExtractFilePath(ApplicationName)+'Config.ini');

      if not(Self.Host.Trim <> '') then
      begin
        ShowMessage('Informe o Host!');
        Result := False;
        Exit;
      end;

      if not (Self.Porta > 0) then
      begin
        ShowMessage('Informe a Porta!');
        Result := False;
        Exit;
      end;

      if not(Self.Usuario.Trim <> '') then
      begin
        ShowMessage('Informe o Usuário!');
        Result := False;
        Exit;
      end;

      ini.WriteString('DB','Tipo',TextToCriptoHex(SgdbToStr(Self.SGDB).Trim()));
      ini.WriteString('DB','Host',TextToCriptoHex(Self.Host.Trim()));
      ini.WriteString('DB','Porta',TextToCriptoHex(Self.Porta.ToString()));
      ini.WriteString('DB','Banco',TextToCriptoHex(Self.Banco.Trim()));
      ini.WriteString('DB','Usuario',TextToCriptoHex(Self.Usuario.Trim()));
      ini.WriteString('DB','Senha',TextToCriptoHex(Self.Senha.Trim()));
      Result       := True;
    except
      Result       := False;
    end;
  finally
    FreeAndNil(ini);
  end;
end;

end.

