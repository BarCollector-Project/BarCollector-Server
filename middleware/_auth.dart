import 'package:barcollector/src/config/env_loader.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

Middleware authMiddleware() {
  return (handler) {
    return (context) async {
      if (context.request.method == HttpMethod.options) {
        return handler(context);
      }

      final path = context.request.uri.path;
      final isPublic = ['/login', '/api/health'].contains(path);

      if (isPublic) return handler(context);

      final authHeader = context.request.headers['Authorization'];

      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response(statusCode: 401, body: 'Authorization header ausente ou mal formatado');
      }

      // Extrai o token, removendo o prefixo "Bearer "
      final token = authHeader.substring(7);

      try {
        final jwt = JWT.verify(token, SecretKey((await loadEnvFile())['JWT_SECRET']!));

        // Disponibiliza o payload do JWT para o handler da rota, se necessário.
        // Isso é mais útil do que apenas o ID.
        final payload = jwt.payload as Map<String, dynamic>;
        return handler(context.provide<Map<String, dynamic>>(() => payload));
      } catch (_) {
        return Response(statusCode: 401, body: 'Token inválido');
      }
    };
  };
}
