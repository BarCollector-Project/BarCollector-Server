import 'package:dart_frog/dart_frog.dart';

Middleware wasmContentTypeFixer() {
  return (handler) {
    return (context) async {
      final response = await handler(context);

      if (context.request.uri.path.endsWith('.wasm')) {
        return response.copyWith(
          headers: {
            ...response.headers,
            'Content-Type': 'application/wasm',
          },
        );
      }
      return response;
    };
  };
}
