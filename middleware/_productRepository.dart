import 'package:barcollector/src/data/product_repository.dart';
import 'package:dart_frog/dart_frog.dart';

final ProductRepository pRepository = ProductRepository();

Middleware productRepository() {
  return provider<ProductRepository>((_) => pRepository);
}
