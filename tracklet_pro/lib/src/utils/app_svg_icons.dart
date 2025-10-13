import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Centralized SVG Icon System
/// Maps icon names to SVG paths with Material Icon fallbacks
class AppSvgIcons {
  // Base SVG path
  static const String _basePath = 'lib/src/assets/svg';

  // Navigation Icons
  static const String dashboard = '$_basePath/dashboard.svg';
  static const String orders = '$_basePath/orders.svg';
  static const String profile = '$_basePath/profile.svg';
  static const String settings = '$_basePath/settings.svg';
  static const String notification = '$_basePath/notification.svg';

  // Action Icons
  static const String add = '$_basePath/add.svg';
  static const String search = '$_basePath/search.svg';
  static const String clear = '$_basePath/clear.svg';
  static const String download = '$_basePath/download.svg';
  static const String personAdd = '$_basePath/person_add.svg';
  static const String arrowBack = '$_basePath/arrow_back.svg';
  static const String arrowDown = '$_basePath/arrow_down.svg';
  static const String chevronRight = '$_basePath/chevron_right.svg';

  // Form/Input Icons
  static const String email = '$_basePath/email.svg';
  static const String phone = '$_basePath/phone.svg';
  static const String lock = '$_basePath/lock.svg';
  static const String location = '$_basePath/location.svg';
  static const String calendar = '$_basePath/calendar.svg';
  static const String time = '$_basePath/time.svg';
  static const String attachMoney = '$_basePath/attach_money.svg';

  // Status Icons
  static const String check = '$_basePath/check.svg';
  static const String info = '$_basePath/info.svg';

  // Business Icons
  static const String inventory = '$_basePath/inventory.svg';
  static const String receipt = '$_basePath/receipt.svg';
  static const String logout = '$_basePath/logout.svg';
  static const String chat = '$_basePath/chat.svg';

  /// Helper widget to render SVG with fallback
  static Widget icon({
    required String svgPath,
    required IconData fallbackIcon,
    double size = 24,
    Color? color,
  }) {
    return SvgIcon(
      svgPath: svgPath,
      fallbackIcon: fallbackIcon,
      size: size,
      color: color,
    );
  }
}

/// Reusable SVG Icon Widget with Material Icon fallback
class SvgIcon extends StatelessWidget {
  final String svgPath;
  final IconData fallbackIcon;
  final double size;
  final Color? color;

  const SvgIcon({
    super.key,
    required this.svgPath,
    required this.fallbackIcon,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      svgPath,
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      // Fallback to Material Icon if SVG fails
      placeholderBuilder: (BuildContext context) =>
          Icon(fallbackIcon, size: size, color: color),
    );
  }
}

/// Icon mapping for easy migration from Material Icons to SVG
class IconMapper {
  static final Map<IconData, String> _iconMap = {
    Icons.dashboard: AppSvgIcons.dashboard,
    Icons.list: AppSvgIcons.orders,
    Icons.receipt_long: AppSvgIcons.receipt,
    Icons.person: AppSvgIcons.profile,
    Icons.settings: AppSvgIcons.settings,
    Icons.notifications: AppSvgIcons.notification,
    Icons.add: AppSvgIcons.add,
    Icons.search: AppSvgIcons.search,
    Icons.clear: AppSvgIcons.clear,
    Icons.download: AppSvgIcons.download,
    Icons.person_add_alt_1: AppSvgIcons.personAdd,
    Icons.arrow_back: AppSvgIcons.arrowBack,
    Icons.arrow_drop_down: AppSvgIcons.arrowDown,
    Icons.chevron_right: AppSvgIcons.chevronRight,
    Icons.email: AppSvgIcons.email,
    Icons.phone: AppSvgIcons.phone,
    Icons.lock_outline: AppSvgIcons.lock,
    Icons.lock: AppSvgIcons.lock,
    Icons.location_on: AppSvgIcons.location,
    Icons.calendar_month: AppSvgIcons.calendar,
    Icons.access_time: AppSvgIcons.time,
    Icons.attach_money: AppSvgIcons.attachMoney,
    Icons.check_circle: AppSvgIcons.check,
    Icons.check: AppSvgIcons.check,
    Icons.info: AppSvgIcons.info,
    Icons.info_outline: AppSvgIcons.info,
    Icons.inventory: AppSvgIcons.inventory,
    Icons.logout: AppSvgIcons.logout,
    Icons.chat: AppSvgIcons.chat,
  };

  /// Get SVG path for a Material Icon, returns null if no mapping exists
  static String? getSvgPath(IconData icon) {
    return _iconMap[icon];
  }

  /// Check if icon has SVG equivalent
  static bool hasSvgEquivalent(IconData icon) {
    return _iconMap.containsKey(icon);
  }

  /// Build icon widget (SVG if available, Material Icon otherwise)
  static Widget buildIcon({
    required IconData icon,
    double size = 24,
    Color? color,
  }) {
    final svgPath = getSvgPath(icon);

    if (svgPath != null) {
      return SvgIcon(
        svgPath: svgPath,
        fallbackIcon: icon,
        size: size,
        color: color,
      );
    }

    // Use Material Icon as fallback
    return Icon(icon, size: size, color: color);
  }
}
