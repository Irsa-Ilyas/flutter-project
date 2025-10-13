class OrderModel {
  final String id;
  final String distributorName;
  final String plantName;
  final double totalKg;
  final double totalPrice;
  final String status; // 'Pending', 'Approved', 'Assigned', 'Delivered'
  final String? driverId;
  
  OrderModel({
    required this.id,
    required this.distributorName,
    required this.plantName,
    required this.totalKg,
    required this.totalPrice,
    required this.status,
    this.driverId,
  });

  // Factory method to create from API data - yeh method API data se object create krta hai
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      distributorName: json['distributorName'] as String,
      plantName: json['plantName'] as String,
      totalKg: (json['totalKg'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String,
      driverId: json['driverId'] as String?,
    );
  }

  // Method to convert to API-friendly format - yeh method object ko API format mein convert krta hai
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'distributorName': distributorName,
      'plantName': plantName,
      'totalKg': totalKg,
      'totalPrice': totalPrice,
      'status': status,
      'driverId': driverId,
    };
  }

  // Copy with method for updating properties - yeh method properties update krne ke liye hai
  OrderModel copyWith({
    String? id,
    String? distributorName,
    String? plantName,
    double? totalKg,
    double? totalPrice,
    String? status,
    String? driverId,
  }) {
    return OrderModel(
      id: id ?? this.id,
      distributorName: distributorName ?? this.distributorName,
      plantName: plantName ?? this.plantName,
      totalKg: totalKg ?? this.totalKg,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      driverId: driverId ?? this.driverId,
    );
  }
}