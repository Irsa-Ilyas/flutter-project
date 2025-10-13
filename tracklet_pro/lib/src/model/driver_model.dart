
class DriverModel {
  final String id;
  final String name;
  final String status; // 'Available', 'On Delivery', 'Offline'
  final String description;
  final bool showAvatar;
  final double rating;
  final int deliveries;
  
  DriverModel({
    required this.id,
    required this.name,
    required this.status,
    required this.description,
    required this.showAvatar,
    required this.rating,
    required this.deliveries,
  });

  // Factory method to create from API data - yeh method API data se object create krta hai
  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      description: json['description'] as String,
      showAvatar: json['showAvatar'] as bool? ?? true,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      deliveries: json['deliveries'] as int? ?? 0,
    );
  }

  // Method to convert to API-friendly format - yeh method object ko API format mein convert krta hai
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'description': description,
      'showAvatar': showAvatar,
      'rating': rating,
      'deliveries': deliveries,
    };
  }

  // Copy with method for updating properties - yeh method properties update krne ke liye hai
  DriverModel copyWith({
    String? id,
    String? name,
    String? status,
    String? description,
    bool? showAvatar,
    double? rating,
    int? deliveries,
  }) {
    return DriverModel(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      description: description ?? this.description,
      showAvatar: showAvatar ?? this.showAvatar,
      rating: rating ?? this.rating,
      deliveries: deliveries ?? this.deliveries,
    );
  }
}