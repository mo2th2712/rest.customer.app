import 'package:flutter/material.dart';
import 'package:restaurant_customer_app/design_system/motion.dart';
import 'package:restaurant_customer_app/features/cart/models/cart_models.dart';
import 'package:restaurant_customer_app/features/checkout/presentation/checkout_screen.dart';

class CartBottomSheet extends StatefulWidget {
  final ValueNotifier<List<CartLineItem>> items;
  final VoidCallback onClearIfEmpty;
  final void Function(String id) onInc;
  final void Function(String id) onDec;
  final void Function(String id) onRemove;

  const CartBottomSheet({
    super.key,
    required this.items,
    required this.onClearIfEmpty,
    required this.onInc,
    required this.onDec,
    required this.onRemove,
  });

  static Future<void> show({
    required BuildContext context,
    required TickerProvider vsync,
    required ValueNotifier<List<CartLineItem>> items,
    required void Function(String id) onInc,
    required void Function(String id) onDec,
    required void Function(String id) onRemove,
    required VoidCallback onClearIfEmpty,
  }) {
    final rootNav = Navigator.of(context, rootNavigator: true);

    return showModalBottomSheet(
      context: rootNav.context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (_) => CartBottomSheet(
        items: items,
        onInc: onInc,
        onDec: onDec,
        onRemove: onRemove,
        onClearIfEmpty: onClearIfEmpty,
      ),
    );
  }

  @override
  State<CartBottomSheet> createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends State<CartBottomSheet> {
  bool _closing = false;

  String _t(bool isAr, String en, String ar) => isAr ? ar : en;

  void _closeSheet() {
    if (_closing) return;
    _closing = true;
    Navigator.of(context, rootNavigator: true).maybePop();
  }

  double _subtotal(List<CartLineItem> items) =>
      items.fold<double>(0, (s, it) => s + it.lineTotal);

  int _count(List<CartLineItem> items) =>
      items.fold<int>(0, (s, it) => s + it.qty);

  Future<void> _openCheckout() async {
    final rootNav = Navigator.of(context, rootNavigator: true);
    final itemsNow = widget.items.value;
    if (itemsNow.isEmpty) return;

    rootNav.pop();

    await Future.microtask(() async {
      await rootNav.push(
        MaterialPageRoute(
          builder: (_) => CheckoutScreen(
            items: widget.items,
            onInc: widget.onInc,
            onDec: widget.onDec,
            onRemove: widget.onRemove,
            onClearIfEmpty: widget.onClearIfEmpty,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    final titleCart = _t(isAr, 'Cart', 'السلة');
    final confirmOrder = _t(isAr, 'Confirm order', 'تأكيد الطلب');
    final emptyCart = _t(isAr, 'Your cart is empty.', 'السلة فارغة حالياً.');
    final itemsLabel = _t(isAr, 'items', 'منتج');
    final subtotalLabel = _t(isAr, 'Subtotal', 'المجموع الفرعي');
    final totalLabel = _t(isAr, 'Total', 'الإجمالي');

    return DraggableScrollableSheet(
      initialChildSize: 0.86,
      minChildSize: 0.55,
      maxChildSize: 0.96,
      builder: (context, scrollCtrl) {
        return Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                height: 5,
                width: 48,
                decoration: BoxDecoration(
                  color: cs.outlineVariant.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        titleCart,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                    ),
                    IconButton(
                      onPressed: _closeSheet,
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ValueListenableBuilder<List<CartLineItem>>(
                  valueListenable: widget.items,
                  builder: (context, items, _) {
                    return ListView(
                      controller: scrollCtrl,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      children: [
                        const SizedBox(height: 8),
                        if (items.isEmpty)
                          _emptyCart(context, emptyCart)
                        else ...[
                          for (final it in items) ...[
                            _cartRow(context, it),
                            const SizedBox(height: 10),
                          ],
                          const SizedBox(height: 10),
                          _summaryCard(
                            context,
                            items,
                            subtotalLabel: subtotalLabel,
                            totalLabel: totalLabel,
                            itemsLabel: itemsLabel,
                          ),
                        ],
                        const SizedBox(height: 90),
                      ],
                    );
                  },
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  child: ValueListenableBuilder<List<CartLineItem>>(
                    valueListenable: widget.items,
                    builder: (context, items, _) {
                      final enabled = items.isNotEmpty;

                      return AnimatedSlide(
                        duration: AppMotion.standard,
                        curve: AppMotion.easeOut,
                        offset: enabled ? Offset.zero : const Offset(0, 0.15),
                        child: AnimatedOpacity(
                          duration: AppMotion.standard,
                          opacity: enabled ? 1 : 0.6,
                          child: SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: FilledButton(
                              onPressed: enabled ? _openCheckout : null,
                              child: Text(
                                confirmOrder,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _summaryCard(
    BuildContext context,
    List<CartLineItem> items, {
    required String subtotalLabel,
    required String totalLabel,
    required String itemsLabel,
  }) {
    final cs = Theme.of(context).colorScheme;

    final subtotal = _subtotal(items);
    final total = subtotal;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          _summaryRow(
            context,
            label: subtotalLabel,
            value: '${subtotal.toStringAsFixed(2)} د.أ',
          ),
          const Divider(height: 18),
          _summaryRow(
            context,
            label: totalLabel,
            value: '${total.toStringAsFixed(2)} د.أ',
            strong: true,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              '${_count(items)} $itemsLabel',
              style: TextStyle(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    BuildContext context, {
    required String label,
    required String value,
    bool strong = false,
  }) {
    final style = strong
        ? Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.w900)
        : Theme.of(context).textTheme.bodyMedium;

    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(value, style: style),
      ],
    );
  }

  Widget _cartRow(BuildContext context, CartLineItem it) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              it.title,
              style: const TextStyle(fontWeight: FontWeight.w900),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => widget.onDec(it.id),
            icon: const Icon(Icons.remove),
          ),
          Text(
            '${it.qty}',
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => widget.onInc(it.id),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => widget.onRemove(it.id),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }

  Widget _emptyCart(BuildContext context, String text) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.remove_shopping_cart, color: cs.onSurfaceVariant),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}