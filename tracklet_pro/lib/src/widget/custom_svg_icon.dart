import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSvgIcon extends StatelessWidget {
  final String assetName;
  final double width;
  final double height;
  final Color? color;
  final IconData fallbackIcon;

  const CustomSvgIcon({
    super.key,
    required this.assetName,
    this.width = 24,
    this.height = 24,
    this.color,
    required this.fallbackIcon,
  });

  @override
  Widget build(BuildContext context) {
    try {
      return SvgPicture.asset(
        assetName,
        width: width,
        height: height,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
      );
    } catch (e) {
      // Fallback to Material icon if SVG fails to load
      return Icon(
        fallbackIcon,
        size: width,
        color: color,
      );
    }
  }


}