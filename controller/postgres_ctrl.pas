unit PostGres_Ctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, TypeCodeBuilding;

type

  { TPostGres_Ctrl }

  TPostGres_Ctrl = class
    strict private
      class var FInstance: TPostGres_Ctrl;
      constructor CreatePrivate;
    private
    public
      constructor Create;
      destructor  Destroy; override;
      class function GetInstance: TPostGres_Ctrl;
      function GetDados(sTabela: String): String;
      function GetSQL_Tabelas: String;
      function GetSQL_Fields(sTabela: String): String;
      function GetSQL_Relacionamento(sTabela: String): String;
      function GetSQL_Unique(sTabela: String): String;
      function GetSQL_Dependencias(sTabela: String): String;
      function GetSQL_Bancos: String;
  end;


implementation

uses Firebird_Ctrl;

{ TPostGres_Ctrl }

constructor TPostGres_Ctrl.CreatePrivate;
begin
  inherited Create;
end;

constructor TPostGres_Ctrl.Create;
begin
  raise Exception.Create('Objeto Singleton');
end;

destructor TPostGres_Ctrl.Destroy;
begin
  inherited Destroy;
end;

class function TPostGres_Ctrl.GetInstance: TPostGres_Ctrl;
begin
  if not Assigned(FInstance) then
    FInstance := TPostGres_Ctrl.CreatePrivate;

  Result := FInstance;
end;

function TPostGres_Ctrl.GetDados(sTabela: String): String;
begin
  Result := 'SELECT * FROM '+sTabela+' limit 1';
end;

function TPostGres_Ctrl.GetSQL_Tabelas: String;
begin
  Result := 'SELECT table_name AS TABELA FROM information_schema.tables WHERE table_schema = ''public'' order by table_name';
end;

