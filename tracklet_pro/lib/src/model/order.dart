import 'requested_item.dart';

class Order {
  final String? id; // MongoDB _id
  final String traderName;
  final String profileImageUrl;
  final DateTime dateTime;
  final String instructions;
  final List<RequestedItem> items;
  final double totalKg;
  final String? driverName;
  final String? status;
  final String specialInstructions;
  final String mentioncylinders;

  Order({
    this.id,
    required this.traderName,
    required this.profileImageUrl,
    required this.dateTime,
    required this.instructions,
    required this.items,
    required this.totalKg,
    this.driverName,
    this.status,
    required this.specialInstructions,
    required this.mentioncylinders,
  });

  // Create Order from JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'] as String?,
      traderName: json['traderName'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      instructions: json['instructions'] as String,
      items: (json['items'] as List)
          .map((item) => RequestedItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalKg: (json['totalKg'] as num).toDouble(),
      driverName: json['driverName'] as String?,
      status: json['status'] as String?,
      specialInstructions: json['specialInstructions'] as String,
      mentioncylinders: json['mentioncylinders'] as String,
    );
  }

  // Convert Order to JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'traderName': traderName,
      'profileImageUrl': profileImageUrl,
      'dateTime': dateTime.toIso8601String(),
      'instructions': instructions,
      'items': items.map((item) => item.toJson()).toList(),
      'totalKg': totalKg,
      'driverName': driverName,
      'status': status,
      'specialInstructions': specialInstructions,
      'mentioncylinders': mentioncylinders,
    };
  }
}
