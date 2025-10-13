class DashboardStats {
  final int totalUsers;
  final int distributors;
  final int gasPlants;
  final int totalPlants;
  final int recentUsers;

  DashboardStats({
    required this.totalUsers,
    required this.distributors,
    required this.gasPlants,
    required this.totalPlants,
    required this.recentUsers,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalUsers: json['totalUsers'] as int? ?? 0,
      distributors: json['distributors'] as int? ?? 0,
      gasPlants: json['gasPlants'] as int? ?? 0,
      totalPlants: json['totalPlants'] as int? ?? 0,
      recentUsers: json['recentUsers'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalUsers': totalUsers,
      'distributors': distributors,
      'gasPlants': gasPlants,
      'totalPlants': totalPlants,
      'recentUsers': recentUsers,
    };
  }
}

