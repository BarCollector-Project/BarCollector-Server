import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handle) {
  return (context) async {
    final payload = context.read<Map<String, dynamic>>();
    if (payload.containsKey('role') && payload['role'] == 'ADMIN') {
      return await handle(context);
    }
    return Response.json(
      statusCode: HttpStatus.unauthorized,
      body: {'error': 'Você não tem acesso suficiente para acessar esta rota.'},
    );
  };
}
