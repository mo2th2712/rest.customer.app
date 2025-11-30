import 'dart:async';
import 'package:flutter/material.dart';

import 'package:restaurant_customer_app/design_system/widgets/ds_button.dart';
import 'package:restaurant_customer_app/features/cart/models/cart_models.dart';

class CartScreen extends StatefulWidget {
  final ValueNotifier<List<CartLineItem>> items;
  final void Function(String id) onInc;
  final void Function(String id) onDec;
  final void Function(String id) onRemove;

  const CartScreen({
    super.key,
    required this.items,
    required this.onInc,
    required this.onDec,
    required this.onRemove,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  OrderType _orderType = OrderType.delivery;
  PaymentMethod _paymentMethod = PaymentMethod.cash;

  final TextEditingController _addressCtrl = TextEditingController(
    text: 'عمّان - الدوار السابع، شارع زهران',
  );
  final TextEditingController _notesCtrl = TextEditingController();

  String _error = '';
  bool _loading = false;

  @override
  void dispose() {
    _addressCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  bool get _isAr =>
      Localizations.localeOf(context).languageCode == 'ar';

  int _count(List<CartLineItem> list) =>
      list.fold<int>(0, (s, it) => s + it.qty);

  double _subtotal(List<CartLineItem> list) =>
      list.fold<double>(0, (s, it) => s + it.lineTotal);

  double _deliveryFee() =>
      _orderType == OrderType.delivery ? 1.50 : 0.0; // قيمة تجريبية

  String _currency() => _isAr ? 'د.أ' : 'JOD';

  void _onOrderTypeChange(OrderType type) {
    setState(() {
      _orderType = type;
      // نفس منطق الـ TSX: لو استلام نخلي الدفع Cash فقط
      if (type == OrderType.pickup) {
        _paymentMethod = PaymentMethod.cash;
      }
    });
  }

  List<PaymentMethod> _availablePaymentMethods() {
    if (_orderType == OrderType.pickup) {
      return [PaymentMethod.cash];
    }
    return PaymentMethod.values;
  }

  Future<void> _handleConfirmOrder() async {
    if (_orderType == OrderType.delivery &&
        _addressCtrl.text.trim().isEmpty) {
      setState(() {
        _error = _isAr
            ? 'الرجاء إدخال عنوان التوصيل'
            : 'Please enter delivery address';
      });
      return;
    }

    setState(() {
      _error = '';
      _loading = true;
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    setState(() => _loading = false);

    final msg = _isAr
        ? 'تم إرسال الطلب (ديمو)'
        : 'Order placed (demo)';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ValueListenableBuilder<List<CartLineItem>>(
      valueListenable: widget.items,
      builder: (context, list, _) {
        final isEmpty = list.isEmpty;

        if (isEmpty) {
          return Scaffold(
            backgroundColor: cs.surface,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: cs.surface,
              surfaceTintColor: cs.surface,
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  _isAr ? Icons.chevron_right : Icons.chevron_left,
                ),
              ),
              title: Text(_isAr ? 'السلة' : 'Cart'),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '🛒',
                      style: TextStyle(fontSize: 64, height: 1),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isAr ? 'السلة فارغة' : 'Your cart is empty',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isAr
                          ? 'أضف بعض الأطباق اللذيذة إلى سلتك'
                          : 'Add some delicious dishes to your cart',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 18),
                    DsButton.primary(
                      size: DsButtonSize.lg,
                      expand: true,
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        _isAr ? 'تصفح القائمة' : 'Browse Menu',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final subtotal = _subtotal(list);
        final deliveryFee = _deliveryFee();
        final total = subtotal + deliveryFee;
        final count = _count(list);

        return Scaffold(
          backgroundColor: cs.surface,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: cs.surface,
            surfaceTintColor: cs.surface,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                _isAr ? Icons.chevron_right : Icons.chevron_left,
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_isAr ? 'السلة' : 'Cart'),
                const SizedBox(height: 2),
                Text(
                  _isAr ? '$count عنصر' : '$count items',
                  style: TextStyle(
                    color: cs.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 140),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cart items
                    Column(
                      children: list
                          .map(
                            (item) => Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 12),
                              child: _CartItemRow(
                                item: item,
                                isAr: _isAr,
                                currency: _currency(),
                                onInc: () => widget.onInc(item.id),
                                onDec: () => widget.onDec(item.id),
                                onRemove: () => widget.onRemove(item.id),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),

                    // Order type
                    Text(
                      _isAr ? 'نوع الطلب' : 'Order Type',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _OrderTypeCard(
                            selected: _orderType == OrderType.delivery,
                            emoji: '🛵',
                            label: _isAr ? 'توصيل' : 'Delivery',
                            onTap: () =>
                                _onOrderTypeChange(OrderType.delivery),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _OrderTypeCard(
                            selected: _orderType == OrderType.pickup,
                            emoji: '🏪',
                            label: _isAr ? 'استلام' : 'Pickup',
                            onTap: () =>
                                _onOrderTypeChange(OrderType.pickup),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Delivery address (only if delivery)
                    if (_orderType == OrderType.delivery) ...[
                      Text(
                        _isAr
                            ? 'عنوان التوصيل'
                            : 'Delivery Address',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _addressCtrl,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.location_on),
                          hintText: _isAr
                              ? 'أدخل عنوان التوصيل'
                              : 'Enter delivery address',
                          errorText: _error.isEmpty ? null : _error,
                          filled: true,
                          fillColor: cs.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: cs.outlineVariant,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: cs.outlineVariant,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: cs.primary,
                              width: 1.4,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _isAr ? 'عنوانك المحفوظ' : 'Your saved address',
                        style: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Payment method
                    Text(
                      _isAr ? 'طريقة الدفع' : 'Payment Method',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),

                    if (_orderType == OrderType.pickup)
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7D6),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFFE7C46A),
                          ),
                        ),
                        child: Text(
                          _isAr
                              ? 'ℹ️ للاستلام من الفرع، الدفع نقداً فقط'
                              : 'ℹ️ For pickup orders, cash payment only',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7A5B00),
                          ),
                        ),
                      ),

                    _PaymentMethodsRow(
                      selected: _paymentMethod,
                      available: _availablePaymentMethods(),
                      isAr: _isAr,
                      onChanged: (m) {
                        setState(() => _paymentMethod = m);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Notes
                    Text(
                      _isAr ? 'ملاحظات الطلب' : 'Order Notes',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _notesCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: _isAr
                            ? 'أي ملاحظات خاصة؟ مثل: من فضلك لا تضيف المايونيز'
                            : 'Any special requests? e.g., Please don\'t add mayonnaise',
                        filled: true,
                        fillColor: cs.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: cs.outlineVariant),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: cs.outlineVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: cs.primary,
                            width: 1.4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Summary
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: cs.outlineVariant),
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _isAr ? 'ملخص الطلب' : 'Order Summary',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _SummaryRow(
                            label: _isAr ? 'المجموع الفرعي' : 'Subtotal',
                            value:
                                '${subtotal.toStringAsFixed(2)} ${_currency()}',
                            muted: true,
                          ),
                          if (_orderType == OrderType.delivery) ...[
                            const SizedBox(height: 6),
                            _SummaryRow(
                              label: _isAr
                                  ? 'رسوم التوصيل'
                                  : 'Delivery Fee',
                              value:
                                  '${deliveryFee.toStringAsFixed(2)} ${_currency()}',
                              muted: true,
                            ),
                          ],
                          const SizedBox(height: 10),
                          Divider(color: cs.outlineVariant),
                          const SizedBox(height: 8),
                          _SummaryRow(
                            label: _isAr ? 'الإجمالي' : 'Total',
                            value:
                                '${total.toStringAsFixed(2)} ${_currency()}',
                            strong: true,
                            highlight: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom confirm button
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  top: false,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      border: Border(
                        top: BorderSide(color: cs.outlineVariant),
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 18,
                          offset: const Offset(0, -6),
                          color: Colors.black.withOpacity(0.06),
                        ),
                      ],
                    ),
                    child: DsButton.primary(
                      size: DsButtonSize.lg,
                      expand: true,
                      loading: _loading,
                      onPressed: _loading ? null : _handleConfirmOrder,
                      child: Text(
                        _isAr ? 'تأكيد الطلب' : 'Confirm Order',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CartItemRow extends StatelessWidget {
  final CartLineItem item;
  final bool isAr;
  final String currency;
  final VoidCallback onInc;
  final VoidCallback onDec;
  final VoidCallback onRemove;

  const _CartItemRow({
    required this.item,
    required this.isAr,
    required this.currency,
    required this.onInc,
    required this.onDec,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة / أيقونة
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                '🍽️',
                style: TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // تفاصيل
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.unitPrice.toStringAsFixed(2)} $currency',
                  style: TextStyle(
                    color: cs.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _QtyButton(
                      icon: Icons.remove,
                      onTap: onDec,
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 32,
                      child: Text(
                        '${item.qty}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _QtyButton(
                      icon: Icons.add,
                      onTap: onInc,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: onRemove,
                      style: IconButton.styleFrom(
                        padding: const EdgeInsets.all(8),
                      ),
                      icon: Icon(
                        Icons.delete_outline,
                        color: cs.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Line total
          Text(
            '${item.lineTotal.toStringAsFixed(2)} $currency',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      width: 32,
      height: 32,
      child: Material(
        color: cs.surface,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Icon(
              icon,
              size: 18,
              color: cs.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderTypeCard extends StatelessWidget {
  final bool selected;
  final String emoji;
  final String label;
  final VoidCallback onTap;

  const _OrderTypeCard({
    required this.selected,
    required this.emoji,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: selected
          ? cs.primary.withOpacity(0.06)
          : cs.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? cs.primary : cs.outlineVariant,
              width: 1.6,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 26),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentMethodsRow extends StatelessWidget {
  final PaymentMethod selected;
  final List<PaymentMethod> available;
  final bool isAr;
  final ValueChanged<PaymentMethod> onChanged;

  const _PaymentMethodsRow({
    required this.selected,
    required this.available,
    required this.isAr,
    required this.onChanged,
  });

  String _label(PaymentMethod m) {
    switch (m) {
      case PaymentMethod.cash:
        return isAr ? 'كاش' : 'Cash';
      case PaymentMethod.card:
        return isAr ? 'بطاقة' : 'Card';
      case PaymentMethod.applePay:
        return 'Apple Pay';
    }
  }

  IconData _icon(PaymentMethod m) {
    switch (m) {
      case PaymentMethod.cash:
        return Icons.attach_money_rounded;
      case PaymentMethod.card:
        return Icons.credit_card;
      case PaymentMethod.applePay:
        return Icons.phone_iphone;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: available
          .map(
            (m) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8, left: 8),
                child: Material(
                  color: selected == m
                      ? cs.primary.withOpacity(0.06)
                      : cs.surface,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => onChanged(m),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected == m
                              ? cs.primary
                              : cs.outlineVariant,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(
                            _icon(m),
                            size: 18,
                            color: selected == m
                                ? cs.primary
                                : cs.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              _label(m),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: cs.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool strong;
  final bool muted;
  final bool highlight;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.strong = false,
    this.muted = false,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final style = TextStyle(
      fontWeight: strong ? FontWeight.w900 : FontWeight.w800,
      color: muted
          ? cs.onSurfaceVariant
          : highlight
              ? cs.primary
              : cs.onSurface,
      fontSize: strong ? 18 : 14,
    );

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: style.copyWith(fontSize: 14),
          ),
        ),
        Text(value, style: style),
      ],
    );
  }
}
