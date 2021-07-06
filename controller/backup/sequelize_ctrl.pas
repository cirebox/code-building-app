unit Sequelize_Ctrl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TSequelize_Ctrl }

  TSequelize_Ctrl = class
    strict private
      class var FInstance: TSequelize_Ctrl;
      constructor CreatePrivate;
    private
      function GetJSON_Exemplo: String;
      function GerarConfigJson: Boolean;
      function GerarModelIndex: Boolean;
    public
      constructor Create;
      destructor  Destroy; override;
      class function GetInstance: TSequelize_Ctrl;
      function GerarModel: Boolean;
      function GerarRepositorio: Boolean;
      function GerarController: Boolean;
      function GerarDocumentacao(sURLBase: String = 'http://161.35.227.175:6900/v1/'; sVersaoDoc : String = '1.0.0'): Boolean;
      function GerarRoutes: Boolean;
      function GerarRouta: Boolean;
  end;

implementation

uses udm, Funcoes, TableCodeBuilding, SGDB_Ctrl;

{ TSequelize_Ctrl }

constructor TSequelize_Ctrl.CreatePrivate;
begin
  inherited Create;
end;

function TSequelize_Ctrl.GerarConfigJson: Boolean;
var
  uConfig  : TStringList;
  Tabelas : TCodeBuildingTabela;
