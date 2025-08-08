import 'dart:io';

import 'package:barcollector/src/config/env_loader.dart';
import 'package:dart_frog/dart_frog.dart';

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  final env = await loadEnvFile();

  // Tente primeiro obter o diretório na veriável de ambiente ou, prioritariamente, no arquivo .env.
  // Caso não exista, obtém o servido pelo caminho relativo a.
  // ALtere o caminho para o caminho correto do certificado.
  // Neste caso ele devera esta numa pasta "cert" no diretório ROOT do projeto.
  final chain = env['CERT'] ?? Platform.script.resolve('../cert/localhost.pem').toFilePath();
  final key = env['CERT_KEY'] ?? Platform.script.resolve('../cert/localhost-key.pem').toFilePath();

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
