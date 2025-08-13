import 'dart:convert';
import 'dart:io';

import 'package:barcollector/src/data/product_repository.dart';
import 'package:csv/csv.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  // 1. Validar o método da requisição
  if (context.request.method != HttpMethod.post) {
    return Response(
      statusCode: HttpStatus.methodNotAllowed,
      body: 'Método não permitido. Use POST.',
    );
  }

  // 2. Obter os dados do formulário (multipart/form-data)
  final formData = await context.request.formData();
  final file = formData.files['file'];

  // 3. Validar o arquivo enviado
  if (file == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Nenhum arquivo enviado. O arquivo deve estar no campo "file".'},
    );
  }

  //TODO: Trocar CSV para XML para melhor compatibilidade futuramente
  if (file.contentType.mimeType != 'text/csv') {
    return Response.json(
      statusCode: HttpStatus.unsupportedMediaType,
      body: {'error': 'Tipo de arquivo inválido. Apenas CSV é permitido.'},
    );
  }

  try {
    // 4. Processar o conteúdo do CSV
    final parsedProducts = await _processCSV(file);
    if (parsedProducts.isEmpty) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'error': 'O arquivo CSV está vazio ou não contém produtos válidos.'},
      );
    }

    // 5. Chamar o repositório para inserir/atualizar os produtos
    final repository = context.read<ProductRepository>();
    final success = await repository.bulkInsertProducts(parsedProducts);

    if (success) {
      return Response.json(
        body: {'message': '${parsedProducts.length} produtos processados com sucesso.'},
      );
    } else {
      return Response.json(
        statusCode: HttpStatus.internalServerError,
        body: {'error': 'Falha ao salvar os produtos no banco de dados.'},
      );
    }
  } catch (e) {
    // Em uma aplicação real, logar o erro `e`
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Ocorreu um erro inesperado ao processar o arquivo. $e'},
    );
  }
}

/// Processa um arquivo CSV e o converte em uma lista de objetos [Product].
Future<List<Product>> _processCSV(UploadedFile csvFile) async {
  // Lê o conteúdo do arquivo como uma string UTF-8
  final csvContent = await utf8.decodeStream(csvFile.openRead());

  // Converte a string CSV em uma lista de listas (linhas e colunas)
  final rows = const CsvToListConverter().convert(csvContent);

  final products = <Product>[];
  // Itera sobre as linhas. Se o seu CSV tiver um cabeçalho, use rows.skip(1)
  for (final row in rows) {
    try {
      // Lógica de validação e extração baseada no seu exemplo
      if (row.length > 31) {
        final productInternalCode = row[20].toString();
        if (productInternalCode.length == 6) {
          final barcode = row[21].toString();
          final name = row[22].toString();
          final price = double.parse(row[31].toString().replaceAll(',', '.'));

          // O ID é ignorado pelo `bulkInsertProducts`, então um valor fictício é usado.
          products.add(Product(id: '', barcode: barcode, name: name, price: price));
        }
      }
    } catch (e) {
      // Ignora linhas mal formatadas e continua o processamento.
      // Em uma aplicação real, você poderia logar a linha com erro.
      print('Erro ao processar a linha do CSV: $row. Erro: $e');
    }
  }
  return products;
}