function TPostGres_Ctrl.GetSQL_Fields(sTabela: String): String;
begin
  Result := '  SELECT    '+
            '    pg_attribute.attname as CAMPO,  '+
            '    case '+
            '    when ((select substring(typname for 2 from 1) from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm'') then'+
            '      (select typnotnull from pg_type where pg_type.oid = pg_attribute.atttypid limit 1)'+
            '    else '+
            '      pg_attribute.attnotnull'+
            '    end as NOTNULL,'+
            '    coalesce((SELECT c.Character_maximum_length FROM information_schema.columns c WHERE (c.column_name = pg_attribute.attname) and (c.table_name = '+QuotedStr(sTabela)+')),0) AS CAMPO_TAMANHO,  '+
            '    case  '+
            '    when pg_attribute.atttypid = 20    then ''BigInt''  '+
            '    when pg_attribute.atttypid = 24579 then ''Integer'' '+
            '    when pg_attribute.atttypid = 23    then ''Integer'' '+
            '    when pg_attribute.atttypid = 1082  then ''TDate''   '+
            '    when pg_attribute.atttypid = 1083  then ''TTime''   '+
            '    when pg_attribute.atttypid = 1266  then ''TTime''   '+
            '    when pg_attribute.atttypid = 24951 then ''BLOB''    '+
            '    when pg_attribute.atttypid = 24590 then ''String''  '+
            '    when pg_attribute.atttypid = 1042  then ''String''  '+
            '    when pg_attribute.atttypid = 1043  then ''String''  '+
            '    when pg_attribute.atttypid = 24584 then ''String''  '+
            '    when pg_attribute.atttypid = 24585 then ''String''  '+
            '    when pg_attribute.atttypid = 24580 then ''String''  '+
            '    when pg_attribute.atttypid = 24583 then ''String''  '+
            '    when pg_attribute.atttypid = 24587 then ''String''  '+
            '    when pg_attribute.atttypid = 24579 then ''String''  '+
            '    when pg_attribute.atttypid = 24589 then ''String''  '+
            '    when pg_attribute.atttypid = 24595 then ''String''  '+
            '    when pg_attribute.atttypid = 24596 then ''Real''    '+
            '    when pg_attribute.atttypid = 24588 then ''Real''    '+
            '    when pg_attribute.atttypid = 1700  then ''Extended'''+
            '    when pg_attribute.atttypid = 24578 then ''String''  '+
            '    when pg_attribute.atttypid = 24592 then ''String''  '+
            '    when pg_attribute.atttypid = 24594 then ''String''  '+
            '    when pg_attribute.atttypid = 24581 then ''String''  '+
            '    when pg_attribute.atttypid = 24577 then ''String''  '+
            '    when pg_attribute.atttypid = 24576 then ''String''  '+
            '    when pg_attribute.atttypid = 24582 then ''String''  '+
            '    when pg_attribute.atttypid = 24591 then ''String''  '+
            '    when pg_attribute.atttypid = 24593 then ''String''  '+
            '    when pg_attribute.atttypid = 24586 then ''String''  '+
            '    else  '+
            '     case  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_cnh''  then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_cnh''  then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_contato''  then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_codigo_ncm''  then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_codigo_fixo''  then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_codigo_genero''  then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_codigo_aliquota''  then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_codigo_aliquota_fixo''  then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_caminho_foto''  then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_acao''  then  '+
            '       ''String''	  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_agencia'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_autorizacao'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_bairro'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_cep''  then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_cest'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_cfop'' then  '+
            '       ''Integer''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_chave'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_cidade'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_cnpj'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_complemento'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_conta'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_cson'' then  '+
            '       ''String''	  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_data'' then  '+
            '       ''TDate''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_descricao_resumida'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_documento'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_ean'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_email'' then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_email_fixo'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_endereco'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_es'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_estado_civil'' then  '+
            '       ''String''	  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_grade'' then '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_grade_fixo'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_hora'' then  '+
            '       ''TTime''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_inteiro'' then  '+
            '       ''Integer''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_inteiro_obrigatorio'' then  '+
            '       ''Integer''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_ncm'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_nome'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_nome_obrigatorio'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_numero'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_numero_banco'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_numero_cheque'' then  '+
            '       ''String''                                                  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_obs'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_observacao'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_orgao_expeditor'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_parentesco'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_placa'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_prateleira'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_quantidade'' then  '+
            '       ''Extended''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_referencia'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_rg_ie'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_senha'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_sim_nao'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_entrada_saida'' then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_tabela'' then '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_taxa_percentual'' then  '+
            '       ''Extended''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_telefone'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_tipo'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_tipo_contribuinte'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_tipo_pessoa'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_uf'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_unidade'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_utilizacao'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_valor'' then  '+
            '       ''Extended''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_valor_obrigatorio'' then  '+
            '       ''Extended''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_fk'' then  '+
            '       ''Integer'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_fk_fixo'' then  '+
            '       ''Integer'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_dt'' then  '+
            '       ''TDate'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_dt_cadastro'' then  '+
            '       ''TDate'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_cor'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_cpf'' then  '+
            '       ''String''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_cpf_cnpj'' then  '+
            '       ''String''    '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_cst_icms'' then  '+
            '       ''String''   '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_data_hora'' then  '+
            '       ''TDateTime''  '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_data_hora_fixo'' then  '+
            '       ''TDateTime'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_detalhe'' then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_estado_civil'' then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_ie'' then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_ie_rg'' then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_logradouro'' then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_ncm_expressao'' then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_nome_fantasia'' then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_nome_fixo'' then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_nome_reduzido'' then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_nome_reduzido_fixo'' then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_nome_tabela'' then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_numero_nota'' then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_numero_nota_fixo'' then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_percentual'' then  '+
            '       ''Extended'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_razao_social'' then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_rg'' then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_senha_fixo'' then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_sexo'' then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_text'' then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_tipo_contato_fixo'' then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_tipo_produto'' then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_uf_fixo'' then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_unidade_fixo'' then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_url_fixo'' then  '+
            '       ''String'' '+
            '     when (select typname from pg_type where pg_type.oid = pg_attribute.atttypid) = ''dm_vl'' then  '+
            '       ''Extended'' '+
            '     else '+
            '       ''Desconhecido'' '+
            '     end  '+
            '    end as TIPO,  '+
            '  (SELECT a.attname AS chave_pk   '+
            '  FROM pg_class c   '+
            '  INNER JOIN pg_attribute a ON (c.oid = a.attrelid)   '+
            '  INNER JOIN pg_index i ON (c.oid = i.indrelid)   '+
            '  WHERE   '+
            '  i.indkey[0] = a.attnum AND   '+
            '  i.indisprimary = ''t'' AND   '+
            '  c.relname =   '+QuotedStr(sTabela)+'  ) AS CHAVE   '+
            '   from pg_attribute  '+
            '   where   '+
            '       attstattarget = -1 and  '+
            '       attrelid = (  '+
            '          select pg_class.oid as table_id  '+
            '          from pg_class  '+
            '          left join pg_namespace on pg_class.relnamespace = pg_namespace.oid  '+
            '          where  '+
            '             pg_class.relname =  '+QuotedStr(sTabela)+'   and  '+
            '             pg_namespace.nspname = ''public'')  ';
end;

