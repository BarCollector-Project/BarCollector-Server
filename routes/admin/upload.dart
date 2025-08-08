import 'dart:io';

import 'package:barcollector/src/data/product_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final fromData = await context.request.formData();
  final file = fromData.files['file'];
  if (file == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }
  if (file.contentType.mimeType != 'text/csv') {
    return Response(statusCode: HttpStatus.badRequest);
  }

  try {
    final map = await _processCSV(file);
    if (map == null || map.isEmpty) return Response(statusCode: HttpStatus.badRequest);
    final repository = context.read<ProductRepository>();
    await repository.bulkInsertProductsFromMap(map);
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }

  // Estado "OK" por padrão
  return Response();
}

Future<List<Map<String, dynamic>>?> _processCSV(UploadedFile file) async {}
