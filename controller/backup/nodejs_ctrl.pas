unit NodeJS_Ctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TNodeJS_Ctrl }

  TNodeJS_Ctrl = class
    strict private
      class var FInstance: TNodeJS_Ctrl;
      constructor CreatePrivate;
    private
    public
      constructor Create;
      destructor  Destroy; override;
      class function GetInstance: TNodeJS_Ctrl;
      function GerarModel: Boolean;
      function GerarController: Boolean;
      function GerarRoutes: Boolean;
      function GerarRouta: Boolean;
      function GerarDocumentacao: Boolean;
  end;


implementation

uses udm, Funcoes, TableCodeBuilding, SGDB_Ctrl;

{ TNodeJS_Ctrl }

constructor TNodeJS_Ctrl.CreatePrivate;
begin
  inherited Create;
end;

constructor TNodeJS_Ctrl.Create;
begin
  raise Exception.Create('Objeto Singleton');
end;

destructor TNodeJS_Ctrl.Destroy;
begin
  inherited Destroy;
end;

class function TNodeJS_Ctrl.GetInstance: TNodeJS_Ctrl;
begin
  if not Assigned(FInstance) then
    FInstance := TNodeJS_Ctrl.CreatePrivate;

  Result := FInstance;
end;

function TNodeJS_Ctrl.GerarModel: Boolean;
var
  uModel    : TStringList;
  Tabelas   : TFabTabela;