function TPostGres_Ctrl.GetSQL_Relacionamento(sTabela: String): String;
begin
  Result := ' SELECT   '+
            '  ct.conname as fk_name, '+
            '  a.attname AS field,    '+
            '  clf.relname AS fk_table,   '+
            '  af.attname AS fk_field, '+
            '  case ct.confupdtype'+
            '  when ''a'' then'+
            '    ''No Action'''+
            '  when ''r'' then'+
            '    ''Restrict'' '+
            '  when ''c'' then'+
            '    ''Cascade'''+
            '  when ''n'' then'+
            '    ''Set Null'''+
            '  when ''d'' then'+
            '    ''Set Default'''+
            '  else   '+
            '    ''Null'''+
            '  end as Update,'+
            '  case ct.confdeltype'+
            '  when ''a'' then'+
            '    ''No Action'''+
            '  when ''r'' then'+
            '    ''Restrict'' '+
            '  when ''c'' then'+
            '    ''Cascade'''+
            '  when ''n'' then'+
            '    ''Set Null'''+
            '  when ''d'' then'+
            '    ''Set Default'''+
            '  else   '+
            '    ''Null'''+
            '  end as Delete '+
            ' FROM pg_catalog.pg_attribute a   '+
            '  JOIN pg_catalog.pg_class cl ON (a.attrelid = cl.oid AND cl.relkind = ''r'') '+
            '  JOIN pg_catalog.pg_namespace n ON (n.oid = cl.relnamespace)   '+
            '  JOIN pg_catalog.pg_constraint ct ON (a.attrelid = ct.conrelid AND   '+
            '       ct.confrelid != 0 AND ct.conkey[1] = a.attnum)   '+
            '  JOIN pg_catalog.pg_class clf ON (ct.confrelid = clf.oid AND clf.relkind = ''r'') '+
            '  JOIN pg_catalog.pg_namespace nf ON (nf.oid = clf.relnamespace)   '+
            '  JOIN pg_catalog.pg_attribute af ON (af.attrelid = ct.confrelid AND   '+
            '       af.attnum = ct.confkey[1])   '+
            ' WHERE   '+
            '  cl.relname = '+QuotedStr(sTabela);
end;

function TPostGres_Ctrl.GetSQL_Unique(sTabela: String): String;
begin
  Result := ' select'+
            '    i.relname as fk_name,'+
            '    t.relname as fk_table,    '+
            '    a.attname as field,'+
            '    '''' as fk_field,'+
            '    '''' as Update,'+
            '    '''' as Delete'+
            ' from'+
            '    pg_class t,'+
            '    pg_class i,'+
            '    pg_index ix,'+
            '    pg_attribute a'+
            ' where'+
            '    t.oid = ix.indrelid'+
            '    and i.oid = ix.indexrelid'+
            '    and a.attrelid = t.oid'+
            '    and a.attnum = ANY(ix.indkey)'+
            '    and t.relkind = ''r'''+
            '    and ix.indisprimary = false'+
            '    and t.relname like '+QuotedStr(sTabela)+
            ' order by'+
            '    t.relname,'+
            '    i.relname;';
end;

function TPostGres_Ctrl.GetSQL_Dependencias(sTabela: String): String;
begin
  Result := ' SELECT '+
            '   cl.relname AS tabela, '+
            '   a.attname AS field, '+
            '   ct.conname AS constraint, '+
            '   af.attname AS field_ref '+
            ' FROM pg_catalog.pg_attribute a '+
            '   JOIN pg_catalog.pg_class cl ON (a.attrelid = cl.oid AND cl.relkind = ''r'')'+
            '   JOIN pg_catalog.pg_namespace n ON (n.oid = cl.relnamespace)'+
            '   JOIN pg_catalog.pg_constraint ct ON (a.attrelid = ct.conrelid AND'+
            '        ct.confrelid != 0 AND ct.conkey[1] = a.attnum)'+
            '   JOIN pg_catalog.pg_class clf ON (ct.confrelid = clf.oid AND clf.relkind = ''r'')'+
            '   JOIN pg_catalog.pg_namespace nf ON (nf.oid = clf.relnamespace)'+
            '   JOIN pg_catalog.pg_attribute af ON (af.attrelid = ct.confrelid AND'+
            '    af.attnum = ct.confkey[1])'+
            ' where clf.relname = '+QuotedStr(sTabela);
end;

function TPostGres_Ctrl.GetSQL_Bancos: String;
begin
  Result := 'select pg_database.datname as base from pg_database where pg_database.datistemplate = false';
end;

end.

