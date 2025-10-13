class RequestedItem {
  final double weight;
  final int quantity;

  RequestedItem({
    required this.weight,
    required this.quantity,
  });

  // Create RequestedItem from JSON
  factory RequestedItem.fromJson(Map<String, dynamic> json) {
    return RequestedItem(
      weight: (json['weight'] as num).toDouble(),
      quantity: json['quantity'] as int,
    );
  }

  // Convert RequestedItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'quantity': quantity,
    };
  }
}