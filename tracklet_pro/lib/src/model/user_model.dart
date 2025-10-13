class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // 'gas_plant' or 'distributor'
  final String token;
  final String bio;
  final String profileImageUrl;
  final String phoneNumber;
  final String address;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.token,
    this.bio = '',
    this.profileImageUrl = 'www.google.com',
    this.phoneNumber = '',
    this.address = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      token: json['token'] as String,
      bio: json['bio'] as String? ?? '',
      profileImageUrl: json['profileImageUrl'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      address: json['address'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'token': token,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }

  // CopyWith method for easy updates
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? token,
    String? bio,
    String? profileImageUrl,
    String? phoneNumber,
    String? address,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      token: token ?? this.token,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
    );
  }

  bool get isGasPlant => role == 'gas_plant';
  bool get isDistributor => role == 'distributor';

  // Get initials from name
  String get initials {
    if (name.isEmpty) return '';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }
}
