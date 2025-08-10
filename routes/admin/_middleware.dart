import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../middleware/_productRepository.dart';

Handler middleware(Handler handler) {
  return (context) async {
    //TODO: teste.... faça ajuste para produção.
    return handler.use(productRepository())(context);

    final payload = context.read<Map<String, dynamic>>();
    if (payload.containsKey('role') && payload['role'] == 'ADMIN') {
      return await handler(context);
    }
    return Response.json(
      statusCode: HttpStatus.unauthorized,
      body: {'error': 'Você não tem acesso suficiente para acessar esta rota.'},
    );
  };
}
