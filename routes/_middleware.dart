import 'package:dart_frog/dart_frog.dart';
import '../middleware/_cors.dart' as cors;

Handler middleware(Handler handler) {
  return cors.middleware(handler);
}
