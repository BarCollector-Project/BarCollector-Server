abstract class Register {
  final String id;
  final DateTime timestamp;
  final String userName;
  final String description;

  Register({
    required this.id,
    required this.userName,
    required this.timestamp,
    required this.description,
  });

  Map<String, dynamic> toJson();

  Register fromJson(Map<String, dynamic> json);
}
