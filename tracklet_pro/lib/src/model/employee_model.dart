class EmployeeModel {
  final String? id;
  final String name;
  final String email;
  final String phoneNumber;
  final String role;
  final String licenseNumber;
  final String address;
  final double salary;
  final DateTime dateOfJoining;
  final String status;
  final String employerId;
  final String vehicleNumber;
  final String profileImageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  EmployeeModel({
    this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.role = 'Worker',
    this.licenseNumber = '',
    this.address = '',
    this.salary = 0,
    DateTime? dateOfJoining,
    this.status = 'Active',
    required this.employerId,
    this.vehicleNumber = '',
    this.profileImageUrl = '',
    this.createdAt,
    this.updatedAt,
  }) : dateOfJoining = dateOfJoining ?? DateTime.now();

  // Create EmployeeModel from JSON
  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      role: json['role'] as String? ?? 'Worker',
      licenseNumber: json['licenseNumber'] as String? ?? '',
      address: json['address'] as String? ?? '',
      salary: (json['salary'] as num?)?.toDouble() ?? 0,
      dateOfJoining: json['dateOfJoining'] != null
          ? DateTime.parse(json['dateOfJoining'] as String)
          : DateTime.now(),
      status: json['status'] as String? ?? 'Active',
      employerId: json['employerId'] as String,
      vehicleNumber: json['vehicleNumber'] as String? ?? '',
      profileImageUrl: json['profileImageUrl'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  // Convert EmployeeModel to JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'licenseNumber': licenseNumber,
      'address': address,
      'salary': salary,
      'dateOfJoining': dateOfJoining.toIso8601String(),
      'status': status,
      'employerId': employerId,
      'vehicleNumber': vehicleNumber,
      'profileImageUrl': profileImageUrl,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  // CopyWith method
  EmployeeModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? role,
    String? licenseNumber,
    String? address,
    double? salary,
    DateTime? dateOfJoining,
    String? status,
    String? employerId,
    String? vehicleNumber,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      address: address ?? this.address,
      salary: salary ?? this.salary,
      dateOfJoining: dateOfJoining ?? this.dateOfJoining,
      status: status ?? this.status,
      employerId: employerId ?? this.employerId,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper: Get initials
  String get initials {
    if (name.isEmpty) return '';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  // Helper: Is driver
  bool get isDriver => role == 'Driver';

  // Helper: Is active
  bool get isActive => status == 'Active';

  // Helper: Formatted salary
  String get formattedSalary => 'Rs. ${salary.toStringAsFixed(0)}';
}

// Employee Roles
class EmployeeRoles {
  static const String driver = 'Driver';
  static const String manager = 'Manager';
  static const String technician = 'Technician';
  static const String supervisor = 'Supervisor';
  static const String worker = 'Worker';
  static const String other = 'Other';

  static const List<String> all = [
    driver,
    manager,
    technician,
    supervisor,
    worker,
    other,
  ];
}

// Employee Status
class EmployeeStatus {
  static const String active = 'Active';
  static const String inactive = 'Inactive';
  static const String onLeave = 'On Leave';

  static const List<String> all = [active, inactive, onLeave];
}
