import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/// Wraps a list item in edit/delete actions with delete confirmation.
class SlideActions extends StatelessWidget {
  /// Creates swipe actions for a uniquely identified list item.
  const new({
    required this.itemKey,
    required this.onDeleted,
    required this.child,
    required this.itemLabel,
    super.key,
    this.onEdit,
    this.canDelete = true,
  });

  /// Stable key used by the slidable list item.
  final Key itemKey;

  /// Invoked after the user confirms deletion.
  final VoidCallback onDeleted;

  /// Listing content displayed in front of the swipe actions.
  final Widget child;

  /// Human-readable item name used in the deletion confirmation.
  final String itemLabel;

  /// Optional edit action displayed before the delete action.
  final VoidCallback? onEdit;

  /// Whether the delete action is available for this item.
  final bool canDelete;
  @override
  Widget build(BuildContext context) => Slidable(
    key: itemKey,
    endActionPane: ActionPane(
      motion: const DrawerMotion(),
      children: [
        if (onEdit != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: _SlideButton(
                icon: Icons.edit_outlined,
                color: Theme.of(context).colorScheme.primary,
                onPressed: onEdit!,
              ),
            ),
          ),
        if (canDelete)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: _SlideButton(
                icon: Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
                onPressed: () async {
                  if (await _confirmDelete(context)) onDeleted();
                },
              ),
            ),
          ),
      ],
    ),
    child: child,
  );
  Future<bool> _confirmDelete(BuildContext context) async =>
      await showDialog<bool>(
        context: context,
        builder: (dialog) => AlertDialog(
          title: const Text('Delete item?'),
          content: Text('Delete $itemLabel? This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialog, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialog, true),
              child: const Text('Delete'),
            ),
          ],
        ),
      ) ??
      false;
}

class _SlideButton extends StatelessWidget {
  const new({required this.icon, required this.color, required this.onPressed});
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => SizedBox.expand(
    child: FilledButton(
      onPressed: () async {
        onPressed();
        await Slidable.of(context)?.close();
      },
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      child: Icon(icon),
    ),
  );
}
