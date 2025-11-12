import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
    required this.color,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: active
              ? color.withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.03),
          border: Border.all(
            color: active
                ? color.withValues(alpha: 0.56)
                : Colors.white.withValues(alpha: 0.06),
          ),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.28),
                    blurRadius: 18,
                    offset: const Offset(0, 12),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              active
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 16,
              color: active ? color : Colors.white60,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
