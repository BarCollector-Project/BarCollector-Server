import 'package:barcollector/src/data/product_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return handler.use(provider<ProductRepository>((_) => ProductRepository()));
}
