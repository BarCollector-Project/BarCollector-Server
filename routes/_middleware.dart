import 'package:barcollector/src/data/product_repository.dart';
import 'package:dart_frog/dart_frog.dart';

// Criamos uma única instância do repositório que será compartilhada.
// Isso é mais eficiente do que criar uma nova para cada requisição.
final _productRepository = ProductRepository();

/// Este middleware provê uma instância de [ProductRepository] conectada ao PostgreSQL.
Handler middleware(Handler handler) {
  return handler.use(
    // Agora, o provider simplesmente retorna a instância já existente.
    provider<ProductRepository>((context) => _productRepository),
  );
}
