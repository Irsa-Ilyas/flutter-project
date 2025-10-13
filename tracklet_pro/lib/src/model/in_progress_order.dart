class InProgressOrder {
  final String traderName;
  final String status;
  final String time;
  final String date;
  final String driverName;
  final String specialInstructions;
  final List<OrderItem> requestedItems;
  final int totalKg;

  InProgressOrder({
    required this.traderName,
    required this.status,
    required this.time,
    required this.date,
    required this.driverName,
    required this.specialInstructions,
    required this.requestedItems,
    required this.totalKg,
  });
}

class OrderItem {
  final String description;
  final String weightAndQuantity;

  OrderItem({
    required this.description,
    required this.weightAndQuantity,
  });
}