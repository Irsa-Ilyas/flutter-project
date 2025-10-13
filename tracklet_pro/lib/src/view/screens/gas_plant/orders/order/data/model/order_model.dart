class OrderModel {
  final String traderName;
  final List<String> requestedItems;
  final int totalKg;
  final double totalBill;
  final String status;
  final String? specialInstruction;
  final String? location;
  final String? driverName;
  final DateTime? createdAt;

  OrderModel({
    required this.traderName,
    required this.requestedItems,
    required this.totalKg,
    required this.totalBill,
    required this.status,
    this.specialInstruction,
    this.location,
    this.driverName,
    this.createdAt,
  });
}
