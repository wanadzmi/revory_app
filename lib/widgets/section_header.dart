import 'package:flutter/material.dart';

/// SectionHeader heading with an optional action label.
class SectionHeader extends StatelessWidget {
  /// Creates a heading with an optional trailing action.
  const new(this.title, this.action, {super.key, this.onTap});

  /// Heading text displayed for the section.
  final String title;

  /// Trailing action label, or null when no action is displayed.
  final String? action;

  /// Invoked when the trailing action is tapped, if supplied.
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          letterSpacing: 1.1,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      const Spacer(),
      if (action != null)
        GestureDetector(
          onTap: onTap,
          child: Text(
            action!,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
    ],
  );
}
