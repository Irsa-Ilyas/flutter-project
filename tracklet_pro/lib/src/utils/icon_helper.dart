import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/utils/app_svg_icons.dart';

/// Icon Helper for easy icon usage throughout the app
/// Automatically uses SVG when available, falls back to Material Icons
class IconHelper {
  /// Get icon widget with automatic SVG/Material selection
  static Widget getIcon(IconData icon, {double size = 24, Color? color}) {
    return IconMapper.buildIcon(icon: icon, size: size, color: color);
  }

  /// Navigation icons
  static Widget dashboard({double size = 24, Color? color}) {
    return SvgIcon(
      svgPath: AppSvgIcons.dashboard,
      fallbackIcon: Icons.dashboard,
      size: size,
      color: color,
    );
  }

  static Widget orders({double size = 24, Color? color}) {
    return SvgIcon(
      svgPath: AppSvgIcons.orders,
      fallbackIcon: Icons.list,
      size: size,
      color: color,
    );
  }

  static Widget profile({double size = 24, Color? color}) {
    return SvgIcon(
      svgPath: AppSvgIcons.profile,
      fallbackIcon: Icons.person,
      size: size,
      color: color,
    );
  }

  static Widget settings({double size = 24, Color? color}) {
    return SvgIcon(
      svgPath: AppSvgIcons.settings,
      fallbackIcon: Icons.settings,
      size: size,
      color: color,
    );
  }

  static Widget notifications({double size = 24, Color? color}) {
    return SvgIcon(
      svgPath: AppSvgIcons.notification,
      fallbackIcon: Icons.notifications,
      size: size,
      color: color,
    );
  }

  /// Action icons
  static Widget add({double size = 24, Color? color}) {
    return SvgIcon(
      svgPath: AppSvgIcons.add,
      fallbackIcon: Icons.add,
      size: size,
      color: color,
    );
  }

  static Widget search({double size = 24, Color? color}) {
    return SvgIcon(
      svgPath: AppSvgIcons.search,
      fallbackIcon: Icons.search,
      size: size,
      color: color,
    );
  }

  static Widget arrowBack({double size = 24, Color? color}) {
    return SvgIcon(
      svgPath: AppSvgIcons.arrowBack,
      fallbackIcon: Icons.arrow_back,
      size: size,
      color: color,
    );
  }

  /// Form icons
  static Widget email({double size = 24, Color? color}) {
    return SvgIcon(
      svgPath: AppSvgIcons.email,
      fallbackIcon: Icons.email,
      size: size,
      color: color,
    );
  }

  static Widget phone({double size = 24, Color? color}) {
    return SvgIcon(
      svgPath: AppSvgIcons.phone,
      fallbackIcon: Icons.phone,
      size: size,
      color: color,
    );
  }

  static Widget lock({double size = 24, Color? color}) {
    return SvgIcon(
      svgPath: AppSvgIcons.lock,
      fallbackIcon: Icons.lock,
      size: size,
      color: color,
    );
  }

  static Widget location({double size = 24, Color? color}) {
    return SvgIcon(
      svgPath: AppSvgIcons.location,
      fallbackIcon: Icons.location_on,
      size: size,
      color: color,
    );
  }

  static Widget calendar({double size = 24, Color? color}) {
    return SvgIcon(
      svgPath: AppSvgIcons.calendar,
      fallbackIcon: Icons.calendar_month,
      size: size,
      color: color,
    );
  }

  static Widget time({double size = 24, Color? color}) {
    return SvgIcon(
      svgPath: AppSvgIcons.time,
      fallbackIcon: Icons.access_time,
      size: size,
      color: color,
    );
  }

  /// Business icons
  static Widget inventory({double size = 24, Color? color}) {
    return SvgIcon(
      svgPath: AppSvgIcons.inventory,
      fallbackIcon: Icons.inventory,
      size: size,
      color: color,
    );
  }

  static Widget receipt({double size = 24, Color? color}) {
    return SvgIcon(
      svgPath: AppSvgIcons.receipt,
      fallbackIcon: Icons.receipt_long,
      size: size,
      color: color,
    );
  }

  static Widget logout({double size = 24, Color? color}) {
    return SvgIcon(
      svgPath: AppSvgIcons.logout,
      fallbackIcon: Icons.logout,
      size: size,
      color: color,
    );
  }
}
