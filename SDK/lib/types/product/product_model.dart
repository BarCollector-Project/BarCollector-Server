enum ProductColumns {
  // tabela es1a //
  /// es1a
  id('es1_cod'),

  /// es1a
  name('es1_descembalagem'),

  /// es1a
  barcode('es1_codbarra'),
  // tabela es1 //
  /// es1
  price('es1_prvarejo'),

  /// es1
  quatity('es2_qatu'),

  /// es1
  defaultSuppierId('cg2_cod');

  final String columnName;

  const ProductColumns(this.columnName);
}

class ProductModel {
  final int id;
  final String name;
  final String barcode;
  final double? price;
  final double? quatity;
  final int? defaultSuppierId;

  ProductModel({
    required this.id,
    required this.name,
    required this.barcode,
    this.price,
    this.quatity,
    this.defaultSuppierId,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map[ProductColumns.id.columnName] as int,
      name: map[ProductColumns.name.columnName] as String,
      barcode: map[ProductColumns.barcode.columnName] as String,
      price: map[ProductColumns.price.columnName] as double?,
      quatity: map[ProductColumns.quatity.columnName] as double?,
      defaultSuppierId: map[ProductColumns.defaultSuppierId.columnName] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ProductColumns.id.columnName: id,
      ProductColumns.name.columnName: name,
      ProductColumns.barcode.columnName: barcode,
      ProductColumns.price.columnName: price,
      ProductColumns.quatity.columnName: quatity,
      ProductColumns.defaultSuppierId.columnName: defaultSuppierId,
    };
  }
}
