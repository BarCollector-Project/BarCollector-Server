enum SupplierColumns {
  id('cg2_cod'),
  nome('cg2_nome'),
  fantasia('cg2_fantasia'),
  cnpj('cg2_cgc'),
  cpf('cg2_cpf'),

  /// "J" para pessoa júridica (CNPJ) ou "F" para pessoa física (CPF)
  tipoRegistro('cg2_tipopessoa');

  final String columnName;

  const SupplierColumns(this.columnName);
}

class SupplierModel {
  final int id;
  final String nome;
  final String? fantasia;
  final int? cnpj;
  final int? cpf;
  final String? tipoRegistro;

  SupplierModel({
    required this.id,
    required this.nome,
    this.fantasia,
    this.cnpj,
    this.cpf,
    this.tipoRegistro,
  });

  factory SupplierModel.fromMap(Map<String, dynamic> map) {
    return SupplierModel(
      id: map[SupplierColumns.id.columnName] as int,
      nome: map[SupplierColumns.nome.columnName] as String,
      fantasia: map[SupplierColumns.fantasia.columnName] as String?,
      cnpj: map[SupplierColumns.cnpj.columnName] as int?,
      cpf: map[SupplierColumns.cpf.columnName] as int?,
      tipoRegistro: map[SupplierColumns.tipoRegistro.columnName] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        SupplierColumns.id.columnName: id,
        SupplierColumns.nome.columnName: nome,
        SupplierColumns.fantasia.columnName: fantasia,
        SupplierColumns.cnpj.columnName: cnpj,
        SupplierColumns.cpf.columnName: cpf,
        SupplierColumns.tipoRegistro.columnName: tipoRegistro,
      };
}
