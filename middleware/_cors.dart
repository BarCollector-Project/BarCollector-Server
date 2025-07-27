import 'package:dart_frog/dart_frog.dart';

// Cabeçalhos CORS que serão aplicados a todas as respostas.
const _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization',
};

/// Middleware para lidar com Cross-Origin Resource Sharing (CORS).
Middleware corsMiddleware() {
  return (handler) {
    return (context) async {
      // Lida com a requisição preflight (OPTIONS) enviada pelos navegadores.
      if (context.request.method == HttpMethod.options) {
        // Retorna imediatamente uma resposta vazia com os cabeçalhos CORS.
        print('Método OPTIONS enviado');
        return Response(statusCode: 204, headers: _corsHeaders);
      }

      // Para outras requisições, executa o handler normal...
      final response = await handler(context);

      // ...e então adiciona os cabeçalhos CORS à resposta antes de enviá-la.
      return Response(
        statusCode: response.statusCode,
        body: await response.body(),
        headers: {...response.headers, ..._corsHeaders},
      );
    };
  };
}
