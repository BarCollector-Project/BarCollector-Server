import 'package:barcollector_sdk/types/register/register_type.dart';
import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  //TODO: Implementar o processamento de dados de registros recebidos

  final requestMethod = context.request.method;
  assert(
    requestMethod == HttpMethod.get || requestMethod == HttpMethod.post,
    'Método "${requestMethod.value.toUpperCase()}" não suportado',
  );

  final params = context.request.uri.queryParameters;
  final type = params['type'];
  switch (type) {
    case RegisterType.collect:
      break;
  }
  if (requestMethod == HttpMethod.get) {
  } else if (requestMethod == HttpMethod.post) {}
  return Response(body: 'Método "${requestMethod.value.toUpperCase()}" não suportado');
}
