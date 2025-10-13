class TankModel {
  final String? id;
  final String name;
  final String location;
  final double totalCapacity; // in tons
  final double available; // in tons
  final double freezeGas; // in tons
  final String status;
  final String ownerId;
  final DateTime lastRecordedDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TankModel({
    this.id,
    required this.name,
    this.location = '',
    required this.totalCapacity,
    this.available = 0,
    this.freezeGas = 0,
    this.status = 'Active',
    required this.ownerId,
    DateTime? lastRecordedDate,
    this.createdAt,
    this.updatedAt,
  }) : lastRecordedDate = lastRecordedDate ?? DateTime.now();

  // Factory method to create from API data
  factory TankModel.fromJson(Map<String, dynamic> json) {
    return TankModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      location: json['location'] as String? ?? '',
      totalCapacity: (json['totalCapacity'] as num).toDouble(),
      available: (json['available'] as num?)?.toDouble() ?? 0,
      freezeGas: (json['freezeGas'] as num?)?.toDouble() ?? 0,
      status: json['status'] as String? ?? 'Active',
      ownerId: json['ownerId'] as String,
      lastRecordedDate: json['lastRecordedDate'] != null
          ? DateTime.parse(json['lastRecordedDate'] as String)
          : DateTime.now(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  // Method to convert to API-friendly format
  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'name': name,
      'location': location,
      'totalCapacity': totalCapacity,
      'available': available,
      'freezeGas': freezeGas,
      'status': status,
      'ownerId': ownerId,
      'lastRecordedDate': lastRecordedDate.toIso8601String(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  // Copy with method for updating properties
  TankModel copyWith({
    String? id,
    String? name,
    String? location,
    double? totalCapacity,
    double? available,
    double? freezeGas,
    String? status,
    String? ownerId,
    DateTime? lastRecordedDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TankModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      totalCapacity: totalCapacity ?? this.totalCapacity,
      available: available ?? this.available,
      freezeGas: freezeGas ?? this.freezeGas,
      status: status ?? this.status,
      ownerId: ownerId ?? this.ownerId,
      lastRecordedDate: lastRecordedDate ?? this.lastRecordedDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper: Get formatted date
  String get formattedDate {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${lastRecordedDate.day}-${months[lastRecordedDate.month - 1]}-${lastRecordedDate.year}';
  }

  // Helper: Check if tank is active
  bool get isActive => status == 'Active';

  // Helper: Get used capacity
  double get usedCapacity => available + freezeGas;

  // Helper: Get remaining capacity
  double get remainingCapacity => totalCapacity - usedCapacity;

  // Helper: Get capacity percentage
  double get capacityPercentage {
    if (totalCapacity == 0) return 0;
    return (usedCapacity / totalCapacity) * 100;
  }
}

// Stock Transaction Model
class StockTransaction {
  final String? id;
  final String tankId;
  final String tankName;
  final String type; // 'add', 'deduct', 'freeze', 'unfreeze'
  final double amount;
  final double rate;
  final String orderId;
  final String ownerId;
  final String notes;
  final DateTime date;

  StockTransaction({
    this.id,
    required this.tankId,
    required this.tankName,
    required this.type,
    required this.amount,
    this.rate = 0,
    this.orderId = '',
    required this.ownerId,
    this.notes = '',
    DateTime? date,
  }) : date = date ?? DateTime.now();

  factory StockTransaction.fromJson(Map<String, dynamic> json) {
    return StockTransaction(
      id: json['_id'] as String?,
      tankId: json['tankId'] as String,
      tankName: json['tankName'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      rate: (json['rate'] as num?)?.toDouble() ?? 0,
      orderId: json['orderId'] as String? ?? '',
      ownerId: json['ownerId'] as String,
      notes: json['notes'] as String? ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'tankId': tankId,
      'tankName': tankName,
      'type': type,
      'amount': amount,
      'rate': rate,
      'orderId': orderId,
      'ownerId': ownerId,
      'notes': notes,
      'date': date.toIso8601String(),
    };
  }
}

// Tank Status
class TankStatus {
  static const String active = 'Active';
  static const String inactive = 'Inactive';
  static const String maintenance = 'Maintenance';

  static const List<String> all = [active, inactive, maintenance];
}
