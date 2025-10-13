import 'package:flutter/material.dart';

class DashboardSummary {
  final String title;
  final String value;
  final String unit;
  final String iconPath;
  final Color color;
  final String description;

  DashboardSummary({
    required this.title,
    required this.value,
    required this.unit,
    required this.iconPath,
    required this.color,
    required this.description,
  });

  // Factory method to create from API data
  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      title: json['title'] as String,
      value: json['value'] as String,
      unit: json['unit'] as String,
      iconPath: json['iconPath'] as String,
      color: _colorFromHex(json['color'] as String),
      description: json['description'] as String,
    );
  }

  // Helper method to convert hex string to Color
  static Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  // Method to convert to API-friendly format
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'value': value,
      'unit': unit,
      'iconPath': iconPath,
      'color': '#${color.toARGB32().toRadixString(16).substring(2)}',
      'description': description,
    };
  }
}