begin
  try
    try
      Tabelas := TFabTabela.Create;
      Tabelas.primeiro;
      while not Tabelas.EOF do
      begin
        try
          uModel := TStringList.Create;
          if Tabelas.Selecionada then
          begin
            if not Tabelas.Vazio then
            begin
              uModel.Add('''use strict''');
              uModel.Add('var db = require(''../../db'');');
              uModel.Add('');
              uModel.Add('const conn  = db.conexao;');
              uModel.Add('const page  = db.paginacao;');
              uModel.Add('');
              uModel.Add('const table = '+QuotedStr(Tabelas.Nome)+';');
              uModel.Add('const order = ''nome'';');
              uModel.Add('const    pk = '+QuotedStr(Tabelas.PK)+';');
              uModel.Add('');
              uModel.Add('exports.getAll = async() => {');
              uModel.Add('    const res = await conn.select(''*'').from(table).orderBy(order, ''asc'');');
              uModel.Add('    return res;');
              uModel.Add('};');
              uModel.Add('');
              uModel.Add('exports.getPage = async(ipage) => {');
              uModel.Add('    const res = await conn.select(''*'').from(table).orderBy(order, ''asc'').paginate(page.total, ipage, page.exibe_total);');
              uModel.Add('    return res;');
              uModel.Add('};');
              uModel.Add('');
              uModel.Add('exports.getById = async(id) => {');
              uModel.Add('    const res = await conn.select(''*'').from(table).where(pk,id).orderBy(order, ''asc'').paginate(page.total, 1, page.exibe_total);');
              uModel.Add('    return res;');
              uModel.Add('};');
              uModel.Add('');
              uModel.Add('exports.insert = async(obj) => {');
              uModel.Add('    const res = await conn(table).insert(obj);');
              uModel.Add('    return res;');
              uModel.Add('};');
              uModel.Add('');
              uModel.Add('exports.update = async(id, obj) => {');
              uModel.Add('    const res = await conn(table).where(pk,id).update(obj);');
              uModel.Add('    return res;');
              uModel.Add('};');
              uModel.Add('');
              uModel.Add('exports.delete = async(id) => {');
              uModel.Add('    const res = await conn(table).where(pk,id).del();');
              uModel.Add('    return res;');
              uModel.Add('};');
              uModel.Add('');

              if not(FileExists(dm.fab.DirSaida+'models\')) then
                ForceDirectories(dm.fab.DirSaida+'models\');
              uModel.SaveToFile(dm.fab.DirSaida+'models\'+Tabelas.Nome+'.js');
            end;
          end;
        finally
          Tabelas.proximo;
          FreeAndNil(uModel);
        end;
      end;
      Result := True;
    except
      Result := False;
    end;
  finally
    Tabelas.primeiro;
    FreeAndNil(Tabelas);
  end;
end;

function TNodeJS_Ctrl.GerarController: Boolean;
var
  uCONTROLLER    : TStringList;
  Tabelas        : TFabTabela;
begin
  try
    try
      Tabelas := TFabTabela.Create;
      Tabelas.primeiro;
      while not Tabelas.EOF do
      begin
        try
          uCONTROLLER := TStringList.Create;
          if Tabelas.Selecionada then
          begin
            if not Tabelas.campo.Vazio then
            begin
              uCONTROLLER.Add('''use strict''');
              uCONTROLLER.Add('var model = require('+QuotedStr('../models/'+Tabelas.Nome)+');');
              uCONTROLLER.Add('');
              uCONTROLLER.Add('exports.getAll = async(req, res, next) => {');
              uCONTROLLER.Add('    try {');
              uCONTROLLER.Add('        var data = await model.getAll();');
              uCONTROLLER.Add('        res.status(200).send(data);');
              uCONTROLLER.Add('    } catch (e) {');
              uCONTROLLER.Add('        res.status(400).send({');
              uCONTROLLER.Add('        message: ''Falha ao processar Requisição''');
              uCONTROLLER.Add('        });');
              uCONTROLLER.Add('    }  ');
              uCONTROLLER.Add('}');
              uCONTROLLER.Add('');
              uCONTROLLER.Add('exports.getPage= async(req, res, next) => {');
              uCONTROLLER.Add('    try {');
              uCONTROLLER.Add('        if (req.params.page > 0) {');
              uCONTROLLER.Add('          var data = await model.getPage(req.params.page);');
              uCONTROLLER.Add('          res.status(200).send(data);');
              uCONTROLLER.Add('        } else { ');
              uCONTROLLER.Add('          res.status(400).send({');
              uCONTROLLER.Add('          message: ''Falha ao processar requisição parâmetro não informado''');
              uCONTROLLER.Add('          });');
              uCONTROLLER.Add('        }');
              uCONTROLLER.Add('    } catch (e) {');
              uCONTROLLER.Add('        console.log(e);');
              uCONTROLLER.Add('        res.status(500).send({');
              uCONTROLLER.Add('        message: ''Falha ao processar Requisição''');
              uCONTROLLER.Add('        });');
              uCONTROLLER.Add('    }  ');
              uCONTROLLER.Add('}');
              uCONTROLLER.Add('');
              uCONTROLLER.Add('exports.GetById = async(req, res, next) => {');
              uCONTROLLER.Add('    try {');
              uCONTROLLER.Add('        if (req.params.id > 0) {');
              uCONTROLLER.Add('          var data = await model.getById(req.params.id);');
              uCONTROLLER.Add('          res.status(200).send(data);');
              uCONTROLLER.Add('        } else { ');
              uCONTROLLER.Add('          res.status(400).send({');
              uCONTROLLER.Add('          message: ''Falha ao processar requisição parâmetro não informado''');
              uCONTROLLER.Add('          });');
              uCONTROLLER.Add('        }');
              uCONTROLLER.Add('    } catch (e) {');
              uCONTROLLER.Add('        console.log(e);');
              uCONTROLLER.Add('        res.status(500).send({');
              uCONTROLLER.Add('        message: ''Falha ao processar Requisição''');
              uCONTROLLER.Add('        });');
              uCONTROLLER.Add('    }  ');
              uCONTROLLER.Add('}');
              uCONTROLLER.Add('');
              uCONTROLLER.Add('exports.insert = async(req, res, next) => {');
              uCONTROLLER.Add('    try {');
              uCONTROLLER.Add('        var data = await model.insert(req.body);');
              uCONTROLLER.Add('        res.status(200).send({message: ''Inserido com sucesso''});');
              uCONTROLLER.Add('    } catch (e) {');
              uCONTROLLER.Add('        console.log(e);');
              uCONTROLLER.Add('        res.status(500).send({');
              uCONTROLLER.Add('        message: ''Falha ao processar Requisição''');
              uCONTROLLER.Add('        });');
              uCONTROLLER.Add('    }  ');
              uCONTROLLER.Add('}');
              uCONTROLLER.Add('');
              uCONTROLLER.Add('exports.update = async(req, res, next) => {');
              uCONTROLLER.Add('    try {');
              uCONTROLLER.Add('      if (req.params.id > 0) {');
              uCONTROLLER.Add('        var count = await model.update(req.params.id,req.body);');
              uCONTROLLER.Add('        if (count > 0 ){');
              uCONTROLLER.Add('            res.status(200).send({message: ''Atualizado com Sucesso''});');
              uCONTROLLER.Add('        } else {');
              uCONTROLLER.Add('            res.status(204).send({message: ''Nenhum registro a ser atualizado''});');
              uCONTROLLER.Add('        }');
              uCONTROLLER.Add('      } else {');
              uCONTROLLER.Add('        res.status(400).send({');
              uCONTROLLER.Add('        message: ''Falha ao processar requisição parâmetro não informado''');
              uCONTROLLER.Add('        });');
              uCONTROLLER.Add('      }');
              uCONTROLLER.Add('    } catch (e) {');
              uCONTROLLER.Add('        console.log(e);');
              uCONTROLLER.Add('        res.status(500).send({');
              uCONTROLLER.Add('        message: ''Falha ao processar Requisição''');
              uCONTROLLER.Add('        });');
              uCONTROLLER.Add('    }  ');
              uCONTROLLER.Add('}');
              uCONTROLLER.Add('');
              uCONTROLLER.Add('exports.delete = async(req, res, next) => {');
              uCONTROLLER.Add('    try {');
              uCONTROLLER.Add('      if (req.params.id > 0) {');
              uCONTROLLER.Add('        var count = await model.delete(req.params.id);');
              uCONTROLLER.Add('        if (count > 0 ){');
              uCONTROLLER.Add('            res.status(200).send({message: ''Removido com Sucesso''});');
              uCONTROLLER.Add('        } else {');
              uCONTROLLER.Add('            res.status(400).send({message: ''Nenhum registro a ser removido''});');
              uCONTROLLER.Add('        }');
              uCONTROLLER.Add('      } else {');
              uCONTROLLER.Add('        res.status(400).send({');
              uCONTROLLER.Add('        message: ''Falha ao processar requisição parâmetro não informado''');
              uCONTROLLER.Add('        });');
              uCONTROLLER.Add('      }');
              uCONTROLLER.Add('    } catch (e) {');
              uCONTROLLER.Add('        console.log(e);');
              uCONTROLLER.Add('        if (String(e).includes("violates foreign key constraint")) {');
              uCONTROLLER.Add('            res.status(409).send({');
              uCONTROLLER.Add('            message: ''Não é possivel excluir! ''+');
              uCONTROLLER.Add('                     ''Este registro foi utilizado em algum lançamento!''');
              uCONTROLLER.Add('            });    ');
              uCONTROLLER.Add('        } else {');
              uCONTROLLER.Add('            res.status(500).send({');
              uCONTROLLER.Add('            message: ''Falha ao processar Requisição''');
              uCONTROLLER.Add('            });');
              uCONTROLLER.Add('        }');
              uCONTROLLER.Add('    }  ');
              uCONTROLLER.Add('}');

              if not(FileExists(dm.fab.DirSaida+'controllers\')) then
                ForceDirectories(dm.fab.DirSaida+'controllers\');
              uCONTROLLER.SaveToFile(dm.fab.DirSaida+'controllers\'+Tabelas.Nome+'.js');
            end;
          end;
        finally
          FreeAndNil(uCONTROLLER);
          Tabelas.proximo;
        end;
      end;
      Result := True;
    except
      Result := False;
    end;
  finally
    Tabelas.primeiro;
    FreeAndNil(Tabelas);
  end;
end;

function TNodeJS_Ctrl.GerarRoutes: Boolean;
var
  uRoutes : TStringList;
  Tabelas : TFabTabela;
begin
  try
    try
      Tabelas := TFabTabela.Create;
      Tabelas.primeiro;
      while not Tabelas.EOF do
      begin
        try
          uRoutes := TStringList.Create;
          if Tabelas.Selecionada then
          begin
            if not Tabelas.campo.Vazio then
            begin
              uRoutes.Add('var express = require(''express'');');
              uRoutes.Add('var router  = express.Router();');
              uRoutes.Add('');
              uRoutes.Add('var ctrl = require('+QuotedStr('../../controllers/'+Tabelas.Nome)+');');
              uRoutes.Add('');
              uRoutes.Add('router.get(''/all'', ctrl.getAll);');
              uRoutes.Add('router.get(''/pagina/:page'', ctrl.getPage);');
              uRoutes.Add('router.get(''/id/:id'', ctrl.GetById);');
              uRoutes.Add('router.post(''/'', ctrl.insert);');
              uRoutes.Add('router.put(''/:id'', ctrl.update);');
              uRoutes.Add('router.delete(''/:id'', ctrl.delete);');
              uRoutes.Add('');
              uRoutes.Add('module.exports = router;');
              uRoutes.Add('');

              if not(FileExists(dm.fab.DirSaida+'routes\v1\')) then
                ForceDirectories(dm.fab.DirSaida+'routes\v1\');
              uRoutes.SaveToFile(dm.fab.DirSaida+'routes\v1\'+Tabelas.Nome+'.js');
            end;
          end;
        finally
          FreeAndNil(uRoutes);
          Tabelas.proximo;
        end;
      end;
      Result := True;
    except
      Result := False;
    end;
  finally
    Tabelas.primeiro;
    FreeAndNil(Tabelas);
  end;
end;

function TNodeJS_Ctrl.GerarRouta: Boolean;
var
  uRoutes : TStringList;
  Tabelas : TFabTabela;
begin
  try
    try
      uRoutes := TStringList.Create;

      uRoutes.Add('''use strict''');
      uRoutes.Add('');
      uRoutes.Add('var express = require(''express'');');
      uRoutes.Add('var app     = express();');
      uRoutes.Add('var cors    = require(''cors'');');
      uRoutes.Add('');
      uRoutes.Add('app.use(cors());');
      uRoutes.Add('');
      Tabelas := TFabTabela.Create;
      Tabelas.primeiro;
      while not Tabelas.EOF do
      begin
        try
          if Tabelas.Selecionada then
            if not Tabelas.campo.Vazio then
              uRoutes.Add('var '+Tabelas.Nome+' = require('+QuotedStr('../routes/v1/'+Tabelas.Nome)+');');
        finally
          Tabelas.proximo;
        end;
      end;
      uRoutes.Add('');
      uRoutes.Add('app.use(function timeLog(req, res, next) {');
      uRoutes.Add('    var data = new Date() ;');
      uRoutes.Add('    data.setHours(data.getHours() - 3) // Joga o fuso horário Brasileiro');
      uRoutes.Add('    console.log(''Time: '', data.toGMTString());');
      uRoutes.Add('    next();');
      uRoutes.Add('});');
      uRoutes.Add('');
      Tabelas := TFabTabela.Create;
      Tabelas.primeiro;
      while not Tabelas.EOF do
      begin
        try
          if Tabelas.Selecionada then
            if not Tabelas.campo.Vazio then
              uRoutes.Add('app.use('+QuotedStr('/'+Tabelas.Nome+'/')+','+ Tabelas.Nome+');');
        finally
          Tabelas.proximo;
        end;
      end;
      uRoutes.Add('');
      uRoutes.Add('module.exports = app;');

      if not(FileExists(dm.fab.DirSaida+'routes\')) then
        ForceDirectories(dm.fab.DirSaida+'routes\');
      uRoutes.SaveToFile(dm.fab.DirSaida+'routes\v1.js');

      Result := True;
    except
      Result := False;
    end;
  finally
    Tabelas.primeiro;
    FreeAndNil(Tabelas);
  end;
end;

function TNodeJS_Ctrl.GerarDocumentacao: Boolean;
var
  uDocs     : TStringList;
  Tabelas   : TFabTabela;
begin
  try
    try
      Tabelas := TFabTabela.Create;
      Tabelas.primeiro;
      while not Tabelas.EOF do
      begin
        try
          uDocs := TStringList.Create;
          if Tabelas.Selecionada then
          begin
            if not Tabelas.Vazio then
            begin
              uDocs.Add('/**');
              uDocs.Add('* @apiDefine Param'+Tabelas.Nome(True));

              Tabelas.campo.primeiro;
              while not Tabelas.campo.EOF do
              begin
                try
                  if (Tabelas.campo.Tipo = 'String') or (Tabelas.campo.Tipo = 'BLOB') then
                  begin
                    if (Tabelas.campo.Nome = Tabelas.campo.PK) then
                      uDocs.Add('* @apiParam {String{..'+Tabelas.campo.Tamanho.ToString+'}} '+Tabelas.campo.Nome + ' Chave primária')
                    else
                    begin
                      if Tabelas.campo.Tamanho = 1 then
                        uDocs.Add('* @apiParam {String{..'+Tabelas.campo.Tamanho.ToString+'}} '+Tabelas.campo.Nome+ ' ("S" ou "N") ')
                      else
                        uDocs.Add('* @apiParam {String{..'+Tabelas.campo.Tamanho.ToString+'}} '+Tabelas.campo.Nome);
                    end;
                  end
                  else if (Tabelas.campo.Tipo = 'Integer') or (Tabelas.campo.Tipo = 'Real') or (Tabelas.campo.Tipo = 'Extended') then
                  begin
                    if (Tabelas.campo.Nome = Tabelas.campo.PK) then
                      uDocs.Add('* @apiParam {Number} '+Tabelas.campo.Nome+' Chave primária')
                    else
                      uDocs.Add('* @apiParam {Number} '+Tabelas.campo.Nome);
                  end
                  else if Tabelas.campo.Tipo = 'TTime' then
                  begin
                    uDocs.Add('* @apiParam {Date} '+Tabelas.campo.Nome);
                  end
                  else if (Tabelas.campo.Tipo = 'TDate') or (Tabelas.campo.Tipo = 'TDateTime') then
                  begin
                    uDocs.Add('* @apiParam {Date} '+Tabelas.campo.Nome);
                  end
                  else
                  begin
                    if (Tabelas.campo.Nome = Tabelas.campo.PK) then
                      uDocs.Add('* @apiParam {String{..'+Tabelas.campo.Tamanho.ToString+'}} '+Tabelas.campo.Nome + ' Chave primária')
                    else
                    begin
                      if Tabelas.campo.Tamanho = 1 then
                        uDocs.Add('* @apiParam {String{..'+Tabelas.campo.Tamanho.ToString+'}} '+Tabelas.campo.Nome + ' ("S" ou "N") ')
                      else
                        uDocs.Add('* @apiParam {String{..'+Tabelas.campo.Tamanho.ToString+'}} '+Tabelas.campo.Nome);
                    end;
                  end;
                finally
                  Tabelas.campo.proximo;
                end;
              end;
              uDocs.Add('*/');
              uDocs.Add('');

              uDocs.Add('/**');
              uDocs.Add('* @apiDefine Obj'+Tabelas.Nome(True));
              Tabelas.campo.primeiro;
              while not Tabelas.campo.EOF do
              begin
                try
                  if (Tabelas.campo.Tipo = 'String') or (Tabelas.campo.Tipo = 'BLOB') then
                  begin
                    if (Tabelas.campo.Nome = Tabelas.campo.PK) then
                      uDocs.Add('* @apiSuccess {String} '+Tabelas.campo.Nome + ' Chave primária')
                    else
                    begin
                      uDocs.Add('* @apiSuccess {String} '+Tabelas.campo.Nome);
                    end;
                  end
                  else if (Tabelas.campo.Tipo = 'Integer') or (Tabelas.campo.Tipo = 'Real') or (Tabelas.campo.Tipo = 'Extended') then
                  begin
                    if (Tabelas.campo.Nome = Tabelas.campo.PK) then
                      uDocs.Add('* @apiSuccess {Number} '+Tabelas.campo.Nome+' Chave primária')
                    else
                      uDocs.Add('* @apiSuccess {Number} '+Tabelas.campo.Nome);
                  end
                  else if Tabelas.campo.Tipo = 'TTime' then
                  begin
                    uDocs.Add('* @apiSuccess {Date} '+Tabelas.campo.Nome);
                  end
                  else if (Tabelas.campo.Tipo = 'TDate') or (Tabelas.campo.Tipo = 'TDateTime') then
                  begin
                    uDocs.Add('* @apiSuccess {Date} '+Tabelas.campo.Nome);
                  end
                  else
                  begin
                    if (Tabelas.campo.Nome = Tabelas.campo.PK) then
                      uDocs.Add('* @apiSuccess {String} '+Tabelas.campo.Nome + ' Chave primária')
                    else
                      uDocs.Add('* @apiSuccess {String} '+Tabelas.campo.Nome);
                  end;
                finally
                  Tabelas.campo.proximo;
                end;
              end;
              uDocs.Add('*/');
              uDocs.Add('');

              uDocs.Add('/**');
              uDocs.Add('* @api {get} '+Tabelas.Nome+'/all Listar todos ');
              uDocs.Add('* @apiVersion 1.0.0');
              uDocs.Add('* @apiName   '+Tabelas.Nome(True)+'_GetAll ');
              uDocs.Add('* @apiGroup  '+Tabelas.Nome(True));
              uDocs.Add('*');
              uDocs.Add('* @apiExample {curl} Exemplo de uso');
              uDocs.Add('*     curl -i http://localhost/v1/'+Tabelas.Nome+'/all');
              uDocs.Add('*');
              uDocs.Add('* @apiSuccessExample {json} (201) Resposta');
              uDocs.Add('*     HTTP/1.1 201 OK');
              uDocs.Add('*     [');
              uDocs.Add('*     {');
              uDocs.Add('*       "id": 165,');
              uDocs.Add('*       "codigo": "FF",');
              uDocs.Add('*       "nome": "NÃO TRIBUTADA",');
              uDocs.Add('*       "vl": "0,00",');
              uDocs.Add('*       "st": "N"');
              uDocs.Add('*     }');
              uDocs.Add('*     ]');
              uDocs.Add('*');
              uDocs.Add('* @apiErrorExample {json} 500 Internal');
              uDocs.Add('*     HTTP/1.1 500 Internal Server Error');
              uDocs.Add('*     {');
              uDocs.Add('*       "message": "Falha ao processar Requisição"');
              uDocs.Add('*     }');
              uDocs.Add('*/');
              uDocs.Add('');
              uDocs.Add('');
              uDocs.Add('/**');
              uDocs.Add('* @api {get} '+Tabelas.Nome+'/pagina/:page Listar página ');
              uDocs.Add('* @apiVersion 1.0.0');
              uDocs.Add('* @apiName   '+Tabelas.Nome(True)+'_GetPagina ');
              uDocs.Add('* @apiGroup  '+Tabelas.Nome(True));
              uDocs.Add('* @apiParam {Number} page Número da página');
              uDocs.Add('*');
              uDocs.Add('* @apiExample {curl} Exemplo de uso');
              uDocs.Add('*     curl -i http://localhost/v1/'+Tabelas.Nome+'/pagina/1');
              uDocs.Add('*');
              uDocs.Add('* @apiSuccessExample {json} (201) Resposta');
              uDocs.Add('*HTTP/1.1 201 OK');
              uDocs.Add('*{');
              uDocs.Add('*  "total": "1",');
              uDocs.Add('*  "last_page": 1,');
              uDocs.Add('*  "per_page": 15,');
              uDocs.Add('*  "current_page": "1",');
              uDocs.Add('*  "from": 0,');
              uDocs.Add('*  "to": 15,');
              uDocs.Add('*  "data": [');
              uDocs.Add('*     {');
              uDocs.Add('*       "id": 165,');
              uDocs.Add('*       "codigo": "FF",');
              uDocs.Add('*       "nome": "NÃO TRIBUTADA",');
              uDocs.Add('*       "vl": "0,00",');
              uDocs.Add('*       "st": "N"');
              uDocs.Add('*     }');
              uDocs.Add('*  ]');
              uDocs.Add('*}');
              uDocs.Add('*');
              uDocs.Add('* @apiErrorExample {json} 500 Internal');
              uDocs.Add('*     HTTP/1.1 500 Internal Server Error');
              uDocs.Add('*     {');
              uDocs.Add('*       "message": "Falha ao processar Requisição"');
              uDocs.Add('*     }');
              uDocs.Add('*/');
              uDocs.Add('');
              uDocs.Add('');
              uDocs.Add('/**');
              uDocs.Add('* @api {get} '+Tabelas.Nome+'/id/:id Buscar por ID ');
              uDocs.Add('* @apiVersion 1.0.0');
              uDocs.Add('* @apiName   '+Tabelas.Nome(True)+'_GetByID ');
              uDocs.Add('* @apiGroup  '+Tabelas.Nome(True));
              uDocs.Add('* @apiParam {Number} '+Tabelas.PK+' Chave primária    ');
              uDocs.Add('* @apiUse Obj'+Tabelas.Nome(True));
              uDocs.Add('*');
              uDocs.Add('* @apiSuccessExample {json} (200) Resposta');
              uDocs.Add('*HTTP/1.1 200 OK');
              uDocs.Add('*{');
              uDocs.Add('*  "total": "1",');
              uDocs.Add('*  "last_page": 1,');
              uDocs.Add('*  "per_page": 15,');
              uDocs.Add('*  "current_page": "1",');
              uDocs.Add('*  "from": 0,');
              uDocs.Add('*  "to": 15,');
              uDocs.Add('*  "data": [');
              uDocs.Add('*     {');
              uDocs.Add('*       "id": 165,');
              uDocs.Add('*       "codigo": "FF",');
              uDocs.Add('*       "nome": "NÃO TRIBUTADA",');
              uDocs.Add('*       "vl": "0,00",');
              uDocs.Add('*       "st": "N"');
              uDocs.Add('*     }');
              uDocs.Add('*  ]');
              uDocs.Add('*}');
              uDocs.Add('*');
              uDocs.Add('* @apiExample {curl} Exemplo de uso');
              uDocs.Add('*     curl -i http://localhost/'+Tabelas.Nome+'/id/1');
              uDocs.Add('*');
              uDocs.Add('* @apiErrorExample {json} 500 Internal');
              uDocs.Add('*     HTTP/1.1 500 Internal Server Error');
              uDocs.Add('*     {');
              uDocs.Add('*       "message": "Falha ao processar Requisição"');
              uDocs.Add('*     }');
              uDocs.Add('*/');
              uDocs.Add('');uDocs.Add('');
              uDocs.Add('/**');
              uDocs.Add('* @api {post} '+Tabelas.Nome+'/ Incluir Registro ');
              uDocs.Add('* @apiVersion 1.0.0');
              uDocs.Add('* @apiName   '+Tabelas.Nome(True)+'_Incluir ');
              uDocs.Add('* @apiGroup  '+Tabelas.Nome(True));
              uDocs.Add('* @apiUse Param'+Tabelas.Nome(True));
              uDocs.Add('* @apiUse Obj'+Tabelas.Nome(True));
              uDocs.Add('*');
              uDocs.Add('* @apiSuccessExample {json} 201 OK');
              uDocs.Add('*     HTTP/1.1 201 OK');
              uDocs.Add('*     {              ');
              uDocs.Add('*       "status": true');
              uDocs.Add('*       "message": "Registro adicionado com sucesso!"');
              uDocs.Add('*       "data": []');
              uDocs.Add('*     }');
              uDocs.Add('*');
              uDocs.Add('* @apiErrorExample {json} 404 not found');
              uDocs.Add('*     HTTP/1.1 404 not found');
              uDocs.Add('*     {');
              uDocs.Add('*       "status": false');
              uDocs.Add('*       "message": "Corpo da requisição não informado!"');
              uDocs.Add('*     }');
              uDocs.Add('* @apiErrorExample {json} 422 Unprocessable Entity');
              uDocs.Add('*     HTTP/1.1 422 Unprocessable Entity');
              uDocs.Add('*     {');
              uDocs.Add('*       "field": "Campo"');
              uDocs.Add('*       "message": "mensagem de validação"');
              uDocs.Add('*     }');
              uDocs.Add('* @apiErrorExample {json} 500 Internal');
              uDocs.Add('*     HTTP/1.1 500 Internal Server Error');
              uDocs.Add('*     {');
              uDocs.Add('*       "status": false');
              uDocs.Add('*       "message": "Falha ao processar Requisição"');
              uDocs.Add('*     }');
              uDocs.Add('*/');
              uDocs.Add('');
              uDocs.Add('');
              uDocs.Add('/**');
              uDocs.Add('* @api {put} '+Tabelas.Nome+'/:id Atualizar Registro');
              uDocs.Add('* @apiVersion 1.0.0');
              uDocs.Add('* @apiName   '+Tabelas.Nome(True)+'_Update ');
              uDocs.Add('* @apiGroup  '+Tabelas.Nome(True));
              uDocs.Add('* @apiUse Param'+Tabelas.Nome(True));
              uDocs.Add('*');
              uDocs.Add('* @apiSuccessExample {json} 200 OK');
              uDocs.Add('*     HTTP/1.1 200 OK');
              uDocs.Add('*     {              ');
              uDocs.Add('*       "message": "Atualizado com Sucesso"');
              uDocs.Add('*     }');
              uDocs.Add('*');
              uDocs.Add('* @apiSuccessExample  {json} 204 Nenhuma Alteração');
              uDocs.Add('*     HTTP/1.1 204 OK');
              uDocs.Add('*     {              ');
              uDocs.Add('*       "message": "Nenhum registro a ser atualizado"');
              uDocs.Add('*     }');
              uDocs.Add('*');
              uDocs.Add('* @apiErrorExample {json} 500 Internal');
              uDocs.Add('*     HTTP/1.1 500 Internal Server Error');
              uDocs.Add('*     {');
              uDocs.Add('*       "message": "Falha ao processar Requisição"');
              uDocs.Add('*     }');
              uDocs.Add('*/');
              uDocs.Add('');
              uDocs.Add('/**');
              uDocs.Add('* @api {delete} '+Tabelas.Nome+'/:id Remover Registro');
              uDocs.Add('* @apiVersion 1.0.0');
              uDocs.Add('* @apiName   '+Tabelas.Nome(True)+'_Delete ');
              uDocs.Add('* @apiGroup  '+Tabelas.Nome(True));
              uDocs.Add('* @apiParam {Number} '+Tabelas.PK+' Chave primária ');
              uDocs.Add('*');
              uDocs.Add('* @apiSuccessExample {json} 200 OK');
              uDocs.Add('*     HTTP/1.1 200 OK');
              uDocs.Add('*     {              ');
              uDocs.Add('*       "message": "Removido com Sucesso"');
              uDocs.Add('*     }');
              uDocs.Add('*');
              uDocs.Add('* @apiSuccessExample {json} 204 Nenhuma Alteração');
              uDocs.Add('*     HTTP/1.1 204 OK');
              uDocs.Add('*     {              ');
              uDocs.Add('*       "message": "Nenhum registro a ser removido"');
              uDocs.Add('*     }');
              uDocs.Add('*');
              uDocs.Add('* @apiErrorExample {json} 500 Internal');
              uDocs.Add('*     HTTP/1.1 500 Internal Server Error');
              uDocs.Add('*     {');
              uDocs.Add('*       "message": "Falha ao processar Requisição"');
              uDocs.Add('*     }');
              uDocs.Add('*/');
              uDocs.Add('');

              if not(FileExists(dm.fab.DirSaida+'docs\')) then
                ForceDirectories(dm.fab.DirSaida+'docs\');
              uDocs.SaveToFile(dm.fab.DirSaida+'docs\'+Tabelas.Nome+'.js');
            end;
          end;
        finally
          Tabelas.proximo;
          FreeAndNil(uDocs);
        end;
      end;
      Result := True;
    except
      Result := False;
    end;
  finally
    Tabelas.primeiro;
    FreeAndNil(Tabelas);
  end;
end;

end.

