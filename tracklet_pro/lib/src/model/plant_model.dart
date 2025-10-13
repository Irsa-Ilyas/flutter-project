class PlantModel {
  final String? id;
  final String name;
  final String location;
  final String city;
  final String contactNumber;
  final String email;
  final int perKgPrice;
  final String imageUrl;
  final double totalCapacity;
  final double currentStock;
  final String ownerId;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PlantModel({
    this.id,
    required this.name,
    required this.location,
    required this.city,
    required this.contactNumber,
    required this.email,
    this.perKgPrice = 250,
    this.imageUrl = 'https://via.placeholder.com/400x200?text=Gas+Plant',
    this.totalCapacity = 0,
    this.currentStock = 0,
    required this.ownerId,
    this.status = 'active',
    this.createdAt,
    this.updatedAt,
  });

  // Create PlantModel from JSON
  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      location: json['location'] as String,
      city: json['city'] as String,
      contactNumber: json['contactNumber'] as String,
      email: json['email'] as String,
      perKgPrice: json['perKgPrice'] as int? ?? 250,
      imageUrl:
          json['imageUrl'] as String? ??
          'https://via.placeholder.com/400x200?text=Gas+Plant',
      totalCapacity: (json['totalCapacity'] as num?)?.toDouble() ?? 0,
      currentStock: (json['currentStock'] as num?)?.toDouble() ?? 0,
      ownerId: json['ownerId'] as String,
      status: json['status'] as String? ?? 'active',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  // Convert PlantModel to JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'name': name,
      'location': location,
      'city': city,
      'contactNumber': contactNumber,
      'email': email,
      'perKgPrice': perKgPrice,
      'imageUrl': imageUrl,
      'totalCapacity': totalCapacity,
      'currentStock': currentStock,
      'ownerId': ownerId,
      'status': status,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  // CopyWith method for easy updates
  PlantModel copyWith({
    String? id,
    String? name,
    String? location,
    String? city,
    String? contactNumber,
    String? email,
    int? perKgPrice,
    String? imageUrl,
    double? totalCapacity,
    double? currentStock,
    String? ownerId,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PlantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      city: city ?? this.city,
      contactNumber: contactNumber ?? this.contactNumber,
      email: email ?? this.email,
      perKgPrice: perKgPrice ?? this.perKgPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      totalCapacity: totalCapacity ?? this.totalCapacity,
      currentStock: currentStock ?? this.currentStock,
      ownerId: ownerId ?? this.ownerId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
