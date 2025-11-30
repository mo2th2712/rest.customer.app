import 'package:flutter/material.dart';

import 'package:restaurant_customer_app/design_system/widgets/ds_chip.dart';
import 'package:restaurant_customer_app/design_system/widgets/ds_button.dart';

import 'package:restaurant_customer_app/features/cart/models/cart_models.dart';
import 'package:restaurant_customer_app/features/orders/models/order_models.dart';

class OrderDetailsScreen extends StatelessWidget {
  final RestaurantOrder order;

  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  bool _isAr(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar';

  String _statusKey(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.preparing:
        return 'preparing';
      case OrderStatus.accepted:
        return 'accepted';
      case OrderStatus.outForDelivery:
        return 'out-for-delivery';
      case OrderStatus.completed:
        return 'completed';
      case OrderStatus.canceled:
        return 'canceled';
    }
  }

  (_StatusUi, String, String) _statusInfo(
    BuildContext context,
    OrderStatus s,
  ) {
    final ar = _isAr(context);
    switch (s) {
      case OrderStatus.pending:
        return (
          _StatusUi('⏳', ar ? 'قيد الانتظار' : 'Pending'),
          ar ? 'قيد الانتظار' : 'Pending',
          ar ? 'سنبدأ بتحضير طلبك قريباً' : 'We will start preparing your order soon'
        );
      case OrderStatus.preparing:
        return (
          _StatusUi('👨‍🍳', ar ? 'قيد التحضير' : 'Preparing'),
          ar ? 'قيد التحضير' : 'Preparing',
          ar ? 'نحن نحضر طلبك الآن' : 'We are preparing your order now'
        );
      case OrderStatus.accepted:
        return (
          _StatusUi('✅', ar ? 'تم القبول' : 'Accepted'),
          ar ? 'تم القبول' : 'Accepted',
          ar ? 'تم قبول الطلب وجاري التحضير' : 'Order accepted and being prepared'
        );
      case OrderStatus.outForDelivery:
        return (
          _StatusUi('🛵', ar ? 'في الطريق' : 'Out for Delivery'),
          ar ? 'في الطريق' : 'Out for Delivery',
          ar ? 'طلبك في الطريق إليك' : 'Your order is on the way'
        );
      case OrderStatus.completed:
        return (
          _StatusUi('✅', ar ? 'مكتمل' : 'Completed'),
          ar ? 'مكتمل' : 'Completed',
          ar ? 'تم تسليم طلبك بنجاح' : 'Order delivered successfully'
        );
      case OrderStatus.canceled:
        return (
          _StatusUi('❌', ar ? 'ملغي' : 'Canceled'),
          ar ? 'ملغي' : 'Canceled',
          ar ? 'تم إلغاء الطلب' : 'Order was canceled'
        );
    }
  }

  String _orderTypeText(BuildContext context, OrderType t) {
    final ar = _isAr(context);
    return t == OrderType.delivery
        ? (ar ? 'توصيل' : 'Delivery')
        : (ar ? 'استلام' : 'Pickup');
  }

  String _paymentText(
    BuildContext context,
    PaymentMethod m,
    OrderType type,
  ) {
    final ar = _isAr(context);
    switch (m) {
      case PaymentMethod.cash:
        if (type == OrderType.delivery) {
          return ar ? 'كاش عند الاستلام' : 'Cash on delivery';
        }
        return ar ? 'كاش' : 'Cash';
      case PaymentMethod.card:
        return ar ? 'بطاقة ائتمان' : 'Credit Card';
      case PaymentMethod.applePay:
        return 'Apple Pay';
    }
  }

  String _cur(BuildContext context) => _isAr(context) ? 'ر.س' : 'SAR';

  double _subtotal(RestaurantOrder o) =>
      o.lines.fold<double>(0, (s, it) => s + (it.unitPrice * it.qty));

  double _total(RestaurantOrder o) => _subtotal(o) + o.deliveryFee;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ar = _isAr(context);

    final dt = order.createdAt;
    final dateStr = MaterialLocalizations.of(context).formatMediumDate(dt);
    final timeStr = MaterialLocalizations.of(context)
        .formatTimeOfDay(TimeOfDay.fromDateTime(dt));

    final (stUi, stText, stDesc) = _statusInfo(context, order.status);
    final key = _statusKey(order.status);

