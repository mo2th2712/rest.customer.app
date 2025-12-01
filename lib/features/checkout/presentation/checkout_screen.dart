import 'package:flutter/material.dart';
import 'package:restaurant_customer_app/app/app_state.dart';
import 'package:restaurant_customer_app/features/cart/models/cart_models.dart';
import 'package:restaurant_customer_app/features/delivery/presentation/delivery_address_screen.dart';
import 'package:restaurant_customer_app/features/orders/models/order_models.dart';
import 'package:restaurant_customer_app/features/orders/presentation/order_success_screen.dart';

class CheckoutScreen extends StatefulWidget 
  final ValueNotifier<List<CartLineItem>> items;

  final void Function(String id)? onInc;
  final void Function(String id)? onDec;
  final void Function(String id)? onRemove;
  final VoidCallback? onClearIfEmpty;

  const CheckoutScreen({
    super.key,
    required this.items,
    this.onInc,
    this.onDec,
    this.onRemove,
    this.onClearIfEmpty,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  OrderType _orderType = OrderType.delivery;
  PaymentMethod _payment = PaymentMethod.cash;

  final _notesCtrl = TextEditingController();

  String? _deliveryAddress;
  double? _deliveryLat;
  double? _deliveryLng;

  String? _lastBranchId;
  bool _loadingAddress = false;

  bool get _isAr => Localizations.localeOf(context).languageCode == 'ar';
  TextDirection get _dir => _isAr ? TextDirection.rtl : TextDirection.ltr;

  String _t(String en, String ar) => _isAr ? ar : en;

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  double _subtotal(List<CartLineItem> items) =>
      items.fold<double>(0, (s, it) => s + it.lineTotal);

  double _deliveryFee() => _orderType == OrderType.delivery ? 0.75 : 0;

  bool _paymentEnabled(PaymentMethod m) {
    if (_orderType == OrderType.delivery) return true;
    return m == PaymentMethod.cash;
  }

  void _fallbackInc(String id) {
    final items = List<CartLineItem>.from(widget.items.value);
    final idx = items.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    items[idx] = items[idx].copyWith(qty: items[idx].qty + 1);
    widget.items.value = items;
  }

  void _fallbackDec(String id) {
    final items = List<CartLineItem>.from(widget.items.value);
    final idx = items.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    final next = items[idx].qty - 1;
    if (next <= 0) {
      items.removeAt(idx);
    } else {
      items[idx] = items[idx].copyWith(qty: next);
    }
    widget.items.value = items;
    if (items.isEmpty) widget.onClearIfEmpty?.call();
  }

  void _fallbackRemove(String id) {
    final items = List<CartLineItem>.from(widget.items.value);
    items.removeWhere((e) => e.id == id);
    widget.items.value = items;
    if (items.isEmpty) widget.onClearIfEmpty?.call();
  }

  Future<void> _ensureAddressLoadedForBranch(String branchId) async {
    if (_loadingAddress) return;
    _loadingAddress = true;
    try {
      final loc = await DeliveryAddressScreen.loadLocationForBranch(branchId);
      final savedAddr = await DeliveryAddressScreen.loadForBranch(branchId);

      if (!mounted) return;

      final merged = (loc?.address ?? savedAddr)?.trim();
      setState(() {
        _deliveryAddress = (merged == null || merged.isEmpty) ? null : merged;
        _deliveryLat = loc?.lat;
        _deliveryLng = loc?.lng;
      });
    } finally {
      _loadingAddress = false;
    }
  }

  Future<void> _pickDeliveryAddress(String branchId) async {
    final nav = Navigator.of(context, rootNavigator: true);
    final res = await nav.push<String>(
      MaterialPageRoute(
        builder: (_) => DeliveryAddressScreen(
          branchId: branchId,
          initialAddress: _deliveryAddress ?? '',
        ),
      ),
    );

    if (!mounted) return;

    final cleaned = (res ?? '').trim();
    if (cleaned.isEmpty) return;

    final loc = await DeliveryAddressScreen.loadLocationForBranch(branchId);
    if (!mounted) return;

    setState(() {
      _deliveryAddress = cleaned;
      _deliveryLat = loc?.lat;
      _deliveryLng = loc?.lng;
    });
  }

  String _money(double v) => '${v.toStringAsFixed(2)} د.أ';

  String _orderTypeText(OrderType t) {
    switch (t) {
      case OrderType.delivery:
        return _t('Delivery', 'توصيل');
      case OrderType.pickup:
        return _t('Pickup', 'استلام');
    }
  }

  String _paymentText(PaymentMethod m) {
    switch (m) {
      case PaymentMethod.cash:
        return _orderType == OrderType.delivery
            ? _t('Cash on delivery', 'كاش عند الاستلام')
            : _t('Cash', 'كاش');
      case PaymentMethod.card:
        return _t('Card', 'بطاقة');
      case PaymentMethod.applePay:
        return 'Apple Pay';
    }
  }

  Future<void> _confirmOrder() async {
    final app = AppStateScope.of(context);
    final items = List<CartLineItem>.from(widget.items.value);
    if (items.isEmpty) return;

    final branchId = app.branch.id.toString();

    String? address;
    double? lat;
    double? lng;

    if (_orderType == OrderType.delivery) {
      if ((_deliveryAddress ?? '').trim().isEmpty ||
          _deliveryLat == null ||
          _deliveryLng == null) {
        await _pickDeliveryAddress(branchId);
      }

      address = (_deliveryAddress ?? '').trim();
      lat = _deliveryLat;
      lng = _deliveryLng;

      if (address.isEmpty || lat == null || lng == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_t('Please select delivery location.', 'رجاءً حدّد موقع التوصيل.')),
            duration: const Duration(milliseconds: 1200),
          ),
        );
        return;
      }
    }

    final now = DateTime.now();
    final orderId = 'ORD-${now.millisecondsSinceEpoch.toString().substring(7)}';

    final order = RestaurantOrder(
      id: orderId,
      createdAt: now,
      branchSnapshot: app.branch,
      type: _orderType,
      paymentMethod: _payment,
      lines: items
          .map(
            (i) => OrderLine(
              id: i.id,
              title: i.title,
              qty: i.qty,
              unitPrice: i.unitPrice,
            ),
          )
          .toList(),
      deliveryFee: _deliveryFee(),
      status: OrderStatus.pending,
      deliveryAddress: _orderType == OrderType.delivery ? address : null,
      deliveryLat: _orderType == OrderType.delivery ? lat : null,
      deliveryLng: _orderType == OrderType.delivery ? lng : null,
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    );

    app.addOrder(order);

    try {
      app.startDemoProgressFor(order.id);
    } catch (_) {}

    try {
      app.setTab(1);
    } catch (_) {}

    widget.items.value = [];
    widget.onClearIfEmpty?.call();

    if (!mounted) return;

    final nav = Navigator.of(context, rootNavigator: true);
    nav.pushReplacement(
      MaterialPageRoute(builder: (_) => OrderSuccessScreen(order: order)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final app = AppStateScope.of(context);
    final branchId = app.branch.id.toString();

    if (_lastBranchId != branchId) {
      _lastBranchId = branchId;
      if (_orderType == OrderType.delivery) {
        _ensureAddressLoadedForBranch(branchId);
      }
    }

    return Directionality(
      textDirection: _dir,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_t('Checkout', 'إتمام الطلب')),
          centerTitle: true,
        ),
        body: ValueListenableBuilder<List<CartLineItem>>(
          valueListenable: widget.items,
          builder: (context, items, _) {
            final subtotal = _subtotal(items);
            final fee = _deliveryFee();
            final total = subtotal + fee;

            final canConfirm = items.isNotEmpty &&
                (_orderType == OrderType.pickup ||
                    ((_deliveryAddress ?? '').trim().isNotEmpty &&
                        _deliveryLat != null &&
                        _deliveryLng != null));

            return Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
                  children: [
                    _sectionTitle(_t('Order type', 'نوع الطلب')),
                    const SizedBox(height: 10),
                    SegmentedButton<OrderType>(
                      segments: [
                        ButtonSegment(
                          value: OrderType.pickup,
                          label: Text(_t('Pickup', 'استلام')),
                          icon: const Icon(Icons.shopping_bag_outlined),
                        ),
                        ButtonSegment(
                          value: OrderType.delivery,
                          label: Text(_t('Delivery', 'توصيل')),
                          icon: const Icon(Icons.delivery_dining),
                        ),
                      ],
                      selected: {_orderType},
                      onSelectionChanged: (v) {
                        setState(() {
                          _orderType = v.first;
                          if (_orderType == OrderType.pickup) {
                            _payment = PaymentMethod.cash;
                          } else {
                            _ensureAddressLoadedForBranch(branchId);
                          }
                        });
                      },
                    ),
                    if (_orderType == OrderType.delivery) ...[
                      const SizedBox(height: 18),
                      _sectionTitle(_t('Delivery location', 'موقع التوصيل')),
                      const SizedBox(height: 10),
                      _deliveryCard(cs, branchId),
                    ],
                    const SizedBox(height: 18),
                    _sectionTitle(_t('Payment method', 'طريقة الدفع')),
                    const SizedBox(height: 10),
                    _paymentTile(
                      cs,
                      method: PaymentMethod.cash,
                      icon: Icons.payments_outlined,
                      title: _orderType == OrderType.delivery
                          ? _t('Cash on delivery', 'كاش عند الاستلام')
                          : _t('Cash', 'كاش'),
                      enabled: _paymentEnabled(PaymentMethod.cash),
                      disabledHint: null,
                    ),
                    const SizedBox(height: 10),
                    _paymentTile(
                      cs,
                      method: PaymentMethod.card,
                      icon: Icons.credit_card,
                      title: _t('Card', 'بطاقة'),
                      enabled: _paymentEnabled(PaymentMethod.card),
                      disabledHint: _t('Delivery only', 'متاح فقط للتوصيل'),
                    ),
                    const SizedBox(height: 10),
                    _paymentTile(
                      cs,
                      method: PaymentMethod.applePay,
                      icon: Icons.apple,
                      title: 'Apple Pay',
                      enabled: _paymentEnabled(PaymentMethod.applePay),
                      disabledHint: _t('Delivery only', 'متاح فقط للتوصيل'),
                    ),
                    const SizedBox(height: 18),
                    _sectionTitle(_t('Cart', 'السلة')),
                    const SizedBox(height: 10),
                    if (items.isEmpty)
                      _emptyCart(cs)
                    else ...[
                      for (final it in items) ...[
                        _cartItem(cs, it),
                        const SizedBox(height: 10),
                      ],
                    ],
                    const SizedBox(height: 18),
                    _sectionTitle(_t('Notes', 'ملاحظات')),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _notesCtrl,
                      minLines: 2,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: _t('Add notes for the restaurant...', 'اكتب ملاحظات للمطعم...'),
                        filled: true,
                        fillColor: cs.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(color: cs.outlineVariant),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(color: cs.outlineVariant),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _sectionTitle(_t('Summary', 'الملخص')),
                    const SizedBox(height: 10),
                    _summaryCard(
                      cs,
                      subtotal: subtotal,
                      fee: fee,
                      total: total,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${_t('Type', 'النوع')}: ${_orderTypeText(_orderType)}  •  ${_t('Payment', 'الدفع')}: ${_paymentText(_payment)}',
                      style: TextStyle(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SafeArea(
                    top: false,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        border: Border(
                          top: BorderSide(color: cs.outlineVariant.withOpacity(0.7)),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: cs.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: cs.outlineVariant),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _t('Total', 'الإجمالي'),
                                    style: TextStyle(
                                      color: cs.onSurfaceVariant,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 180),
                                    child: Text(
                                      _money(total),
                                      key: ValueKey(total.toStringAsFixed(2)),
                                      style: TextStyle(
                                        color: cs.onSurface,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            height: 52,
                            child: FilledButton(
                              onPressed: canConfirm ? _confirmOrder : null,
                              child: Text(
                                _t('Confirm', 'تأكيد'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
    );
  }

  Widget _deliveryCard(ColorScheme cs, String branchId) {
    final hasAddress = (_deliveryAddress ?? '').trim().isNotEmpty;
    final text = hasAddress
        ? _deliveryAddress!.trim()
        : _t('Tap to pick location on map', 'اضغط لتحديد الموقع على الخريطة');

    return Material(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _pickDeliveryAddress(branchId),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Row(
            children: [
              Icon(Icons.location_on_outlined, color: cs.onSurfaceVariant),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: hasAddress ? cs.onSurface : cs.onSurfaceVariant,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                _isAr ? Icons.chevron_left : Icons.chevron_right,
                color: cs.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paymentTile(
    ColorScheme cs, {
    required PaymentMethod method,
    required IconData icon,
    required String title,
    required bool enabled,
    required String? disabledHint,
  }) {
    final selected = _payment == method;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 160),
      opacity: enabled ? 1 : 0.55,
      child: Material(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: enabled
              ? () => setState(() => _payment = method)
              : () {
                  if (disabledHint == null || disabledHint.trim().isEmpty) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(disabledHint),
                      duration: const Duration(milliseconds: 900),
                    ),
                  );
                },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: selected ? cs.primary : cs.outlineVariant,
                width: selected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: selected ? cs.primary : cs.onSurfaceVariant),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 160),
                  child: selected
                      ? Icon(Icons.check_circle, color: cs.primary, key: const ValueKey('on'))
                      : Icon(Icons.radio_button_unchecked,
                          color: cs.onSurfaceVariant, key: const ValueKey('off')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cartItem(ColorScheme cs, CartLineItem it) {
    final onInc = widget.onInc ?? _fallbackInc;
    final onDec = widget.onDec ?? _fallbackDec;
    final onRemove = widget.onRemove ?? _fallbackRemove;

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  it.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  _money(it.lineTotal),
                  style: TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => onDec(it.id),
                  icon: const Icon(Icons.remove),
                ),
                Text(
                  '${it.qty}',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => onInc(it.id),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => onRemove(it.id),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }

  Widget _emptyCart(ColorScheme cs) {
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
          Expanded(
            child: Text(_t('Your cart is empty.', 'السلة فارغة حالياً.')),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(
    ColorScheme cs, {
    required double subtotal,
    required double fee,
    required double total,
  }) {
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
            label: _t('Subtotal', 'المجموع الفرعي'),
            value: _money(subtotal),
          ),
          const SizedBox(height: 8),
          _summaryRow(
            label: _t('Delivery fee', 'رسوم التوصيل'),
            value: fee == 0 ? '—' : _money(fee),
          ),
          const Divider(height: 18),
          _summaryRow(
            label: _t('Total', 'الإجمالي'),
            value: _money(total),
            strong: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow({
    required String label,
    required String value,
    bool strong = false,
  }) {
    final style = strong
        ? Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)
        : Theme.of(context).textTheme.bodyMedium;

    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(value, style: style),
      ],
    );
  }
}
