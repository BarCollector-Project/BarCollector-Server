import 'package:barcollector/src/auth/users_repository.dart';
import 'package:barcollector/src/data/product_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'middleware/_auth.dart';
import 'middleware/_cors.dart';
import 'middleware/_wasm.dart';

ProductRepository productRepository = ProductRepository();

Handler middleware(Handler handler) {
  // A ordem de execução é o inverso da ordem das chamadas .use().
  // Para que o `corsMiddleware` execute primeiro, ele deve ser o último na cadeia.
  return handler
      .use(provider<UsersRepository>((_) => UsersRepository()))
      .use(provider<ProductRepository>((_) => productRepository))
      .use(authMiddleware())
      .use(corsMiddleware())
      .use(wasmContentTypeFixer());
}
