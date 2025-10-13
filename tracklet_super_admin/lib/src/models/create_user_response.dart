class CreateUserResponse {
  final String id;
  final String name;
  final String email;
  final String password; // Plain text password (only returned once)
  final String role;
  final String? plantId;
  final String? plantName;
  final DateTime createdAt;

  CreateUserResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.plantId,
    this.plantName,
    required this.createdAt,
  });

  factory CreateUserResponse.fromJson(Map<String, dynamic> json) {
    return CreateUserResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      role: json['role'] as String,
      plantId: json['plantId'] as String?,
      plantName: json['plantName'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

