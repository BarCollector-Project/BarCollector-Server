import 'dart:convert';
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:barcollector/src/data/product_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  final productRepository = context.read<ProductRepository>();
  
  switch (context.request.method) {
    case HttpMethod.get:
      return _handleGet(productRepository);
    case HttpMethod.post:
      return _handlePost(context, productRepository);
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _handleGet(ProductRepository repository) async {
  final products = await repository.getAllProducts();
  return Response.json(body: products.map((p) => p.toJson()).toList());
}

Future<Response> _handlePost(RequestContext context, ProductRepository repository) async {
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
    
    final product = await repository.createProduct(
      name: name,
      barcode: barcode,
      price: price,
    );
    
    return Response.json(
      statusCode: HttpStatus.created,
      body: product.toJson(),
    );
  } catch (e) {
    return Response(
      statusCode: HttpStatus.badRequest,
      body: 'Erro ao criar produto: $e',
    );
  }
}
