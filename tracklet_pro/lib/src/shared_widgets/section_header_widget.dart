import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/shared_widgets/see_all_widget.dart';

class SectionHeaderWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const SectionHeaderWidget({required this.title, this.onSeeAll, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: theme.textTheme.headlineSmall),
        if (onSeeAll != null) SeeAllButton(onTap: onSeeAll!),
      ],
    );
  }
}