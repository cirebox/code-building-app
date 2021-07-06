unit CriptografiaCodeBuilding;

interface

uses
  SysUtils;

  function Invert(SText: string): string;
  function CriptoBinToText(SText: string; Chave: String = ''): String;
  function TextToCriptoBin(SText: string; Chave: String = ''): String;
  function TextToCriptoHex(SText: string; Chave: String = ''): String;
  function DecToHex(Number: Byte): String;
  function HexToDec(Number: string): Byte;
  function CriptoHexToText(SText: string; Chave: String = ''): String;

const
  sCHAVE : String = '$&&';

implementation

{ TCripto }

function Invert(SText: string): string;
var
  Position: Integer;
begin
  Result := '';
  for Position := Length(SText) downto 1 do
    Result := Result + SText[Position];
end;

function CriptoBinToText(SText: string; Chave: String = ''): string;
var
  SPos: Integer;
  BKey: Byte;
  S: string;
  Key:string;
begin
  Result := '';
  if Trim(Chave) <> '' then
    Key := Chave
  else
    Key := sCHAVE;
  // converte
  for SPos := 1 to Length(SText) do
    begin
      S := Copy(Key, (SPos mod Length(Key)) + 1, 1);
      BKey := Ord(S[1]) + SPos;
      Result := Result + Chr(Ord(SText[SPos]) xor BKey);
    end;
  // inverte Result
  Result := Invert(Result);
end;

function TextToCriptoBin(SText: string; Chave: String = ''): string;
var
  SPos: Integer;
  BKey: Byte;
  S: string;
  Key:string;
begin
  if Trim(Chave) <> '' then
    Key := Chave
  else
    Key := sCHAVE;
  // inverte texto
  SText := Invert(SText);
  // criptografa
  Result := '';
  for SPos := 1 to Length(SText) do
  begin
    S := Copy(Key, (SPos mod Length(Key)) + 1, 1);
    BKey := Ord(S[1]) + SPos;
    Result := Result + Chr(Ord(SText[SPos]) xor BKey);
  end;
end;

function DecToHex(Number: Byte): string;
begin
  Result := Copy('0123456789ABCDEF', (Number mod 16) + 1, 1);
  Number := Number div 16;
  Result := Copy('0123456789ABCDEF', (Number mod 16) + 1, 1) + Result
end;

function TextToCriptoHex(SText: string; Chave: String = ''): string;
var
  SPos: Integer;
begin
  SText := TextToCriptoBin(SText,Chave);
  // converte para hex
  Result := '';
  for SPos := 1 to Length(SText) do
    Result := Result + DecToHex(Ord(SText[SPos]));
end;

function HexToDec(Number: string): Byte;
begin
  Number := UpperCase(Number);
  Result := (Pos(Number[1], '0123456789ABCDEF') - 1) * 16;
  Result := Result + (Pos(Number[2], '0123456789ABCDEF') - 1);
end;

function CriptoHexToText(SText: string; Chave: String = ''): string;
var
  SPos: Integer;
begin
  Result := '';
  for SPos := 1 to (Length(SText) div 2) do
    Result := Result + Chr(HexToDec(Copy(SText, ((SPos * 2) - 1), 2)));
  // converte para texto
  Result := CriptoBinToText(Result,Chave);
end;

end.
