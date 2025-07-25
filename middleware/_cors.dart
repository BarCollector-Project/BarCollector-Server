import 'package:dart_frog/dart_frog.dart';

Middleware corsMiddleware() {
  return (handler) {
    return (context) async {
      // Permite requisições CORS (pré-vôo OPTIONS)
      if (context.request.method == HttpMethod.options) {
        return Response(headers: _corsHeaders);
      }

      // Processa normalmente e adiciona os headers de CORS
      final response = await handler(context);
      return response.copyWith(
        headers: {
          ...response.headers,
          ..._corsHeaders,
        },
      );
    };
  };
}

const _corsHeaders = {
  'Access-Control-Allow-Origin': '*', // Em produção, troque por origem específica
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization',
};