    final subtotal = _subtotal(order);
    final total = _total(order);

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: cs.surface,
                border: Border(
                  bottom: BorderSide(color: cs.outlineVariant),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(ar ? Icons.chevron_right : Icons.chevron_left),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ar ? 'تفاصيل الطلب' : 'Order Details',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${order.id}  •  $dateStr  •  $timeStr',
                          style: TextStyle(
                            color: cs.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stUi.emoji,
                          style: const TextStyle(fontSize: 34, height: 1),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DsChip(
  variant: DsChipVariant.status,
  statusKey: key,
  emoji: null,
  child: Text(stText),
),

                              const SizedBox(height: 8),
                              Text(
                                stDesc,
                                style: TextStyle(
                                  color: cs.onSurfaceVariant,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ar ? 'معلومات الطلب' : 'Order Information',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 14),
                        _infoRow(
                          context,
                          icon: Icons.storefront_outlined,
                          label: ar ? 'الفرع' : 'Branch',
                          value: '#${order.branchSnapshot.id}',
                        ),
                        const SizedBox(height: 12),
                        _infoRow(
                          context,
                          iconWidget: const Text(
                            '🛵',
                            style: TextStyle(fontSize: 18, height: 1),
                          ),
                          label: ar ? 'نوع الطلب' : 'Order Type',
                          value: _orderTypeText(context, order.type),
                        ),
                        if (order.type == OrderType.delivery &&
                            (order.deliveryAddress ?? '').trim().isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _infoRow(
                            context,
                            icon: Icons.location_on_outlined,
                            label: ar ? 'عنوان التوصيل' : 'Delivery Address',
                            value: order.deliveryAddress!.trim(),
                          ),
                        ],
                        const SizedBox(height: 12),
                        _infoRow(
                          context,
                          iconWidget: const Text(
                            '💳',
                            style: TextStyle(fontSize: 18, height: 1),
                          ),
                          label: ar ? 'طريقة الدفع' : 'Payment Method',
                          value:
                              _paymentText(context, order.paymentMethod, order.type),
                        ),
                        if ((order.notes ?? '').trim().isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _infoRow(
                            context,
                            iconWidget: const Text(
                              '📝',
                              style: TextStyle(fontSize: 18, height: 1),
                            ),
                            label: ar ? 'ملاحظات' : 'Notes',
                            value: order.notes!.trim(),
                          ),
                        ],
                        if (order.type == OrderType.delivery) ...[
                          const SizedBox(height: 12),
                          _infoRow(
                            context,
                            iconWidget: const Text(
                              '🧑‍✈️',
                              style: TextStyle(fontSize: 18, height: 1),
                            ),
                            label: ar ? 'معلومات الكابتن' : 'Driver info',
                            value: ar
                                ? 'سيتم تعيين كابتن قريباً'
                                : 'A driver will be assigned soon',
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ar ? 'العناصر' : 'Items',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 12),
                        ...order.lines.map((it) {
                          final lineTotal = (it.unitPrice * it.qty);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        it.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${it.qty} × ${it.unitPrice.toStringAsFixed(2)} ${_cur(context)}',
                                        style: TextStyle(
                                          color: cs.onSurfaceVariant,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '${lineTotal.toStringAsFixed(2)} ${_cur(context)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.only(top: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: cs.outlineVariant),
                            ),
                          ),
                          child: Column(
                            children: [
                              _sumRow(
                                context,
                                label:
                                    ar ? 'المجموع الفرعي' : 'Subtotal',
                                value:
                                    '${subtotal.toStringAsFixed(2)} ${_cur(context)}',
                                muted: true,
                              ),
                              if (order.deliveryFee > 0) ...[
                                const SizedBox(height: 8),
                                _sumRow(
                                  context,
                                  label:
                                      ar ? 'رسوم التوصيل' : 'Delivery Fee',
                                  value:
                                      '${order.deliveryFee.toStringAsFixed(2)} ${_cur(context)}',
                                  muted: true,
                                ),
                              ],
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: cs.outlineVariant),
                                  ),
                                ),
                                child: _sumRow(
                                  context,
                                  label: ar ? 'المجموع' : 'Total',
                                  value:
                                      '${total.toStringAsFixed(2)} ${_cur(context)}',
                                  strong: true,
                                  highlight: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 88),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: order.status == OrderStatus.completed
          ? SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                decoration: BoxDecoration(
                  color: cs.surface,
                  border: Border(
                    top: BorderSide(color: cs.outlineVariant),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 18,
                      offset: const Offset(0, -6),
                      color: Colors.black.withOpacity(0.07),
                    ),
                  ],
                ),
                child: DsButton.primary(
                  size: DsButtonSize.lg,
                  expand: true,
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(ar ? 'إعادة الطلب' : 'Reorder'),
                ),
              ),
            )
          : null,
    );
  }

  Widget _infoRow(
    BuildContext context, {
    IconData? icon,
    Widget? iconWidget,
    required String label,
    required String value,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (iconWidget != null)
          SizedBox(
            width: 22,
            child: Align(
              alignment: Alignment.topCenter,
              child: iconWidget,
            ),
          )
        else
          SizedBox(
            width: 22,
            child: Icon(
              icon ?? Icons.info_outline,
              size: 20,
              color: cs.onSurfaceVariant,
            ),
          ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: TextStyle(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sumRow(
    BuildContext context, {
    required String label,
    required String value,
    bool strong = false,
    bool muted = false,
    bool highlight = false,
  }) {
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

class _StatusUi {
  final String emoji;
  final String text;

  _StatusUi(this.emoji, this.text);
}
