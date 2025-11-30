import 'dart:math';

import 'package:flutter/material.dart';

import 'package:restaurant_customer_app/design_system/widgets/ds_button.dart';
import 'package:restaurant_customer_app/features/cart/models/cart_models.dart';
import 'package:restaurant_customer_app/features/orders/models/order_models.dart';
import 'package:restaurant_customer_app/features/orders/presentation/order_details_screen.dart';

class OrderSuccessScreen extends StatefulWidget {
  final RestaurantOrder order;

  const OrderSuccessScreen({
    super.key,
    required this.order,
  });

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with SingleTickerProviderStateMixin {
  bool _show = false;

  late final AnimationController _c;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  bool get _isAr => Localizations.localeOf(context).languageCode == 'ar';
  String _cur() => _isAr ? 'ر.س' : 'SAR';

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _scale = CurvedAnimation(parent: _c, curve: Curves.easeOutBack);
    _opacity = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      setState(() => _show = true);
      _c.forward(from: 0);
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  String _orderTypeText(OrderType t) => t == OrderType.delivery
      ? (_isAr ? 'توصيل' : 'Delivery')
      : (_isAr ? 'استلام' : 'Pickup');

  String _paymentText(PaymentMethod m, OrderType type) {
    switch (m) {
      case PaymentMethod.cash:
        if (type == OrderType.delivery) {
          return _isAr ? 'كاش عند الاستلام' : 'Cash on delivery';
        }
        return _isAr ? 'كاش' : 'Cash';
      case PaymentMethod.card:
        return _isAr ? 'بطاقة ائتمان' : 'Credit Card';
      case PaymentMethod.applePay:
        return 'Apple Pay';
    }
  }

  double _subtotal(RestaurantOrder o) =>
      o.lines.fold<double>(0, (s, it) => s + (it.unitPrice * it.qty));

  double _total(RestaurantOrder o) => _subtotal(o) + o.deliveryFee;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final order = widget.order;
    final total = _total(order);

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: FadeTransition(
              opacity: _opacity,
              child: ScaleTransition(
                scale: _scale,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 132,
                            height: 132,
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.14),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Icon(
                              Icons.check_circle,
                              size: 88,
                              color: Colors.green,
                            ),
                          ),
                          if (_show)
                            ...List.generate(8, (i) {
                              final a = (i * 45) * pi / 180;
                              final dx = cos(a) * 74;
                              final dy = sin(a) * -74;
                              return TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: 1),
                                duration: Duration(
                                  milliseconds: 520 + i * 60,
                                ),
                                curve: Curves.easeOutBack,
                                builder: (context, v, _) {
                                  return Transform.translate(
                                    offset: Offset(dx * v, dy * v),
                                    child: Opacity(
                                      opacity: 0.75 * v,
                                      child: const Text(
                                        '✨',
                                        style: TextStyle(fontSize: 22),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        _isAr ? 'تم إرسال الطلب' : 'Order Placed',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isAr
                            ? 'شكراً لطلبك. سنبدأ في تحضيره الآن'
                            : "Thank you for your order. We'll start preparing it now",
                        style: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cs.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: cs.outlineVariant),
                        ),
                        child: Column(
                          children: [
                            _kv(
                              context,
                              label: _isAr ? 'رقم الطلب' : 'Order ID',
                              value: order.id,
                              divider: true,
                            ),
                            _kv(
                              context,
                              label: _isAr ? 'الفرع' : 'Branch',
                              value: '#${order.branchSnapshot.id}',
                            ),
                            const SizedBox(height: 12),
                            _kv(
                              context,
                              label: _isAr ? 'نوع الطلب' : 'Order Type',
                              value: _orderTypeText(order.type),
                            ),
                            const SizedBox(height: 12),
                            _kv(
                              context,
                              label: _isAr ? 'طريقة الدفع' : 'Payment',
                              value: _paymentText(
                                order.paymentMethod,
                                order.type,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _kv(
                              context,
                              label: _isAr ? 'الوقت المتوقع' : 'Estimated time',
                              value: _isAr ? '25-30 دقيقة' : '25-30 min',
                              valueColor: cs.primary,
                            ),
                            const SizedBox(height: 14),
                            Container(
                              height: 1,
                              color: cs.outlineVariant,
                            ),
                            const SizedBox(height: 12),
                            _kv(
                              context,
                              label: _isAr ? 'المجموع' : 'Total',
                              value:
                                  '${total.toStringAsFixed(2)} ${_cur()}',
                              valueColor: cs.primary,
                              valueBig: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      DsButton.primary(
                        size: DsButtonSize.lg,
                        expand: true,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  OrderDetailsScreen(order: order),
                            ),
                          );
                        },
                        child:
                            Text(_isAr ? 'تتبع الطلب' : 'Track Order'),
                      ),
                      const SizedBox(height: 10),
                      DsButton.secondary(
                        size: DsButtonSize.lg,
                        expand: true,
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          _isAr ? 'العودة للرئيسية' : 'Back to Home',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _kv(
    BuildContext context, {
    required String label,
    required String value,
    bool divider = false,
    Color? valueColor,
    bool valueBig = false,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                color: valueColor ?? cs.onSurface,
                fontWeight: FontWeight.w900,
                fontSize: valueBig ? 20 : 14,
              ),
            ),
          ],
        ),
        if (divider) ...[
          const SizedBox(height: 12),
          Container(height: 1, color: cs.outlineVariant),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
