import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  //Retorna o status OK por padrão
  return Response(body: 'API_OK');
}
