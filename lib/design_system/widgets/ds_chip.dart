import 'package:flutter/material.dart';

enum DsChipVariant { category, status }

class DsChip extends StatelessWidget {
  final DsChipVariant variant;
  final bool selected;
  final String? statusKey;
  final Widget? icon;
  final String? emoji;
  final VoidCallback? onTap;
  final Widget child;

  const DsChip({
    super.key,
    this.variant = DsChipVariant.category,
    this.selected = false,
    this.statusKey,
    this.icon,
    this.emoji,
    this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (variant == DsChipVariant.category) {
      final bg = selected ? cs.primary : cs.surface;
      final fg = selected ? cs.onPrimary : cs.onSurfaceVariant;
      final borderColor =
          selected ? cs.primary : cs.outlineVariant.withOpacity(0.8);

      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                IconTheme(
                  data: IconThemeData(
                    size: 18,
                    color: fg,
                  ),
                  child: icon!,
                ),
                const SizedBox(width: 6),
              ],
              DefaultTextStyle(
                style: TextStyle(
                  color: fg,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
                child: child,
              ),
            ],
          ),
        ),
      );
    }

    final map = _statusColors(context, statusKey);
    final bg = map.background;
    final fg = map.foreground;
    final border = map.border;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (emoji != null && emoji!.isNotEmpty) ...[
            Text(
              emoji!,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(width: 6),
          ],
          if (icon != null) ...[
            IconTheme(
              data: IconThemeData(
                size: 16,
                color: fg,
              ),
              child: icon!,
            ),
            const SizedBox(width: 4),
          ],
          DefaultTextStyle(
            style: TextStyle(
              color: fg,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  _StatusStyle _statusColors(BuildContext context, String? key) {
    final cs = Theme.of(context).colorScheme;

    switch (key) {
      case 'pending':
        return _StatusStyle(
          background: const Color(0xFFFFF4E5),
          foreground: const Color(0xFF9A5B00),
          border: const Color(0xFFFFE0B2),
        );
      case 'preparing':
        return _StatusStyle(
          background: const Color(0xFFE3F2FD),
          foreground: const Color(0xFF0D47A1),
          border: const Color(0xFFBBDEFB),
        );
      case 'accepted':
        return _StatusStyle(
          background: const Color(0xFFE8F5E9),
          foreground: const Color(0xFF1B5E20),
          border: const Color(0xFFC8E6C9),
        );
      case 'out-for-delivery':
        return _StatusStyle(
          background: const Color(0xFFF3E5F5),
          foreground: const Color(0xFF4A148C),
          border: const Color(0xFFE1BEE7),
        );
      case 'completed':
        return _StatusStyle(
          background: const Color(0xFFE8F5E9),
          foreground: const Color(0xFF1B5E20),
          border: const Color(0xFFC8E6C9),
        );
      case 'canceled':
        return _StatusStyle(
          background: const Color(0xFFFFEBEE),
          foreground: const Color(0xFFB71C1C),
          border: const Color(0xFFFFCDD2),
        );
      default:
        return _StatusStyle(
          background: cs.surfaceVariant,
          foreground: cs.onSurface,
          border: cs.outlineVariant,
        );
    }
  }
}

class _StatusStyle {
  final Color background;
  final Color foreground;
  final Color border;

  _StatusStyle({
    required this.background,
    required this.foreground,
    required this.border,
  });
}
