import 'package:flutter/material.dart';

class TabConfig {
  final String value;
  final String label;
  final String iconPath;
  final Color color;
  final String headerTop;
  final String headerBottom;
  final VoidCallback onTap;

  TabConfig({
    required this.value,
    required this.label,
    required this.iconPath,
    required this.color,
    required this.headerTop,
    required this.headerBottom,
    required this.onTap,
  });
}