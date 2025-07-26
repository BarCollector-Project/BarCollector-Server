import 'package:barcollector/src/auth/users_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return handler.use(provider<UsersRepository>((_) => UsersRepository()));
}
