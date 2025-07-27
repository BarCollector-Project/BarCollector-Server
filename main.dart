import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) {
  print(Platform.script);
  final chain = Platform.script.resolve('../cert/localhost.pem').toFilePath();
  final key = Platform.script.resolve('../cert/localhost-key.pem').toFilePath();

  final securityContext = SecurityContext()
    ..useCertificateChain(chain)
    ..usePrivateKey(key);
  return serve(
    handler,
    InternetAddress('0.0.0.0', type: InternetAddressType.IPv4),
    8082,
    securityContext: securityContext,
  );
}
