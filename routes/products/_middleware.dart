import 'package:dart_frog/dart_frog.dart';

import '../../middleware/_productRepository.dart';

Handler middleware(Handler handler) {
  return handler.use(productRepository());
}
