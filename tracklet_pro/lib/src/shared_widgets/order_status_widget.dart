/// OrderStatus - Yeh enum order ki status ko represent karta hai
/// 
/// Features:
/// - inProgress - Order progress me hai
/// - completed - Order complete ho chuki hai
enum OrderStatus { 
  inProgress, 
  completed 
}

/// OrderStatusExtension - Yeh extension OrderStatus enum ke liye helper functions provide karta hai
/// 
/// Features:
/// - name property - Status ka string representation
/// - fromString method - String se OrderStatus banane ke liye
extension OrderStatusExtension on OrderStatus {
  /// Status ka string representation return karta hai
  String get name {
    switch (this) {
      case OrderStatus.inProgress:
        return 'In Progress';
      case OrderStatus.completed:
        return 'Completed';
    }
  }

  /// String se OrderStatus banata hai
  static OrderStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'in progress':
        return OrderStatus.inProgress;
      case 'completed':
        return OrderStatus.completed;
      default:
        return OrderStatus.inProgress;
    }
  }
}