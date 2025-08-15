import 'register.dart';

class CollectRegister extends Register {
  CollectRegister({
    required super.userName,
    required super.id,
    required super.timestamp,
    required super.description,
  });

  @override
  CollectRegister fromJson(Map<String, dynamic> json) {
    assert(
      json.containsKey('userName') &&
          json.containsKey('id') &&
          json.containsKey('timestamp') &&
          json.containsKey('description'),
      '''
Json inválido para CollectRegister. O JSON nessário deve ser:
{
  "userName": "<USERNAME>",
  "id": "<REGISTER_ID>",      
  "timestamp": "<TIMESTAMP>",   // Em String ISO8601
  "description": "<DESCRIPTION>"
}
      ''',
    );
    return CollectRegister(
      userName: json['userName'] as String,
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      description: json['description'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'description': description,
    };
  }
}
