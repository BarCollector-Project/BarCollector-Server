import 'dart:convert';
import 'dart:io';

import 'package:barcollector/src/data/product_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final productRepository = context.read<ProductRepository>();

  switch (context.request.method) {
    case HttpMethod.get:
      return _handleGet(productRepository, id);
    case HttpMethod.put:
      return _handlePut(context, productRepository, id);
    case HttpMethod.delete:
      return _handleDelete(productRepository, id);
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _handleGet(ProductRepository repository, String id) async {
  final product = await repository.getProductById(id);

  if (product == null) {
    return Response(statusCode: HttpStatus.notFound, body: 'Produto não encontrado.');
  }

  return Response.json(body: product.toJson());
}

Future<Response> _handlePut(RequestContext context, ProductRepository repository, String id) async {
  try {
    final body = await context.request.body();
    final data = jsonDecode(body) as Map<String, dynamic>;

    final name = data['name'] as String?;
    final barcode = data['barcode'] as String?;
    final price = (data['price'] as num?)?.toDouble();

    if (name == null || barcode == null || price == null) {
      return Response(
        statusCode: HttpStatus.badRequest,
        body: 'Campos obrigatórios: name, barcode, price',
      );
    }

    final product = await repository.updateProduct(
      id: id,
      name: name,
      barcode: barcode,
      price: price,
    );

    if (product == null) {
      return Response(statusCode: HttpStatus.notFound, body: 'Produto não encontrado.');
    }

    return Response.json(body: product.toJson());
  } catch (e) {
    return Response(
      statusCode: HttpStatus.badRequest,
      body: 'Erro ao atualizar produto: $e',
    );
  }
}

Future<Response> _handleDelete(ProductRepository repository, String id) async {
  final deleted = await repository.deleteProduct(id);

  if (!deleted) {
    return Response(statusCode: HttpStatus.notFound, body: 'Produto não encontrado.');
  }

  return Response(statusCode: HttpStatus.noContent);
}