begin
  try
    try
      Tabelas := TCodeBuildingTabela.Create;
      Tabelas.primeiro;
      while not Tabelas.EOF do
      begin
        try
          uConfig := TStringList.Create;
          if Tabelas.Selecionada then
          begin
            if not Tabelas.campo.Vazio then
            begin
              uConfig.Add('{');
              uConfig.Add('  "development": {');
              uConfig.Add('    "database": "maxxionline",');
              uConfig.Add('    "username": "postgres",');
              uConfig.Add('    "password": "postgres",');
              uConfig.Add('    "dialect": "postgres",');
              uConfig.Add('    "host": "127.0.0.1",');
              uConfig.Add('    "port": 5432,');
              uConfig.Add('    "logging": null,');
              uConfig.Add('    "define": {');
              uConfig.Add('      "timestamps": false,');
              uConfig.Add('      "underscored": true');
              uConfig.Add('    },');
              uConfig.Add('    "pool": {');
              uConfig.Add('      "max": 5,');
              uConfig.Add('      "min": 0,');
              uConfig.Add('      "idle": 10000');
              uConfig.Add('    },');
              uConfig.Add('    "retry": {');
              uConfig.Add('      "max": 2');
              uConfig.Add('    }');
              uConfig.Add('  },');
              uConfig.Add('  "test": {');
              uConfig.Add('    "database": "maxxionline",');
              uConfig.Add('    "username": "postgres",');
              uConfig.Add('    "password": "postgres",');
              uConfig.Add('    "dialect": "postgres",');
              uConfig.Add('    "host": "127.0.0.1",');
              uConfig.Add('    "port": 5432,');
              uConfig.Add('    "logging": null,');
              uConfig.Add('    "define": {');
              uConfig.Add('      "timestamps": false,');
              uConfig.Add('      "underscored": true');
              uConfig.Add('    },');
              uConfig.Add('    "pool": {');
              uConfig.Add('      "max": 5,');
              uConfig.Add('      "min": 0,');
              uConfig.Add('      "idle": 10000');
              uConfig.Add('    },');
              uConfig.Add('    "retry": {');
              uConfig.Add('      "max": 2');
              uConfig.Add('    }');
              uConfig.Add('  },');
              uConfig.Add('  "production": {');
              uConfig.Add('    "database": "maxxionline",');
              uConfig.Add('    "username": "postgres",');
              uConfig.Add('    "password": "postgres",');
              uConfig.Add('    "dialect": "postgres",');
              uConfig.Add('    "host": "127.0.0.1",');
              uConfig.Add('    "port": 5432,');
              uConfig.Add('    "logging": null,');
              uConfig.Add('    "define": {');
              uConfig.Add('      "timestamps": false,');
              uConfig.Add('      "underscored": true');
              uConfig.Add('    },');
              uConfig.Add('    "pool": {');
              uConfig.Add('      "max": 5,');
              uConfig.Add('      "min": 0,');
              uConfig.Add('      "idle": 10000');
              uConfig.Add('    },');
              uConfig.Add('    "retry": {');
              uConfig.Add('      "max": 2');
              uConfig.Add('    }');
              uConfig.Add('  }');
              uConfig.Add('}');
              if not(FileExists(dm.CodeBuilding.DirSaida+'config\')) then
                ForceDirectories(dm.CodeBuilding.DirSaida+'config\');
              uConfig.SaveToFile(dm.CodeBuilding.DirSaida+'config\config.json');
            end;
          end;
        finally
          FreeAndNil(uConfig);
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

function TSequelize_Ctrl.GerarModelIndex: Boolean;
var
  uIndex  : TStringList;
  Tabelas : TCodeBuildingTabela;
begin
  try
    try
      Tabelas := TCodeBuildingTabela.Create;
      Tabelas.primeiro;
      while not Tabelas.EOF do
      begin
        try
          uIndex := TStringList.Create;
          if Tabelas.Selecionada then
          begin
            if not Tabelas.campo.Vazio then
            begin
              uIndex.Add('"use strict";');
              uIndex.Add('');
              uIndex.Add('const fs = require("fs");');
              uIndex.Add('const path = require("path");');
              uIndex.Add('const Sequelize = require("sequelize");');
              uIndex.Add('const basename = path.basename(__filename);');
              uIndex.Add('const env = process.env.NODE_ENV || "development";');
              uIndex.Add('const config = require(__dirname + "/../config/config.json")[env];');
              uIndex.Add('');
              uIndex.Add('const db = {};');
              uIndex.Add('');
              uIndex.Add('const Op = Sequelize.Op;');
              uIndex.Add('const opAlias = {');
              uIndex.Add('  "eq": Op.eq,');
              uIndex.Add('  ''ne'': Op.ne,');
              uIndex.Add('  ''gte'': Op.gte,');
              uIndex.Add('  ''gt'': Op.gt,');
              uIndex.Add('  ''lte'': Op.lte,');
              uIndex.Add('  ''lt'': Op.lt,');
              uIndex.Add('  ''not'': Op.not,');
              uIndex.Add('  ''in'': Op.in,');
              uIndex.Add('  ''notIn'': Op.notIn,');
              uIndex.Add('  ''is'': Op.is,');
              uIndex.Add('  "like": Op.like,');
              uIndex.Add('  ''notLike'': Op.notLike,');
              uIndex.Add('  ''iLike'': Op.iLike,');
              uIndex.Add('  ''notILike'': Op.notILike,');
              uIndex.Add('  ''regexp'': Op.regexp,');
              uIndex.Add('  ''notRegexp'': Op.notRegexp,');
              uIndex.Add('  ''iRegexp'': Op.iRegexp,');
              uIndex.Add('  ''notIRegexp'': Op.notIRegexp,');
              uIndex.Add('  ''between'': Op.between,');
              uIndex.Add('  ''notBetween'': Op.notBetween,');
              uIndex.Add('  ''overlap'': Op.overlap,');
              uIndex.Add('  ''contains'': Op.contains,');
              uIndex.Add('  ''contained'': Op.contained,');
              uIndex.Add('  ''adjacent'': Op.adjacent,');
              uIndex.Add('  ''strictLeft'': Op.strictLeft,');
              uIndex.Add('  ''strictRight'': Op.strictRight,');
              uIndex.Add('  ''noExtendRight'': Op.noExtendRight,');
              uIndex.Add('  ''noExtendLeft'': Op.noExtendLeft,');
              uIndex.Add('  ''and'': Op.and,');
              uIndex.Add('  ''or'': Op.or,');
              uIndex.Add('  ''any'': Op.any,');
              uIndex.Add('  ''all'': Op.all,');
              uIndex.Add('  ''values'': Op.values,');
              uIndex.Add('  ''col'': Op.col');
              uIndex.Add('};');
              uIndex.Add('');
              uIndex.Add('config.operatorsAliases = opAlias;');
              uIndex.Add('');
              uIndex.Add('let sequelize;');
              uIndex.Add('if (config.use_env_variable) {');
              uIndex.Add('  sequelize = new Sequelize(process.env[config.use_env_variable], config);');
              uIndex.Add('} else {');
              uIndex.Add('  sequelize = new Sequelize(config);');
              uIndex.Add('}');
              uIndex.Add('fs.readdirSync(__dirname)');
              uIndex.Add('  .filter(file => {');
              uIndex.Add('    return (');
              uIndex.Add('      file.indexOf(".") !== 0 && file !== basename && file.slice(-3) === ".js"');
              uIndex.Add('    );');
              uIndex.Add('  })');
              uIndex.Add('  .forEach(file => {');
              uIndex.Add('    const model = sequelize["import"](path.join(__dirname, file));');
              uIndex.Add('    db[model.name] = model;');
              uIndex.Add('  });');
              uIndex.Add('');
              uIndex.Add('Object.keys(db).forEach(modelName => {');
              uIndex.Add('  if (db[modelName].associate) {');
              uIndex.Add('    db[modelName].associate(db);');
              uIndex.Add('  }');
              uIndex.Add('});');
              uIndex.Add('');
              uIndex.Add('db.sequelize = sequelize;');
              uIndex.Add('db.Sequelize = Sequelize;');
              uIndex.Add('');
              uIndex.Add('module.exports = db;');
              if not(FileExists(dm.CodeBuilding.DirSaida+'models\')) then
                ForceDirectories(dm.CodeBuilding.DirSaida+'models\');
              uIndex.SaveToFile(dm.CodeBuilding.DirSaida+'models\index.js');
            end;
          end;
        finally
          FreeAndNil(uIndex);
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

constructor TSequelize_Ctrl.Create;
begin
  raise Exception.Create('Objeto Singleton');
end;

destructor TSequelize_Ctrl.Destroy;
begin
  inherited Destroy;
end;

class function TSequelize_Ctrl.GetInstance: TSequelize_Ctrl;
begin
  if not Assigned(FInstance) then
    FInstance := TSequelize_Ctrl.CreatePrivate;

  Result := FInstance;
end;

function TSequelize_Ctrl.GerarModel: Boolean;
var
  uModel    : TStringList;
  Tabelas   : TCodeBuildingTabela;
  sNomeTable: String;
  sNomeModel: String;
begin
  try
    try
      Tabelas := TCodeBuildingTabela.Create;
      Tabelas.primeiro;
      while not Tabelas.EOF do
      begin
        try
          uModel := TStringList.Create;
          if Tabelas.Selecionada then
          begin
            if not Tabelas.Vazio then
            begin
              sNomeTable := Tabelas.Nome(true);
              sNomeModel := Tabelas.Nome;
              uModel.Add(QuotedStr('use strict'));
              uModel.Add('');
              uModel.Add('const sequelizePaginate = require(''sequelize-paginate'');');
              uModel.Add('');
              uModel.Add('module.exports = (sequelize, DataTypes) => {');
              uModel.Add('  const '+sNomeTable+' = sequelize.define(');
              uModel.Add('    '+QuotedStr(Tabelas.Nome)+',');
              uModel.Add('    {');
              Tabelas.campo.primeiro;
              while not Tabelas.campo.Eof do
              begin
                try
                  uModel.Add('      '+Tabelas.campo.Nome+': {');
                  if Tabelas.campo.Tipo = 'String' then
                  begin
                    uModel.Add('        type: DataTypes.STRING,');
                    if Tabelas.campo.isUnique then
                      uModel.Add('        unique: true,');
                    if (Tabelas.campo.NotNull) then
                    begin
                      uModel.Add('        allowNull: false,');
                      uModel.Add('        validate: {');
                      uModel.Add('          notEmpty: {');
                      uModel.Add('            msg: "Esse campo não pode ser vazio ou nulo!"');
                      uModel.Add('          },');
                      if (Tabelas.campo.Tamanho > 0) then
                      begin
                        uModel.Add('          len: {');
                        uModel.Add('            args: [0,'+Tabelas.campo.Tamanho.ToString()+'],');
                        uModel.Add('            msg: "Esse campo não pode passar de '+Tabelas.campo.Tamanho.ToString()+' caracter!",');
                        uModel.Add('          },');
                      end;
                      uModel.Add('        },');
                    end;
                  end
                  else if Tabelas.campo.Tipo = 'Real' then
                  begin
                    uModel.Add('        type: DataTypes.DOUBLE,');
                  end
                  else if Tabelas.campo.Tipo = 'TDate' then
                  begin
                    uModel.Add('        type: DataTypes.DATEONLY,');
                  end
                  else if Tabelas.campo.Tipo = 'TTime' then
                  begin
                    uModel.Add('        type: DataTypes.TIME,');
                  end
                  else if Tabelas.campo.Tipo = 'Integer' then
                  begin
                    uModel.Add('        type: DataTypes.INTEGER,');
                    if Tabelas.campo.isUnique then
                      uModel.Add('        unique: true,');
                  end
                  else if Tabelas.campo.Tipo = 'BigInt' then
                  begin
                    uModel.Add('        type: DataTypes.BIGINT,');
                    if Tabelas.campo.isUnique then
                      uModel.Add('        unique: true,');
                  end
                  else if Tabelas.campo.Tipo = 'Extended' then
                  begin
                    uModel.Add('        type: DataTypes.DECIMAL(10,3),');
                  end
                  else if Tabelas.campo.Tipo = 'TDateTime' then
                  begin
                    uModel.Add('        type: DataTypes.DATE,');
                  end
                  else if Tabelas.campo.Tipo = 'BLOB' then
                  begin
                    uModel.Add('        type: DataTypes.TEXT,');
                  end
                  else
                  begin
                    uModel.Add('        type: '+Tabelas.campo.Tipo+',');
                    if Tabelas.campo.isUnique then
                      uModel.Add('        unique: true,');
                  end;
                  //Gera problema na hora de fazer um insert
                  if (Tabelas.campo.PK = Tabelas.campo.Nome) then
                  begin
                    uModel.Add('        autoIncrement: true,');
                    uModel.Add('        primaryKey: true');
                  end;
                  uModel.Add('      },');
                finally
                  Tabelas.campo.proximo;
                end;
              end;
              uModel.Add('    },');
              uModel.Add('    {');
              uModel.Add('      modelName: '+QuotedStr(Tabelas.Nome)+',');
              uModel.Add('      //Nome da tabela no banco');
              uModel.Add('      tableName: '+QuotedStr(Tabelas.Nome)+',');
              uModel.Add('      //Para não adicionar os campos timestamp (updatedAt, createdAt)');
              uModel.Add('      timestamps: false,');
              uModel.Add('    }');
              uModel.Add('  );');
              uModel.Add('  '+sNomeTable+'.associate = function(models) {');
              uModel.Add('');
              Tabelas.Dependencias.primeiro;
              while not Tabelas.Dependencias.Eof do
              begin
                try
                  uModel.Add('    '+sNomeTable+'.hasMany(models.'+Tabelas.Dependencias.TABELA+', {');
                  uModel.Add('      foreignKey: '''+Tabelas.Dependencias.FIELD+''',');
                  uModel.Add('      sourceKey: '''+Tabelas.Dependencias.FIELD_REF+''',');
                  uModel.Add('      as: '''+Tabelas.Dependencias.TABELA+''',');
                  uModel.Add('    });');
                  uModel.Add('');
                finally
                  Tabelas.Dependencias.proximo;
                end;
              end;
              Tabelas.Relacionamento.primeiro;
              while not Tabelas.Relacionamento.Eof do
              begin
                try
                  uModel.Add('    '+sNomeTable+'.belongsTo(models.'+Tabelas.Relacionamento.FK_TABLE+', {');
                  uModel.Add('      foreignKey: '''+Tabelas.Relacionamento.FIELD+''',');
                  uModel.Add('     // sourceKey: '''+Tabelas.Relacionamento.FK_FIELD+''',');
                  uModel.Add('      targetKey: '''+Tabelas.Relacionamento.FK_FIELD+''',');
                  uModel.Add('      as: '''+Tabelas.Relacionamento.FK_TABLE+''',');
                  uModel.Add('    });');
                  uModel.Add('');
                finally
                  Tabelas.Relacionamento.proximo;
                end;
              end;
              uModel.Add('  };');
              uModel.Add('  sequelizePaginate.paginate('+sNomeTable+');');
              uModel.Add('  return '+sNomeTable+';');
              uModel.Add('};');
              if not(FileExists(dm.CodeBuilding.DirSaida+'models\')) then
                ForceDirectories(dm.CodeBuilding.DirSaida+'models\');
              uModel.SaveToFile(dm.CodeBuilding.DirSaida+'models\'+Tabelas.Nome+'.js');
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
    GerarConfigJson;
    GerarModelIndex;
  end;
end;

function TSequelize_Ctrl.GerarRepositorio: Boolean;
var
  uRepo   : TStringList;
  Tabelas : TCodeBuildingTabela;
begin
  try
    try
      Tabelas := TCodeBuildingTabela.Create;
      Tabelas.primeiro;
      while not Tabelas.EOF do
      begin
        try
          uRepo := TStringList.Create;
          if Tabelas.Selecionada then
          begin
            if not Tabelas.campo.Vazio then
            begin
              uRepo.Add('"use strict";');
              uRepo.Add('const { QueryTypes, Op } = require("sequelize");');
              uRepo.Add('const model = require("../models/index");');
              uRepo.Add('');
              uRepo.Add('const '+Tabelas.Nome+' = model.'+Tabelas.Nome+'; ');
              uRepo.Add('');
              uRepo.Add('exports.valida = async (data) => {');
              uRepo.Add('  let modelBuild = '+Tabelas.Nome+'.build(data);');
              uRepo.Add('  let validateErrors = await modelBuild.validate().catch((err) => err.errors);');
              uRepo.Add('  return validateErrors;');
              uRepo.Add('};');
              uRepo.Add('');
              Tabelas.Unique.primeiro;
              if not Tabelas.Unique.Vazio then
              begin
                uRepo.Add('exports.isUnique = async (obj) => {');
                uRepo.Add('  const res = await '+Tabelas.Nome+'.findOne({');
                uRepo.Add('    where: {');
                if Tabelas.Unique.count > 1 then
                begin
                  uRepo.Add('      [Op.and]: [');
                  while not Tabelas.Unique.EOF do
                  begin
                    uRepo.Add('        { '+Tabelas.Unique.FIELD+': obj.'+Tabelas.Unique.FIELD+' },');
                  end;
                  uRepo.Add('      ]');
                end
                else
                begin
                  uRepo.Add('         '+Tabelas.Unique.FIELD+': obj.'+Tabelas.Unique.FIELD);
                end;
                uRepo.Add('    }');
                uRepo.Add('  });');
                uRepo.Add('  if (!res) {');
                uRepo.Add('    return false;');
                uRepo.Add('  } else {');
                uRepo.Add('    if (res.id === obj.id) {');
                uRepo.Add('      return false;');
                uRepo.Add('    } else {');
                uRepo.Add('      return true;');
                uRepo.Add('    }');
                uRepo.Add('  }');
                uRepo.Add('};');
                uRepo.Add('');
              end;
              uRepo.Add('async function relacao(join) {');
              uRepo.Add('  var includes = [];');
              uRepo.Add('  for (const item of join) {');
              uRepo.Add('    var include = [];');
              uRepo.Add('    if (item.join != null) {');
              uRepo.Add('      include = await relacao(item.join);');
              uRepo.Add('    }');
              uRepo.Add('    includes.push({');
              uRepo.Add('      attributes: item.field,');
              uRepo.Add('      model: model[item.table],');
              uRepo.Add('      as: item.table,');
              uRepo.Add('      where: item.where,');
              uRepo.Add('      order: item.order,');
              uRepo.Add('      group: item.group,');
              uRepo.Add('      limit: item.limit,');
              uRepo.Add('      offset: item.offset,');
              uRepo.Add('      include: include,');
              uRepo.Add('    });');
              uRepo.Add('  }');
              uRepo.Add('  return includes;');
              uRepo.Add('}');
              uRepo.Add('');
              uRepo.Add('exports.list = async (options) => {');
              uRepo.Add('  var query = {');
              uRepo.Add('    //Campos');
              uRepo.Add('    attributes: options.field,');
              uRepo.Add('    where: options.where,');
              uRepo.Add('    limit: options.limit,');
              uRepo.Add('    offset: options.offset,');
              uRepo.Add('    order: [''id''],');
              uRepo.Add('    group: {}');
              uRepo.Add('  }');
              uRepo.Add('');
              uRepo.Add('  //Order by');
              uRepo.Add('  if (options.order != '''') {');
              uRepo.Add('    query[''order''] = options.order;');
              uRepo.Add('  }');
              uRepo.Add('');
              uRepo.Add('  //Group by');
              uRepo.Add('  if (options.group != '''') {');
              uRepo.Add('    query[''group''] = options.group;');
              uRepo.Add('  }');
              uRepo.Add('');
              uRepo.Add('  //Include');
              uRepo.Add('  if (options.join != null) {');
              uRepo.Add('    query[''include''] = await relacao(options.join);');
              uRepo.Add('  }');
              uRepo.Add('');
              uRepo.Add('  //Paginação');
              uRepo.Add('  if (options.page > 0) {');
              uRepo.Add('    query[''page''] = options.page;');
              uRepo.Add('    query[''paginate''] = 25;');
              uRepo.Add('    const res = await '+Tabelas.Nome+'.paginate(query);');
              uRepo.Add('    return res;');
              uRepo.Add('  } else {');
              uRepo.Add('    const res = await '+Tabelas.Nome+'.findAll(query);');
              uRepo.Add('    return res;');
              uRepo.Add('  }');
              uRepo.Add('}');
              uRepo.Add('');
              uRepo.Add('exports.create = async data => {');
              uRepo.Add('  const res = '+Tabelas.Nome+'.create(data);');
              uRepo.Add('  return res;');
              uRepo.Add('};');
              uRepo.Add('');
              uRepo.Add('exports.update = async (data, id) => {');
              uRepo.Add('  const res = await '+Tabelas.Nome+'.update(data, { where: { id: id } });');
              uRepo.Add('  return res;');
              uRepo.Add('};');
              uRepo.Add('');
              uRepo.Add('exports.delete = async (options) => {');
              uRepo.Add('  const query = { where: options.where };');
              uRepo.Add('  const res   = await '+Tabelas.Nome+'.destroy(query);');
              uRepo.Add('  return res;');
              uRepo.Add('};');
              if not(FileExists(dm.CodeBuilding.DirSaida+'repositories\')) then
                ForceDirectories(dm.CodeBuilding.DirSaida+'repositories\');
              uRepo.SaveToFile(dm.CodeBuilding.DirSaida+'repositories\'+Tabelas.Nome+'-repository.js');
            end;
          end;
        finally
          FreeAndNil(uRepo);
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

function TSequelize_Ctrl.GerarController: Boolean;
var
  uCtrl : TStringList;
  Tabelas : TCodeBuildingTabela;
begin
  try
    try
      Tabelas := TCodeBuildingTabela.Create;
      Tabelas.primeiro;
      while not Tabelas.EOF do
      begin
        try
          uCtrl := TStringList.Create;
          if Tabelas.Selecionada then
          begin
            if not Tabelas.campo.Vazio then
            begin
              uCtrl.Add('"use strict";');
              uCtrl.Add('const repository = require("../repositories/'+Tabelas.Nome+'-repository");');
              uCtrl.Add('');
              uCtrl.Add('exports.list = async (req, res, next) => {');
              uCtrl.Add('  try {');
              uCtrl.Add('    const data = await repository.list(req.body);');
              uCtrl.Add('    if (!data) {');
              uCtrl.Add('      res.status(204).send({');
              uCtrl.Add('        status: true,');
              uCtrl.Add('        pages: 0,');
              uCtrl.Add('        total: 0,');
              uCtrl.Add('        data: []');
              uCtrl.Add('      });');
              uCtrl.Add('    } else {');
              uCtrl.Add('      if (data.pages == null) {');
              uCtrl.Add('        res.status(201).send({');
              uCtrl.Add('          status: true,');
              uCtrl.Add('          data: data');
              uCtrl.Add('        });');
              uCtrl.Add('      } else {');
              uCtrl.Add('        res.status(201).send({');
              uCtrl.Add('          status: true,');
              uCtrl.Add('          pages: data.pages,');
              uCtrl.Add('          total: data.total,');
              uCtrl.Add('          data: data.docs');
              uCtrl.Add('        });');
              uCtrl.Add('      }');
              uCtrl.Add('    }');
              uCtrl.Add('  } catch (e) {');
              uCtrl.Add('    console.log(e)');
              uCtrl.Add('    res.status(500).send(');
              uCtrl.Add('      {');
              uCtrl.Add('        status: false,');
              uCtrl.Add('        message: "Falha ao processar sua requisição",');
              uCtrl.Add('        error: e.message,');
              uCtrl.Add('      },');
              uCtrl.Add('    );');
              uCtrl.Add('  }');
              uCtrl.Add('}');
              uCtrl.Add('');
              //uCtrl.Add('exports.getById = async (req, res, next) => {');
              //uCtrl.Add('  try {');
              //uCtrl.Add('    var data = await repository.getById(req.params.id);');
              //uCtrl.Add('    if (!data) {');
              //uCtrl.Add('      res.status(204).send({');
              //uCtrl.Add('        status: true,');
              //uCtrl.Add('        data: []');
              //uCtrl.Add('      });');
              //uCtrl.Add('    } else {');
              //uCtrl.Add('      res.status(201).send({');
              //uCtrl.Add('        status: true,');
              //uCtrl.Add('        data: data');
              //uCtrl.Add('      });');
              //uCtrl.Add('    }');
              //uCtrl.Add('  } catch (e) {');
              //uCtrl.Add('    console.log(e)');
              //uCtrl.Add('    res.status(500).send(');
              //uCtrl.Add('      {');
              //uCtrl.Add('        status: false,');
              //uCtrl.Add('        message: "Falha ao processar sua requisição",');
              //uCtrl.Add('        error: e.message,');
              //uCtrl.Add('      },');
              //uCtrl.Add('    );');
              //uCtrl.Add('  }');
              //uCtrl.Add('};');
              //uCtrl.Add('');
              uCtrl.Add('exports.add = async (req, res, next) => {');
              uCtrl.Add('  try {');
              uCtrl.Add('    if (!req.body) {');
              uCtrl.Add('      res.status(404).send({');
              uCtrl.Add('        status: false,');
              uCtrl.Add('        message: "Corpo da requisição não informado!"');
              uCtrl.Add('      });');
              uCtrl.Add('      return;');
              uCtrl.Add('    }');
              uCtrl.Add('');
              uCtrl.Add('    let validateErrors = await repository.valida(req.body);');
              uCtrl.Add('    if (validateErrors.length > 0) {');
              uCtrl.Add('      let field = validateErrors[0].path;');
              uCtrl.Add('      let message = validateErrors[0].message;');
              uCtrl.Add('      res.status(422).send({ field, message });');
              uCtrl.Add('    }');
              uCtrl.Add('');
              if not Tabelas.Unique.Vazio then
              begin
                uCtrl.Add('    var isUnique = await repository.isUnique(req.body);');
                uCtrl.Add('');
                uCtrl.Add('    if (isUnique) {');
                uCtrl.Add('      res.status(422).send({');
                uCtrl.Add('        status: false,');
                uCtrl.Add('        message: "'+Tabelas.Nome(true)+' já cadastrada"');
                uCtrl.Add('      });');
                uCtrl.Add('    }');
                uCtrl.Add('');
              end;
              uCtrl.Add('    var data = await repository.create(req.body);');
              uCtrl.Add('    if (!data) {');
              uCtrl.Add('      res.status(404).send({');
              uCtrl.Add('        status: false,');
              uCtrl.Add('        message: "Falha ao processar sua requisição"');
              uCtrl.Add('      });');
              uCtrl.Add('    } else {');
              uCtrl.Add('      res.status(201).send({');
              uCtrl.Add('        status: true,');
              uCtrl.Add('        message: "Registro adicionado com sucesso!",');
              uCtrl.Add('        data: data,');
              uCtrl.Add('      });');
              uCtrl.Add('    }');
              uCtrl.Add('  } catch (e) {');
              uCtrl.Add('    console.log(e)');
              uCtrl.Add('    res.status(500).send(');
              uCtrl.Add('      {');
              uCtrl.Add('        status: false,');
              uCtrl.Add('        message: "Falha ao processar sua requisição",');
              uCtrl.Add('        error: e.message,');
              uCtrl.Add('      },');
              uCtrl.Add('    );');
              uCtrl.Add('  }');
              uCtrl.Add('};');
              uCtrl.Add('');
              uCtrl.Add('exports.update = async (req, res) => {');
              uCtrl.Add('  try {');
              uCtrl.Add('    if (!req.body.id) {');
              uCtrl.Add('      res.status(404).send({');
              uCtrl.Add('        status: false,');
              uCtrl.Add('        message: "id não informado!"');
              uCtrl.Add('      });');
              uCtrl.Add('      return;');
              uCtrl.Add('    }');
              uCtrl.Add('');
              uCtrl.Add('    if (!req.body || !req.body.id) {');
              uCtrl.Add('      res.status(404).send({');
              uCtrl.Add('        status: false,');
              uCtrl.Add('        message: "Corpo da requisição não informado!"');
              uCtrl.Add('      });');
              uCtrl.Add('      return;');
              uCtrl.Add('    }');
              uCtrl.Add('');
              if not Tabelas.Unique.Vazio then
              begin
                uCtrl.Add('    var isUnique = await repository.isUnique(req.body);');
                uCtrl.Add('');
                uCtrl.Add('    if (isUnique) {');
                uCtrl.Add('      res.status(422).send({');
                uCtrl.Add('        status: false,');
                uCtrl.Add('        message: "'+Tabelas.Nome(true)+' já cadastrada"');
                uCtrl.Add('      });');
                uCtrl.Add('    }');
                uCtrl.Add('');
              end;
              uCtrl.Add('    let validateErrors = await repository.valida(req.body);');
              uCtrl.Add('    if (validateErrors.length > 0) {');
              uCtrl.Add('      let field = validateErrors[0].path;');
              uCtrl.Add('      let message = validateErrors[0].message;');
              uCtrl.Add('      res.status(422).send({ field, message });');
              uCtrl.Add('    }');
              uCtrl.Add('');
              uCtrl.Add('    var data = await repository.update(req.body, req.body.id);');
              uCtrl.Add('    if (!data) {');
              uCtrl.Add('      res.status(404).send({');
              uCtrl.Add('        status: false,');
              uCtrl.Add('        message: "Falha ao processar sua requisição"');
              uCtrl.Add('      });');
              uCtrl.Add('    } else {');
              uCtrl.Add('      res.status(201).send({');
              uCtrl.Add('        status: true,');
              uCtrl.Add('        message: "Registro atualizado com sucesso!"');
              uCtrl.Add('      });');
              uCtrl.Add('    }');
              uCtrl.Add('  } catch (e) {');
              uCtrl.Add('    console.log(e)');
              uCtrl.Add('    res.status(500).send(');
              uCtrl.Add('      {');
              uCtrl.Add('        status: false,');
              uCtrl.Add('        message: "Falha ao processar sua requisição",');
              uCtrl.Add('        error: e.message,');
              uCtrl.Add('      },');
              uCtrl.Add('    );');
              uCtrl.Add('  }');
              uCtrl.Add('};');
              uCtrl.Add('');
              uCtrl.Add('exports.delete = async (req, res) => {');
              uCtrl.Add('  try {');
              uCtrl.Add('    var data = await repository.delete(req.body);');
              uCtrl.Add('');
              uCtrl.Add('    if (!data) {');
              uCtrl.Add('      res.status(204).send({');
              uCtrl.Add('        status: false,');
              uCtrl.Add('        message: "Nenhum registro para deleta"');
              uCtrl.Add('      });');
              uCtrl.Add('    } else {');
              uCtrl.Add('      res.status(201).send({');
              uCtrl.Add('        status: true,');
              uCtrl.Add('        message: "Registro removido com sucesso!"');
              uCtrl.Add('      });');
              uCtrl.Add('    }');
              uCtrl.Add('  } catch (e) {');
              uCtrl.Add('    //console.log(e)');
              uCtrl.Add('    if (e.message.trim().toUpperCase().indexOf("VIOLATES FOREIGN KEY CONSTRAINT") > -1) {');
              uCtrl.Add('      res.status(200).send({');
              uCtrl.Add('        status: false,');
              uCtrl.Add('        message: "Este registro foi utilizado em algum lançamento!"');
              uCtrl.Add('      });');
              uCtrl.Add('    } else {');
              uCtrl.Add('      res.status(500).send(');
              uCtrl.Add('        {');
              uCtrl.Add('          message: "Falha ao processar sua requisição",');
              uCtrl.Add('          error: e.message,');
              uCtrl.Add('        },');
              uCtrl.Add('      );');
              uCtrl.Add('    }');
              uCtrl.Add('  }');
              uCtrl.Add('};');
              if not(FileExists(dm.CodeBuilding.DirSaida+'controllers\')) then
                ForceDirectories(dm.CodeBuilding.DirSaida+'controllers\');
              uCtrl.SaveToFile(dm.CodeBuilding.DirSaida+'controllers\'+Tabelas.Nome+'-controller.js');
            end;
          end;
        finally
          FreeAndNil(uCtrl);
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

function TSequelize_Ctrl.GerarDocumentacao(sURLBase: String; sVersaoDoc : String): Boolean;
var
  uDoc : TStringList;
  Tabelas : TCodeBuildingTabela;
  function isRequerid: String;
  begin
    if Tabelas.campo.NotNull then
      Result := '(Obrigatório)'
    else
      Result := '';
  end;
begin
  try
    try
      Tabelas := TCodeBuildingTabela.Create;
      Tabelas.primeiro;
      try
        uDoc := TStringList.Create;
        uDoc.Add('/**');
        uDoc.Add('* @api {post} http://161.35.227.175:6900/auth Autenticação Token');
        uDoc.Add('* @apiVersion '+sVersaoDoc);
        uDoc.Add('* @apiName   AUTH');
        uDoc.Add('* @apiGroup  Autenticação');
        uDoc.Add('* @apiParam {String} login (Obrigatório) ');
        uDoc.Add('* @apiParam {String} senha (Obrigatório) ');
        uDoc.Add('*');
        uDoc.Add('* @apiParamExample {json} ID Body');
        uDoc.Add('* {');
        uDoc.Add('*   "login": "api@systems.com.br",');
        uDoc.Add('*   "senha": "123"');
        uDoc.Add('* }');
        uDoc.Add('*');
        uDoc.Add('* @apiSuccessExample {json} (200) Resposta');
        uDoc.Add('*     HTTP/1.1 200 OK');
        uDoc.Add('*     ');
        uDoc.Add('*       {');
        uDoc.Add('*         "status": true,');
	uDoc.Add('*         "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNTk4NjMzODI0LCJleHAiOjE1OTg2NjI2MjR9.c0UGpDC_FMr7X07sA2awN-HBVUMjxHe-dLIJaVF4PWk"');
	uDoc.Add('*       }');
        uDoc.Add('*');
        uDoc.Add('* @apiErrorExample {json} 404 Not Acceptable');
        uDoc.Add('*     HTTP/1.1 404 Not Acceptable');
        uDoc.Add('*     ');
        uDoc.Add('*       {');
        uDoc.Add('*         "status": false,');
        uDoc.Add('*         "message": "Faltando parametro" ');
        uDoc.Add('*       }');
        uDoc.Add('*     ');
	uDoc.Add('*');
	uDoc.Add('* @apiErrorExample {json} 500 Internal');
        uDoc.Add('*     HTTP/1.1 500 Internal Server Error');
        uDoc.Add('*     ');
        uDoc.Add('*       {');
        uDoc.Add('*         "status": false,');
        uDoc.Add('*         "message": "Falha ao autenticar!" ');
        uDoc.Add('*       }');
        uDoc.Add('*     ');
        uDoc.Add('*/');
        if not(FileExists(dm.CodeBuilding.DirSaida+'docs\')) then
          ForceDirectories(dm.CodeBuilding.DirSaida+'docs\');
        uDoc.SaveToFile(dm.CodeBuilding.DirSaida+'docs\auth.js');
      finally
        FreeAndNil(uDoc);
      end;
      while not Tabelas.EOF do
      begin
        try
          uDoc := TStringList.Create;
          if Tabelas.Selecionada then
          begin
            if not Tabelas.campo.Vazio then
            begin
              uDoc.Add('/**');
              uDoc.Add('* @apiDefine Param'+Tabelas.Nome(True));
              Tabelas.campo.primeiro;
              while not Tabelas.campo.EOF do
              begin
                try
                  if (Tabelas.campo.Tipo = 'String') or (Tabelas.campo.Tipo = 'BLOB') then
                  begin
                    if (Tabelas.campo.Nome = Tabelas.campo.PK) then
                      uDoc.Add('* @apiParam {String{..'+Tabelas.campo.Tamanho.ToString+'}} '+Tabelas.campo.Nome + isRequerid + ' Chave primária')
                    else
                    begin
                      if Tabelas.campo.Tamanho = 1 then
                        uDoc.Add('* @apiParam {String{..'+Tabelas.campo.Tamanho.ToString+'}} '+Tabelas.campo.Nome + isRequerid+ ' value["S" ou "N"] = Sim ou Não')
                      else
                        uDoc.Add('* @apiParam {String{..'+Tabelas.campo.Tamanho.ToString+'}} '+Tabelas.campo.Nome+ isRequerid);
                    end;
                  end
                  else if (Tabelas.campo.Tipo = 'Integer') or
                  (Tabelas.campo.Tipo = 'Real') or
                  (Tabelas.campo.Tipo = 'Extended') or
                  (Tabelas.campo.Tipo = 'Double') or
                  (Tabelas.campo.Tipo = 'Decimal') or
                  (Tabelas.campo.Tipo = 'BigInt') then
                  begin
                    if (Tabelas.campo.Nome = Tabelas.campo.PK) then
                      uDoc.Add('* @apiParam {Number} '+Tabelas.campo.Nome + isRequerid +' Chave primária')
                    else
                      uDoc.Add('* @apiParam {Number} '+Tabelas.campo.Nome + isRequerid);
                  end
                  else if (Tabelas.campo.Tipo = 'Boolean') then
                  begin
                    uDoc.Add('* @apiParam {Boolean} '+Tabelas.campo.Nome + isRequerid);
                  end
                  else if Tabelas.campo.Tipo = 'TTime' then
                  begin
                    uDoc.Add('* @apiParam {Date} '+Tabelas.campo.Nome + isRequerid);
                  end
                  else if (Tabelas.campo.Tipo = 'TDate') or (Tabelas.campo.Tipo = 'TDateTime') then
                  begin
                    uDoc.Add('* @apiParam {Date} '+Tabelas.campo.Nome + isRequerid);
                  end
                  else
                  begin
                    if (Tabelas.campo.Nome = Tabelas.campo.PK) then
                      uDoc.Add('* @apiParam {String{..'+Tabelas.campo.Tamanho.ToString+'}} '+Tabelas.campo.Nome + isRequerid + ' Chave primária')
                    else
                    begin
                      if Tabelas.campo.Tamanho = 1 then
                        uDoc.Add('* @apiParam {String{..'+Tabelas.campo.Tamanho.ToString+'}} '+Tabelas.campo.Nome + isRequerid + ' ("S" ou "N") ')
                      else
                        uDoc.Add('* @apiParam {String{..'+Tabelas.campo.Tamanho.ToString+'}} '+Tabelas.campo.Nome + isRequerid);
                    end;
                  end;
                finally
                  Tabelas.campo.proximo;
                end;
              end;
              uDoc.Add('*/');
              uDoc.Add('');
              uDoc.Add('/**');
              uDoc.Add('* @apiDefine Obj'+Tabelas.Nome(True));
              Tabelas.campo.primeiro;
              while not Tabelas.campo.EOF do
              begin
                try
                  if (Tabelas.campo.Tipo = 'String') or (Tabelas.campo.Tipo = 'BLOB') then
                  begin
                    if (Tabelas.campo.Nome = Tabelas.campo.PK) then
                      uDoc.Add('* @apiSuccess {String} '+Tabelas.campo.Nome + ' Chave primária')
                    else
                    begin
                      uDoc.Add('* @apiSuccess {String} '+Tabelas.campo.Nome);
                    end;
                  end
                  else if (Tabelas.campo.Tipo = 'Integer') or
                  (Tabelas.campo.Tipo = 'Real') or
                  (Tabelas.campo.Tipo = 'Extended') or
                  (Tabelas.campo.Tipo = 'Double') or
                  (Tabelas.campo.Tipo = 'Decimal') or
                  (Tabelas.campo.Tipo = 'BigInt') then
                  begin
                    if (Tabelas.campo.Nome = Tabelas.campo.PK) then
                      uDoc.Add('* @apiSuccess {Number} '+Tabelas.campo.Nome+' Chave primária')
                    else
                      uDoc.Add('* @apiSuccess {Number} '+Tabelas.campo.Nome);
                  end
                  else if (Tabelas.campo.Tipo = 'Boolean') then
                  begin
                    uDoc.Add('* @apiSuccess {Boolean} '+Tabelas.campo.Nome);
                  end
                  else if Tabelas.campo.Tipo = 'TTime' then
                  begin
                    uDoc.Add('* @apiSuccess {Date} '+Tabelas.campo.Nome);
                  end
                  else if (Tabelas.campo.Tipo = 'TDate') or (Tabelas.campo.Tipo = 'TDateTime') then
                  begin
                    uDoc.Add('* @apiSuccess {Date} '+Tabelas.campo.Nome);
                  end
                  else
                  begin
                    if (Tabelas.campo.Nome = Tabelas.campo.PK) then
                      uDoc.Add('* @apiSuccess {String} '+Tabelas.campo.Nome + ' Chave primária')
                    else
                      uDoc.Add('* @apiSuccess {String} '+Tabelas.campo.Nome);
                  end;
                finally
                  Tabelas.campo.proximo;
                end;
              end;
              uDoc.Add('*/');
              uDoc.Add('');
              uDoc.Add('/**');
              uDoc.Add('* @api {post} '+sUrlBase+Tabelas.Nome+'/listar 1º Listar - '+Tabelas.Nome(True));
              uDoc.Add('* @apiVersion '+sVersaoDoc);
              uDoc.Add('* @apiName   '+Tabelas.Nome(True)+'_LISTAR ');
              uDoc.Add('* @apiGroup  '+Tabelas.Nome(True));
              uDoc.Add('* @apiUse Obj'+Tabelas.Nome(True));
              uDoc.Add('*');
              uDoc.Add('* @apiParamExample {json} Sem Página');
              uDoc.Add('* {');
              uDoc.Add('*   "field": ["id"...],');
              uDoc.Add('*   "join": [,');
              Tabelas.Relacionamento.primeiro;
              while not Tabelas.Relacionamento.Eof do
              begin
                try
                  uDoc.Add('*             {');
                  uDoc.Add('*               "field": ["id"...],');
                  uDoc.Add('*               "table": '+QuotedStr(Tabelas.Relacionamento.FK_TABLE)+',');
                  uDoc.Add('*               "limit": 10,');
                  uDoc.Add('*               "join": []');
                  uDoc.Add('*               "where": {');
                  uDoc.Add('*                  "id": {');
                  uDoc.Add('*                     "gt": 1 //Retorna todo id maior que 1');
                  uDoc.Add('*                  }');
                  uDoc.Add('*               },');
                  uDoc.Add('*               "order": [["id","DESC"]], //ordenar por id');
                  uDoc.Add('*             }');
                finally
                  Tabelas.Relacionamento.proximo;
                end;
              end;
              uDoc.Add('*   ],');
              uDoc.Add('*   "where": {');
              uDoc.Add('*      "id": {');
              uDoc.Add('*         "gt": 1 //Retorna todo id maior que 1');
              uDoc.Add('*      }');
              uDoc.Add('*   },');
              uDoc.Add('*   "order": [["id","DESC"]], //ordenar por id');
              uDoc.Add('* }');
              uDoc.Add('*');
              uDoc.Add('* @apiParamExample {json} Usando Página');
              uDoc.Add('* {');
              uDoc.Add('*   "page": 1,');
              uDoc.Add('*   "field": ["id"...],');
              uDoc.Add('*   "join": [,');
              Tabelas.Relacionamento.primeiro;
              while not Tabelas.Relacionamento.Eof do
              begin
                try
                  uDoc.Add('*             {');
                  uDoc.Add('*               "field": ["id"...],');
                  uDoc.Add('*               "table": '+QuotedStr(Tabelas.Relacionamento.FK_TABLE)+', ');
                  uDoc.Add('*               "limit": 10,');
                  uDoc.Add('*               "join": []');
                  uDoc.Add('*               "where": {');
                  uDoc.Add('*                  "id": {');
                  uDoc.Add('*                     "gt": 1 //Retorna todo id maior que 1');
                  uDoc.Add('*                  }');
                  uDoc.Add('*               },');
                  uDoc.Add('*               "order": [["id","DESC"]], //ordenar por id');
                  uDoc.Add('*             }');
                finally
                  Tabelas.Relacionamento.proximo;
                end;
              end;
              uDoc.Add('*   ],');
              uDoc.Add('*   "where": {');
              uDoc.Add('*      "id": {');
              uDoc.Add('*         "gt": 1 //Retorna todo id maior que 1');
              uDoc.Add('*      }');
              uDoc.Add('*   },');
              uDoc.Add('*   "order": [["id","DESC"]], //ordenar por id');
              uDoc.Add('* }');
              uDoc.Add('*');
              uDoc.Add('* @apiSuccessExample {json} (201) SEM PAGINA');
              uDoc.Add('*     HTTP/1.1 201 OK');
              uDoc.Add('*     ');
              uDoc.Add('*       {');
              uDoc.Add('*         "status": true,');
              if not dm.Zqry.IsEmpty then
              begin
                uDoc.Add('*         "data": [');
                uDoc.Add('*           {');
                Tabelas.campo.primeiro;
                while not Tabelas.campo.EOF do
                begin
                  try
                    uDoc.Add(Tabelas.campo.Value);
                  finally
                    Tabelas.campo.proximo;
                  end;
                end;
                uDoc.Add('*           }');
                uDoc.Add('*         ]');
              end
              else
              begin
                uDoc.Add('*         "data": []');
              end;
              uDoc.Add('*       }');
              uDoc.Add('*');
              uDoc.Add('* @apiSuccessExample {json} (201) PAGINADO');
              uDoc.Add('*     HTTP/1.1 201 OK');
              uDoc.Add('*     ');
              uDoc.Add('*       {');
              uDoc.Add('*         "status": true,');
              if not dm.Zqry.IsEmpty then
              begin
                uDoc.Add('*         "pages": 1,');
                uDoc.Add('*         "total": 1,');
                uDoc.Add('*         "data": [');
                uDoc.Add('*           {');
                Tabelas.campo.primeiro;
                while not Tabelas.campo.EOF do
                begin
                  try
                    uDoc.Add(Tabelas.campo.Value);
                  finally
                    Tabelas.campo.proximo;
                  end;
                end;
                uDoc.Add('*           }');
                uDoc.Add('*         ]');
              end
              else
              begin
                uDoc.Add('*         "pages": 1,');
                uDoc.Add('*         "total": 1,');
                uDoc.Add('*         "data": []');
              end;
              uDoc.Add('*       }');
              uDoc.Add('*');
              uDoc.Add('* @apiSuccessExample {json} (204) Resposta Vazia');
              uDoc.Add('*     HTTP/1.1 204 OK');
              uDoc.Add('*     ');
              uDoc.Add('*       {');
              uDoc.Add('*         "status": true,');
              uDoc.Add('*         "pages": 0,');
              uDoc.Add('*         "total": 0,');
              uDoc.Add('*         "data": [],');
              uDoc.Add('*       }');
              uDoc.Add('*     ');
              uDoc.Add('*');
              uDoc.Add('* @apiErrorExample {json} 500 Internal');
              uDoc.Add('*     HTTP/1.1 500 Internal Server Error');
              uDoc.Add('*     ');
              uDoc.Add('*       {');
              uDoc.Add('*         "status": false,');
              uDoc.Add('*         "message": "Falha ao processar requisição!", ');
              uDoc.Add('*         "error": "Mensagem de erro.."');
              uDoc.Add('*       }');
              uDoc.Add('*     ');
              uDoc.Add('*/');
              uDoc.Add('');
              uDoc.Add('');
              uDoc.Add('/**');
              //uDoc.Add('* @api {get} '+sUrlBase+Tabelas.Nome+'/:id 2º Buscar por ID ');
              //uDoc.Add('* @apiVersion '+sVersaoDoc);
              //uDoc.Add('* @apiName   '+Tabelas.Nome(True)+'_GetByID ');
              //uDoc.Add('* @apiGroup  '+Tabelas.Nome(True));
              //uDoc.Add('* @apiParam {Number} '+Tabelas.PK+' Chave primária    ');
              //uDoc.Add('* @apiUse Obj'+Tabelas.Nome(True));
              //uDoc.Add('*');
              //uDoc.Add('* @apiExample {curl} Exemplo de uso');
              //uDoc.Add('*     curl -i '+sUrlBase+Tabelas.Nome+'/1');
              //uDoc.Add('*');
              //uDoc.Add('* @apiSuccessExample {json} (201) Resposta');
              //uDoc.Add('*     HTTP/1.1 201 OK');
              //uDoc.Add('*       {');
              //uDoc.Add('*         "status": true,');
              //if not dm.Zqry.IsEmpty then
              //begin
              //  uDoc.Add('*         "data": [');
              //  uDoc.Add('*           {');
              //  Tabelas.campo.primeiro;
              //  while not Tabelas.campo.EOF do
              //  begin
              //    try
              //      uDoc.Add(Tabelas.campo.Value);
              //    finally
              //      Tabelas.campo.proximo;
              //    end;
              //  end;
              //  uDoc.Add('*           }');
              //  uDoc.Add('*         ]');
              //end
              //else
              //begin
              //  uDoc.Add('*         "data": []');
              //end;
              //uDoc.Add('*       }');
              //uDoc.Add('*');
              //uDoc.Add('* @apiSuccessExample {json} (204) Resposta');
              //uDoc.Add('*     HTTP/1.1 204 OK');
              //uDoc.Add('*     ');
              //uDoc.Add('*       {');
              //uDoc.Add('*         "status": true,');
              //uDoc.Add('*         "data": [] ');
              //uDoc.Add('*       }');
              //uDoc.Add('*     ');
              //uDoc.Add('*');
              //uDoc.Add('* @apiErrorExample {json} 500 Internal');
              //uDoc.Add('*     HTTP/1.1 500 Internal Server Error');
              //uDoc.Add('*     ');
              //uDoc.Add('*       {');
              //uDoc.Add('*         "status": false,');
              //uDoc.Add('*         "message": "Falha ao processar requisição!", ');
              //uDoc.Add('*         "error": "Mensagem de erro..."');
              //uDoc.Add('*       }');
              //uDoc.Add('*     ');
              //uDoc.Add('*/');
              //uDoc.Add('');
              uDoc.Add('/**');
              uDoc.Add('* @api {post} '+sUrlBase+Tabelas.Nome+'/ 2º Incluir Registro - '+Tabelas.Nome(true));
              uDoc.Add('* @apiVersion '+sVersaoDoc);
              uDoc.Add('* @apiName   '+Tabelas.Nome(True)+'_ADD ');
              uDoc.Add('* @apiGroup  '+Tabelas.Nome(True));
              uDoc.Add('* @apiUse Param'+Tabelas.Nome(True));
              uDoc.Add('* @apiUse Obj'+Tabelas.Nome(True));
              uDoc.Add('*');
              uDoc.Add('* @apiSuccessExample {json} 201 OK');
              uDoc.Add('*     HTTP/1.1 201 OK');
              uDoc.Add('*     {              ');
              uDoc.Add('*       "status": true,');
              uDoc.Add('*       "message": "Registro adicionado com sucesso!"');
              if not dm.Zqry.IsEmpty then
              begin
                uDoc.Add('*       "data": [');
                uDoc.Add('*           {');
                Tabelas.campo.primeiro;
                while not Tabelas.campo.EOF do
                begin
                  try
                    uDoc.Add(Tabelas.campo.Value);
                  finally
                    Tabelas.campo.proximo;
                  end;
                end;
                uDoc.Add('*           }');
                uDoc.Add('*         ]');
              end
              else
              begin
                uDoc.Add('*         "data": []');
              end;
              uDoc.Add('*     }');
              uDoc.Add('*');
              uDoc.Add('* @apiErrorExample {json} 422 Unprocessable Entity');
              uDoc.Add('*     HTTP/1.1 422 Unprocessable Entity');
              uDoc.Add('*     ');
              uDoc.Add('*       {');
              uDoc.Add('*         "field": "[Fields invalidos]..",');
              uDoc.Add('*         "message": "exemplo: Campo não preenchido..." ');
              uDoc.Add('*       }');
              uDoc.Add('*     ');
              uDoc.Add('*');
              uDoc.Add('* @apiErrorExample {json} 500 Internal');
              uDoc.Add('*     HTTP/1.1 500 Internal Server Error');
              uDoc.Add('*     ');
              uDoc.Add('*       {');
              uDoc.Add('*         "status": false,');
              uDoc.Add('*         "message": "Falha ao processar requisição!", ');
              uDoc.Add('*         "error": "Mensagem de erro..."');
              uDoc.Add('*       }');
              uDoc.Add('*     ');
              uDoc.Add('*/');
              uDoc.Add('');
              uDoc.Add('/**');
              uDoc.Add('* @api {put} '+sUrlBase+Tabelas.Nome+'/ 3º Atualizar Registro - '+Tabelas.Nome(True));
              uDoc.Add('* @apiVersion '+sVersaoDoc);
              uDoc.Add('* @apiName   '+Tabelas.Nome(True)+'_Update ');
              uDoc.Add('* @apiGroup  '+Tabelas.Nome(True));
              uDoc.Add('* @apiUse Param'+Tabelas.Nome(True));
              uDoc.Add('*');
              uDoc.Add('* @apiSuccessExample {json} 201 OK');
              uDoc.Add('*     HTTP/1.1 201 OK');
              uDoc.Add('*     {              ');
              uDoc.Add('*       "status": true,');
              uDoc.Add('*       "message": "Atualizado com Sucesso"');
              uDoc.Add('*     }');
              uDoc.Add('*');
              uDoc.Add('@apiError id Parâmetro não informado!');
              uDoc.Add('@apiError Body Corpo da requisição não informado!');
              uDoc.Add('*');
              uDoc.Add('* @apiErrorExample {json} 404 Not Found');
              uDoc.Add('*     HTTP/1.1 404 Not Found');
              uDoc.Add('*     ');
              uDoc.Add('*       {');
              uDoc.Add('*         "status": false,');
              uDoc.Add('*         "message": "Falha ao processar sua requisição" ');
              uDoc.Add('*       }');
              uDoc.Add('*     ');
              uDoc.Add('*');
              uDoc.Add('* @apiErrorExample {json} 422 Unprocessable Entity');
              uDoc.Add('*     HTTP/1.1 422 Unprocessable Entity');
              uDoc.Add('*     ');
              uDoc.Add('*       {');
              uDoc.Add('*         "field": "[Fields invalidos]..",');
              uDoc.Add('*         "message": "exemplo: Campo não preenchido..." ');
              uDoc.Add('*       }');
              uDoc.Add('*     ');
              uDoc.Add('*');
              uDoc.Add('* @apiErrorExample {json} 500 Internal');
              uDoc.Add('*     HTTP/1.1 500 Internal Server Error');
              uDoc.Add('*     ');
              uDoc.Add('*       {');
              uDoc.Add('*         "status": false,');
              uDoc.Add('*         "message": "Falha ao processar requisição!", ');
              uDoc.Add('*         "error": "Mensagem de erro..."');
              uDoc.Add('*       }');
              uDoc.Add('*     ');
              uDoc.Add('*/');
              uDoc.Add('');
              uDoc.Add('/**');
              uDoc.Add('* @api {post} '+sUrlBase+Tabelas.Nome+'/delete 4º Remover Registro - '+Tabelas.Nome(true));
              uDoc.Add('* @apiVersion '+sVersaoDoc);
              uDoc.Add('* @apiName   '+Tabelas.Nome(True)+'_Delete ');
              uDoc.Add('* @apiGroup  '+Tabelas.Nome(True));
              uDoc.Add('* @apiParam {Number} '+Tabelas.PK+' Chave primária ');
              uDoc.Add('*');
              uDoc.Add('*');
              uDoc.Add('* @apiParamExample {json} where Body');
              uDoc.Add('* {');
              uDoc.Add('*   "where": {"id": 1}');
              uDoc.Add('* }');
              uDoc.Add('*');
              uDoc.Add('* @apiExample {curl} Exemplo de uso');
              uDoc.Add('*     curl -X DELETE '+sUrlBase+Tabelas.Nome+'/');
              uDoc.Add('*');
              uDoc.Add('* @apiSuccessExample {json} 201 OK');
              uDoc.Add('*     HTTP/1.1 201 OK');
              uDoc.Add('*     {              ');
              uDoc.Add('*       "status": true,');
              uDoc.Add('*       "message": "Registro removido com sucesso!"');
              uDoc.Add('*     }');
              uDoc.Add('*');
              uDoc.Add('* @apiSuccessExample {json} 204 Nenhuma Alteração');
              uDoc.Add('*     HTTP/1.1 204 OK');
              uDoc.Add('*     {              ');
              uDoc.Add('*       "status": false,');
              uDoc.Add('*       "message": "Nenhum registro para deleta"');
              uDoc.Add('*     }');
              uDoc.Add('*');
              uDoc.Add('* @apiErrorExample {json} 500 Internal');
              uDoc.Add('*     HTTP/1.1 500 Internal Server Error');
              uDoc.Add('*     {');
              uDoc.Add('*       "message": "Falha ao processar Requisição",');
              uDoc.Add('*       "error": "Mensagem de erro..."');
              uDoc.Add('*     }');
              uDoc.Add('*/');
              uDoc.Add('');

              if not(FileExists(dm.CodeBuilding.DirSaida+'docs\')) then
                ForceDirectories(dm.CodeBuilding.DirSaida+'docs\');
              uDoc.SaveToFile(dm.CodeBuilding.DirSaida+'docs\'+Tabelas.Nome+'.js');
            end;
          end;
        finally
          FreeAndNil(uDoc);
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

function TSequelize_Ctrl.GerarRoutes: Boolean;
var
  uRoutes : TStringList;
  Tabelas : TCodeBuildingTabela;
begin
  try
    try
      Tabelas := TCodeBuildingTabela.Create;
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
              uRoutes.Add('var controller = require('+QuotedStr('../../controllers/'+Tabelas.Nome+'-controller')+');');
              uRoutes.Add('');
              uRoutes.Add('router.post(''/listar'', controller.list);');
              uRoutes.Add('router.post(''/'', controller.add);');
              uRoutes.Add('router.put(''/'', controller.update);');
              uRoutes.Add('router.post(''/delete'', controller.delete);');
              uRoutes.Add('');
              uRoutes.Add('module.exports = router;');
              uRoutes.Add('');

              if not(FileExists(dm.CodeBuilding.DirSaida+'routes\v1\')) then
                ForceDirectories(dm.CodeBuilding.DirSaida+'routes\v1\');
              uRoutes.SaveToFile(dm.CodeBuilding.DirSaida+'routes\v1\'+Tabelas.Nome+'-route.js');
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

function TSequelize_Ctrl.GerarRouta: Boolean;
var
  uRoutes : TStringList;
  Tabelas : TCodeBuildingTabela;
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
      Tabelas := TCodeBuildingTabela.Create;
      Tabelas.primeiro;
      while not Tabelas.EOF do
      begin
        try
          if Tabelas.Selecionada then
            if not Tabelas.campo.Vazio then
              uRoutes.Add('var '+Tabelas.Nome+' = require('+QuotedStr('../routes/v1/'+Tabelas.Nome+'-route')+');');
        finally
          Tabelas.proximo;
        end;
      end;
      uRoutes.Add('const jwt = require("jsonwebtoken");');
      uRoutes.Add('const MYSECRET = "@#CHAVE#123";');
      uRoutes.Add('');
      uRoutes.Add('// metodo para autenticação');
      uRoutes.Add('app.get("/auth", (req, res) => {');
      uRoutes.Add('  try {');
      uRoutes.Add('    var id = 1;');
      uRoutes.Add('    // Aqui Entra a verificação se usa ou não o consulta comanda...');
      uRoutes.Add('    if (id > 0) {');
      uRoutes.Add('      //auth ok');
      uRoutes.Add('      var token = jwt.sign({ id }, MYSECRET, {');
      uRoutes.Add('        expiresIn: 28800 // expires in 5min // 7200 2Horas');
      uRoutes.Add('      });');
      uRoutes.Add('      res.status(200).send({');
      uRoutes.Add('        status: true,');
      uRoutes.Add('        token: token');
      uRoutes.Add('      });');
      uRoutes.Add('    } else {');
      uRoutes.Add('      res.status(404).send({');
      uRoutes.Add('        status: false,');
      uRoutes.Add('        message: "Faltando parametro"');
      uRoutes.Add('      });');
      uRoutes.Add('    }');
      uRoutes.Add('  } catch {');
      uRoutes.Add('    res.status(500).send({');
      uRoutes.Add('      status: false,');
      uRoutes.Add('      message: "Falha ao autenticar!"');
      uRoutes.Add('    });');
      uRoutes.Add('  }');
      uRoutes.Add('});');
      uRoutes.Add('');
      uRoutes.Add('//Middleware para verificar autenticação');
      uRoutes.Add('app.use(function verificaJWT(req, res, next) {');
      uRoutes.Add('  var token = req.headers["auth"];');
      uRoutes.Add('  if (!token)');
      uRoutes.Add('    return res.status(401).send({');
      uRoutes.Add('      status: false,');
      uRoutes.Add('      message: "Não foi possivel autenticar"');
      uRoutes.Add('    });');
      uRoutes.Add('');
      uRoutes.Add('  jwt.verify(token, MYSECRET, function(err, decoded) {');
      uRoutes.Add('    if (err)');
      uRoutes.Add('      return res.status(500).send({');
      uRoutes.Add('        status: false,');
      uRoutes.Add('        message: "Falha na autenticação"');
      uRoutes.Add('      });');
      uRoutes.Add('    // se tudo estiver ok, salva no request para uso posterior');
      uRoutes.Add('    req.userId = decoded.id;');
      uRoutes.Add('    next();');
      uRoutes.Add('  });');
      uRoutes.Add('});');
      uRoutes.Add('');
      uRoutes.Add('app.use(function timeLog(req, res, next) {');
      uRoutes.Add('    var data = new Date() ;');
      uRoutes.Add('    data.setHours(data.getHours() - 3) // Joga o fuso horário Brasileiro');
      uRoutes.Add('    console.log(''Time: '', data.toGMTString());');
      uRoutes.Add('    next();');
      uRoutes.Add('});');
      uRoutes.Add('');
      Tabelas := TCodeBuildingTabela.Create;
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

      if not(FileExists(dm.CodeBuilding.DirSaida+'routes\')) then
        ForceDirectories(dm.CodeBuilding.DirSaida+'routes\');
      uRoutes.SaveToFile(dm.CodeBuilding.DirSaida+'routes\v1.js');

      Result := True;
    except
      Result := False;
    end;
  finally
    Tabelas.primeiro;
    FreeAndNil(Tabelas);
  end;
end;

function TSequelize_Ctrl.GetJSON_Exemplo: String;
begin

end;

end.

