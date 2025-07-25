import 'package:barcollector/src/auth/users_repository.dart';
import 'package:barcollector/src/data/product_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import '../middleware/_auth.dart';
import '../middleware/_cors.dart';

Handler middleware(Handler handler) {
  return handler
      .use(corsMiddleware())
      .use(authMiddleware())
      // É uma boa prática instanciar os repositórios dentro do provider
      // para gerenciar melhor o ciclo de vida, em vez de usar um singleton global.
      .use(provider<ProductRepository>((_) => ProductRepository()))
      .use(provider<UsersRepository>((_) => UsersRepository()));
}
