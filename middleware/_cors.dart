import 'package:barcollector/src/data/product_repository.dart';
import 'package:dart_frog/dart_frog.dart';

// Criamos uma única instância do repositório que será compartilhada.
// Isso é mais eficiente do que criar uma nova para cada requisição.
final _productRepository = ProductRepository();

Handler middleware(Handler handler) {
  return handler
      .use(
          // Agora, o provider simplesmente retorna a instância já existente.
          provider<ProductRepository>((context) => _productRepository))
      .use(_corsMiddleware);
}

Handler _corsMiddleware(Handler handler) {
  return (context) async {
    final response = await handler(context);

    return response.copyWith(
      headers: {
        ...response.headers,
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept',
      },
    );
  };
}
