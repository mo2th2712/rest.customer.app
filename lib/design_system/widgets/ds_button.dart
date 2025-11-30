import 'package:flutter/material.dart';

enum DsButtonVariant { primary, secondary, ghost, icon }
enum DsButtonSize { sm, md, lg }

class DsButton extends StatelessWidget {
  final DsButtonVariant variant;
  final DsButtonSize size;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Widget? child;
  final bool loading;
  final bool expand;

  const DsButton({
    super.key,
    required this.variant,
    required this.size,
    required this.onPressed,
    this.icon,
    this.child,
    this.loading = false,
    this.expand = false,
  });

  factory DsButton.primary({
    Key? key,
    DsButtonSize size = DsButtonSize.lg,
    required VoidCallback? onPressed,
    Widget? icon,
    required Widget child,
    bool loading = false,
    bool expand = false,
  }) {
    return DsButton(
      key: key,
      variant: DsButtonVariant.primary,
      size: size,
      onPressed: onPressed,
      icon: icon,
      child: child,
      loading: loading,
      expand: expand,
    );
  }

  factory DsButton.secondary({
    Key? key,
    DsButtonSize size = DsButtonSize.lg,
    required VoidCallback? onPressed,
    Widget? icon,
    required Widget child,
    bool loading = false,
    bool expand = false,
  }) {
    return DsButton(
      key: key,
      variant: DsButtonVariant.secondary,
      size: size,
      onPressed: onPressed,
      icon: icon,
      child: child,
      loading: loading,
      expand: expand,
    );
  }

  factory DsButton.ghost({
    Key? key,
    DsButtonSize size = DsButtonSize.md,
    required VoidCallback? onPressed,
    Widget? icon,
    required Widget child,
    bool loading = false,
    bool expand = false,
  }) {
    return DsButton(
      key: key,
      variant: DsButtonVariant.ghost,
      size: size,
      onPressed: onPressed,
      icon: icon,
      child: child,
      loading: loading,
      expand: expand,
    );
  }

  factory DsButton.icon({
    Key? key,
    DsButtonSize size = DsButtonSize.md,
    required VoidCallback? onPressed,
    required Widget icon,
    bool loading = false,
  }) {
    return DsButton(
      key: key,
      variant: DsButtonVariant.icon,
      size: size,
      onPressed: onPressed,
      icon: icon,
      child: null,
      loading: loading,
      expand: false,
    );
  }

  double _height() {
    switch (size) {
      case DsButtonSize.sm:
        return 40;
      case DsButtonSize.md:
        return 48;
      case DsButtonSize.lg:
        return 56;
    }
  }

  EdgeInsetsGeometry _padding() {
    switch (size) {
      case DsButtonSize.sm:
        return const EdgeInsets.symmetric(horizontal: 14);
      case DsButtonSize.md:
        return const EdgeInsets.symmetric(horizontal: 16);
      case DsButtonSize.lg:
        return const EdgeInsets.symmetric(horizontal: 18);
    }
  }

  Widget _content(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (variant == DsButtonVariant.icon) {
      return SizedBox(
        height: _height(),
        width: _height(),
        child: Center(
          child: loading
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(cs.onSurface),
                  ),
                )
              : IconTheme(
                  data: IconThemeData(
                    size: 20,
                    color: cs.onSurface,
                  ),
                  child: icon ?? const SizedBox.shrink(),
                ),
        ),
      );
    }

    final base = DefaultTextStyle.merge(
      style: const TextStyle(fontWeight: FontWeight.w900),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: child ?? const SizedBox.shrink()),
          if (icon != null) ...[
            const SizedBox(width: 10),
            IconTheme(
              data: IconThemeData(
                size: 20,
                color: variant == DsButtonVariant.primary
                    ? cs.onPrimary
                    : cs.onSurface,
              ),
              child: icon!,
            ),
          ],
        ],
      ),
    );

    if (!loading) return base;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              variant == DsButtonVariant.primary ? cs.onPrimary : cs.onSurface,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(child: base),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final disabled = onPressed == null || loading;
    final h = _height();
    final pad = _padding();
    final onTap = disabled ? null : onPressed;

    if (variant == DsButtonVariant.primary) {
      final btn = FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          minimumSize: Size(0, h),
          padding: pad,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
        child: _content(context),
      );
      return expand ? SizedBox(width: double.infinity, child: btn) : btn;
    }

    if (variant == DsButtonVariant.secondary) {
      final btn = OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          minimumSize: Size(0, h),
          padding: pad,
          side: BorderSide(color: cs.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
        child: _content(context),
      );
      return expand ? SizedBox(width: double.infinity, child: btn) : btn;
    }

    if (variant == DsButtonVariant.ghost) {
      final btn = TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          minimumSize: Size(0, h),
          padding: pad,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
        child: _content(context),
      );
      return expand ? SizedBox(width: double.infinity, child: btn) : btn;
    }

    final btn = OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(h, h),
        padding: EdgeInsets.zero,
        side: BorderSide(color: cs.outlineVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: _content(context),
    );
    return btn;
  }
}
