import 'package:dart_frog/dart_frog.dart';

import '../middleware/_auth.dart';
import '../middleware/_cors.dart';

/// Midleware reponsável para controlar todas as rotas
/// Tudo que for para uso de uma rota específica, um _middleware próprio deverá ser utilizado.
/// Isso torna o programa mais organizado.

Handler middleware(Handler handler) {
  // A ordem de execução é o inverso da ordem das chamadas .use().
  // Para que o `corsMiddleware` execute primeiro, ele deve ser o último na cadeia.
  return handler.use(authMiddleware()).use(corsMiddleware());
}
