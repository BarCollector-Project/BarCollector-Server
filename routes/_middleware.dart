import 'package:barcollector/src/auth/users_repository.dart';
import 'package:barcollector/src/data/product_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import '../middleware/_auth.dart';
import '../middleware/_cors.dart';

ProductRepository productRepository = ProductRepository();

Handler middleware(Handler handler) {
  return handler
      .use(corsMiddleware())
      .use(authMiddleware())
      .use(
        provider<ProductRepository>(
          (_) => productRepository,
        ),
      )
      .use(provider<UsersRepository>((_) => UsersRepository()));
}
