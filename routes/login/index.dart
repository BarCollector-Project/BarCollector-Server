import 'dart:io';

import 'package:barcollector/src/auth/users_repository.dart';
import 'package:barcollector/src/config/env_loader.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

Future<Response> onRequest(RequestContext context) async {
  // A rota de login deve aceitar apenas requisições POST.
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final usersRepository = context.read<UsersRepository>();

  final body = await context.request.json() as Map<String, dynamic>;

  final username = body['username'] as String?;
  final password = body['password'] as String?;

  if (username == null || password == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'username e password são obrigatórios.'},
    );
  }

  // 1. Valida as credenciais (VALORES BRUTOS PARA TESTE)
  final isValid = await usersRepository.isValidUser(username, password);

  if (!isValid) {
    return Response.json(
      statusCode: HttpStatus.unauthorized,
      body: {'error': 'Credenciais inválidas.'},
    );
  }

  // 2. Busca os detalhes do usuário para incluir no token.
  final user = await usersRepository.findByUsername(username);
  if (user == null) {
    // Impovável pois isValidUser faz isso para obter as informações do usuário no banco de dados.
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Não foi possível encontrar o usuário após a validação.'},
    );
  }

  // 3. Cria e assina o JWT.
  try {
    final env = await loadEnvFile();
    final jwtSecret = env['JWT_SECRET'];
    if (jwtSecret == null) throw Exception('JWT_SECRET não configurado.');

    final jwt = JWT(
      {
        'id': user.id,
        'username': user.username,
        'role': user.role.name,
        // 'iat' (issued at) é o momento em que o token foi criado.
        // O valor deve ser em segundos desde a epoch.
        'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      },
      subject: user.id,
    );
    // O tempo de expiração é definido no método sign(), não no construtor JWT.
    final token = jwt.sign(
      SecretKey(jwtSecret),
      expiresIn: const Duration(hours: 24),
    );

    // 4. Retorna o token para o cliente.
    return Response.json(body: {'token': token});
  } catch (e) {
    return Response.json(statusCode: HttpStatus.internalServerError, body: {'error': 'Erro ao gerar token: $e'});
  }
}
