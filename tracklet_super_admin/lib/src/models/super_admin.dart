class SuperAdmin {
  final String id;
  final String name;
  final String email;
  final String role;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final bool isActive;

  SuperAdmin({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
    this.lastLogin,
    this.isActive = true,
  });

  factory SuperAdmin.fromJson(Map<String, dynamic> json) {
    return SuperAdmin(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String? ?? 'super_admin',
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      if (lastLogin != null) 'lastLogin': lastLogin!.toIso8601String(),
      'isActive': isActive,
    };
  }
}

