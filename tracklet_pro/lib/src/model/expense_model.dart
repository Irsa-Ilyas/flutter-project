class ExpenseModel {
  final String? id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String description;
  final String paymentMethod;
  final String userId;
  final String plantId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ExpenseModel({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.description = '',
    this.paymentMethod = 'Cash',
    required this.userId,
    this.plantId = '',
    this.createdAt,
    this.updatedAt,
  });

  // Create ExpenseModel from JSON
  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['_id'] as String?,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String? ?? '',
      paymentMethod: json['paymentMethod'] as String? ?? 'Cash',
      userId: json['userId'] as String,
      plantId: json['plantId'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  // Convert ExpenseModel to JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'description': description,
      'paymentMethod': paymentMethod,
      'userId': userId,
      'plantId': plantId,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  // CopyWith method for easy updates
  ExpenseModel copyWith({
    String? id,
    String? title,
    double? amount,
    String? category,
    DateTime? date,
    String? description,
    String? paymentMethod,
    String? userId,
    String? plantId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      description: description ?? this.description,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      userId: userId ?? this.userId,
      plantId: plantId ?? this.plantId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper: Format amount as currency
  String get formattedAmount => 'Rs. ${amount.toStringAsFixed(0)}';

  // Helper: Format date
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
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}

// Expense Categories
class ExpenseCategories {
  static const String maintenance = 'Maintenance';
  static const String utilities = 'Utilities';
  static const String salaries = 'Salaries';
  static const String transport = 'Transport';
  static const String supplies = 'Supplies';
  static const String other = 'Other';

  static const List<String> all = [
    maintenance,
    utilities,
    salaries,
    transport,
    supplies,
    other,
  ];
}

// Payment Methods
class PaymentMethods {
  static const String cash = 'Cash';
  static const String bankTransfer = 'Bank Transfer';
  static const String creditCard = 'Credit Card';
  static const String cheque = 'Cheque';
  static const String other = 'Other';

  static const List<String> all = [
    cash,
    bankTransfer,
    creditCard,
    cheque,
    other,
  ];
}

