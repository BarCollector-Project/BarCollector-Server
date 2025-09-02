enum ValidityColumnsNames {
  /// PRIMARY
  id('es1v_id'),
  pId('es1_cod'),
  empresa('es1_empresa'),
  codigo('es1_codigo'),
  //O número do recebimento do produto
  // (Quando é lançado a nota de terceiro marcando para recebimento no coletor).
  recebimento('rec_codigo'),
  codEmpresa('cg2_cod'),
  estado('es1v_status'), //0 ou 1, sendo 1 o registro fechado
  quant('es1v_quant'),
  dtFabricacao('es1v_dtfabricacao'),
  dtValidade('es1v_dtvalidade'),
  lote('es1v_lote'),
  qtInicial('es1v_qtdeInicial'),
  dtCriacao('es1v_dtcriacao'); //CURDATE()

  final String columnName;
  const ValidityColumnsNames(this.columnName);
}

class ValidityModel {
  /// Null se for para um novo registro
  final int? id;
  final int pId;
  final int empresa;
  final int recebimento;
  final int codEmpresa;
  final int estado;
  final double quant;

  /// Data de fabricação não é obrigatório
  final DateTime? dtFabricacao;
  final DateTime dtValidade;
  final String lote;
  final double qtInicial;
  final DateTime? dtCriacao;

  ValidityModel({
    required this.pId,
    required this.empresa,
    required this.recebimento,
    required this.codEmpresa,
    required this.estado,
    required this.quant,
    required this.dtValidade,
    required this.lote,
    required this.qtInicial,
    this.dtFabricacao,
    this.dtCriacao,
    this.id,
  });

  factory ValidityModel.fromJson(Map<String, dynamic> json) {
    return ValidityModel(
      id: json[ValidityColumnsNames.id.columnName] as int?,
      pId: json[ValidityColumnsNames.pId.columnName] as int,
      empresa: json[ValidityColumnsNames.empresa.columnName] as int,
      recebimento: json[ValidityColumnsNames.recebimento.columnName] as int,
      codEmpresa: json[ValidityColumnsNames.codEmpresa.columnName] as int,
      estado: json[ValidityColumnsNames.estado.columnName] as int,
      quant: json[ValidityColumnsNames.quant.columnName] as double,
      dtFabricacao: json[ValidityColumnsNames.dtFabricacao.columnName] as DateTime?,
      dtValidade: json[ValidityColumnsNames.dtValidade.columnName] as DateTime,
      lote: json[ValidityColumnsNames.lote.columnName] as String,
      qtInicial: json[ValidityColumnsNames.qtInicial.columnName] as double,
      dtCriacao: json[ValidityColumnsNames.dtCriacao.columnName] as DateTime?,
    );
  }

  // ignore: comment_references
  /// Se [creationDate] for [true], o mapra será retornado com o [dtCriacao]
  ///
  /// (Haverá valor de [ValidityModel] foi instanciado de um registro de banco de dados)
  Map<String, dynamic> toJson({bool creationDate = false}) {
    return {
      ValidityColumnsNames.id.columnName: id,
      ValidityColumnsNames.pId.columnName: pId,
      ValidityColumnsNames.empresa.columnName: empresa,
      ValidityColumnsNames.recebimento.columnName: recebimento,
      ValidityColumnsNames.codEmpresa.columnName: codEmpresa,
      ValidityColumnsNames.estado.columnName: estado,
      ValidityColumnsNames.quant.columnName: quant,
      ValidityColumnsNames.dtFabricacao.columnName: dtFabricacao?.toIso8601String().substring(0, 10),
      ValidityColumnsNames.dtValidade.columnName: dtValidade.toIso8601String().substring(0, 10),
      ValidityColumnsNames.lote.columnName: lote,
      ValidityColumnsNames.qtInicial.columnName: qtInicial,
      if (creationDate) ValidityColumnsNames.dtCriacao.columnName: dtCriacao?.toIso8601String().substring(0, 10),
    };
  }
}
