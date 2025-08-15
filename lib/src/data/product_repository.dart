import 'package:barcollector/src/database/database_connection.dart';
import 'package:postgres/postgres.dart';
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
    return results.map(Product.fromMap).toList();
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
    const sql = r'''
      SELECT id, name, barcode, price 
      FROM products 
      WHERE barcode = $1
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

    const sql = r'''
      INSERT INTO products (id, name, barcode, price) 
      VALUES ($1, $2, $3, $4)
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
    const sql = r'''
      UPDATE products 
      SET name = $2, barcode = $3, price = $4 
      WHERE id = $1
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

  /// Insere ou atualiza uma lista de produtos no banco de dados.
  ///
  /// Esta operação é conhecida como "upsert".
  /// - Se um produto com o mesmo `barcode` não existir, ele será inserido.
  /// - Se um produto com o mesmo `barcode` já existir, ele será atualizado
  ///   APENAS se o `name` ou `price` forem diferentes.
  ///
  /// A operação é atômica (realizada em uma transação).
  /// Retorna `true` se a operação for bem-sucedida, `false` caso contrário.
  Future<bool> bulkInsertProducts(List<Product> productsData) async {
    if (productsData.isEmpty) return true;

    try {
      await DatabaseConnection.transaction((session) async {
        const sql = '''
          INSERT INTO products (name, barcode, price)
          VALUES (@name, @barcode, @price)
          ON CONFLICT (barcode) DO UPDATE SET
            name = EXCLUDED.name,
            price = EXCLUDED.price
          WHERE
            products.name IS DISTINCT FROM EXCLUDED.name OR
            products.price IS DISTINCT FROM EXCLUDED.price;
        ''';

        // Usando Sql.named para alinhar com a documentação e simplificar o código.
        // O driver do banco de dados lida com a execução segura da query para cada item.
        for (final product in productsData) {
          await session.execute(
            Sql.named(sql),
            parameters: {
              'name': product.name,
              'barcode': product.barcode,
              'price': product.price,
            },
          );
        }
      });
      return true;
    } catch (e) {
      // Em uma aplicação real, use um logger mais robusto.
      print('Erro durante a inserção/atualização em massa de produtos: $e');
      return false;
    }
  }

  /// Remove um produto
  Future<bool> deleteProduct(String id) async {
    const sql = r'DELETE FROM products WHERE id = $1';
    final affectedRows = await DatabaseConnection.execute(sql, [id]);
    return affectedRows > 0;
  }
}
