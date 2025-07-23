import 'dart:ffi';

import 'package:barcollector/src/database/database_connection.dart';
import 'package:uuid/uuid.dart';

/// Representa um produto no sistema.
class Product {
  Product({
    required this.id,
    required this.name,
    required this.barcode,
    required this.price,
  });

  final String id;
  final String name;
  final String barcode;
  final double price;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'barcode': barcode,
        'price': price,
      };

  /// Cria um Product a partir de um Map (resultado do banco)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      name: map['name'] as String,
      barcode: map['barcode'] as String,
      price: double.parse(map['price'] as String),
    );
  }
}

/// Repositório para gerenciar produtos usando PostgreSQL.
class ProductRepository {
  /// Busca todos os produtos do banco de dados
  Future<List<Product>> getAllProducts() async {
    const sql = '''
      SELECT id, name, barcode, price 
      FROM products 
      ORDER BY name
    ''';

    final results = await DatabaseConnection.query(sql);
    return results.map((row) => Product.fromMap(row)).toList();
  }

  /// Busca um produto pelo ID
  Future<Product?> getProductById(String id) async {
    const sql = r'''
      SELECT id, name, barcode, price 
      FROM products 
      WHERE id = $1
    ''';

    final results = await DatabaseConnection.query(sql, [id]);
    if (results.isEmpty) return null;

    return Product.fromMap(results.first);
  }

  /// Busca produtos pelo código de barras
  Future<Product?> getProductByBarcode(String barcode) async {
    const sql = '''
      SELECT id, name, barcode, price 
      FROM products 
      WHERE barcode = \$1
    ''';

    final results = await DatabaseConnection.query(sql, [barcode]);
    if (results.isEmpty) return null;

    return Product.fromMap(results.first);
  }

  /// Cria um novo produto
  Future<Product> createProduct({
    required String name,
    required String barcode,
    required double price,
  }) async {
    final id = const Uuid().v4();

    const sql = '''
      INSERT INTO products (id, name, barcode, price) 
      VALUES (\$1, \$2, \$3, \$4)
    ''';

    await DatabaseConnection.execute(sql, [id, name, barcode, price]);

    return Product(
      id: id,
      name: name,
      barcode: barcode,
      price: price,
    );
  }

  /// Atualiza um produto existente
  Future<Product?> updateProduct({
    required String id,
    required String name,
    required String barcode,
    required double price,
  }) async {
    const sql = '''
      UPDATE products 
      SET name = \$2, barcode = \$3, price = \$4 
      WHERE id = \$1
    ''';

    final affectedRows = await DatabaseConnection.execute(sql, [id, name, barcode, price]);
    if (affectedRows == 0) return null;

    return Product(
      id: id,
      name: name,
      barcode: barcode,
      price: price,
    );
  }

  /// Remove um produto
  Future<bool> deleteProduct(String id) async {
    const sql = 'DELETE FROM products WHERE id = \$1';
    final affectedRows = await DatabaseConnection.execute(sql, [id]);
    return affectedRows > 0;
  }
}
