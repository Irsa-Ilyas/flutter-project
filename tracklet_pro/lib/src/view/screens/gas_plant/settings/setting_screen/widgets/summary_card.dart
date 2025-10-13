import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final bool dark;
  final Widget? trailing;
  const SummaryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    this.dark = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bg = dark ? scheme.primary : scheme.surface;
    final fg = dark ? scheme.onPrimary : scheme.onSurface;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: dark ? null : Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.titleMedium?.copyWith(color: fg, fontWeight: FontWeight.w600) ?? TextStyle(color: fg, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: textTheme.bodySmall?.copyWith(color: fg.withValues(alpha: 0.7)) ?? TextStyle(color: fg.withValues(alpha: 0.7), fontSize: 12)),
                ],
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 16),
          Text(value, style: textTheme.displaySmall?.copyWith(color: fg, fontWeight: FontWeight.w800, fontSize: 22) ?? TextStyle(color: fg, fontWeight: FontWeight.w800, fontSize: 22)),
        ],
      ),
    );
  }
}
