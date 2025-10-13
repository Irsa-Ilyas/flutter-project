class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? plantId;
  final String? plantName;
  final DateTime createdAt;
  final String profileImageUrl;
  final String? phoneNumber;
  final String? address;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.plantId,
    this.plantName,
    required this.createdAt,
    required this.profileImageUrl,
    this.phoneNumber,
    this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      plantId: json['plantId'] as String?,
      plantName: json['plantName'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      profileImageUrl: json['profileImageUrl'] as String? ??
          'https://ui-avatars.com/api/?name=${json['name']}&size=200',
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      if (plantId != null) 'plantId': plantId,
      if (plantName != null) 'plantName': plantName,
      'createdAt': createdAt.toIso8601String(),
      'profileImageUrl': profileImageUrl,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (address != null) 'address': address,
    };
  }

  // Helper method to get role display name
  String get roleDisplayName {
    switch (role) {
      case 'gas_plant':
        return 'Gas Plant';
      case 'distributor':
        return 'Distributor';
      default:
        return role;
    }
  }
}

