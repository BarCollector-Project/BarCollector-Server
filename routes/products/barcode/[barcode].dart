import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:barcollector/src/data/product_repository.dart';

Future<Response> onRequest(RequestContext context, String barcode) async {
  final productRepository = context.read<ProductRepository>();
  
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
  
  final product = await productRepository.getProductByBarcode(barcode);
  
  if (product == null) {
    return Response(
      statusCode: HttpStatus.notFound, 
      body: 'Produto com código de barras $barcode não encontrado.',
    );
  }
  
  return Response.json(body: product.toJson());
}
