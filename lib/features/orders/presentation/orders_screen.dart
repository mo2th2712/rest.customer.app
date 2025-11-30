import 'package:flutter/material.dart';
import 'package:restaurant_customer_app/features/cart/models/cart_labels.dart';
import 'package:restaurant_customer_app/app/app_state.dart';
import 'package:restaurant_customer_app/features/orders/models/order_models.dart';
import 'package:restaurant_customer_app/features/orders/presentation/order_details_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppStateScope.of(context);

    // newest first
    final orders = List<RestaurantOrder>.from(app.orders)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final cs = Theme.of(context).colorScheme;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isAr ? 'طلباتي' : 'My Orders'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: orders.isEmpty
            ? _EmptyOrders(isAr: isAr)
            : ListView.separated(
                itemCount: orders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final o = orders[i];

                  return _OrderCard(
                    order: o,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => OrderDetailsScreen(order: o),
                        ),
                      );
                    },
                    cs: cs,
                    isAr: isAr,
                  );
                },
              ),
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  final bool isAr;
  const _EmptyOrders({required this.isAr});

  @override
  Widget build(BuildContext context) {
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
          Icon(Icons.receipt_long, color: cs.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isAr ? 'لا يوجد طلبات حتى الآن.' : 'No orders yet.',
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final RestaurantOrder order;
  final VoidCallback onTap;
  final ColorScheme cs;
  final bool isAr;

  const _OrderCard({
    required this.order,
    required this.onTap,
    required this.cs,
    required this.isAr,
  });

  @override
  Widget build(BuildContext context) {
    final chevron = isAr ? Icons.chevron_left : Icons.chevron_right;

    final typeText = order.type.label(context);
    final paymentText = order.paymentMethod.label(context);

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      (isAr ? 'رقم الطلب: ' : 'Order: ') + order.shortId,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                  _StatusChip(status: order.status, cs: cs),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                (isAr ? 'الفرع: ' : 'Branch: ') +
                    order.branchSnapshot.nameFor(context),
                style: TextStyle(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 6),
              Text(
                (isAr ? 'النوع: ' : 'Type: ') + typeText,
                style: TextStyle(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 6),
              Text(
                (isAr ? 'الدفع: ' : 'Payment: ') + paymentText,
                style: TextStyle(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    (isAr ? 'الإجمالي: ' : 'Total: ') +
                        '${order.total.toStringAsFixed(2)} د.أ',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const Spacer(),
                  Icon(chevron, color: cs.onSurfaceVariant),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final OrderStatus status;
  final ColorScheme cs;

  const _StatusChip({required this.status, required this.cs});

  @override
  Widget build(BuildContext context) {
    final label = status.label(context);

    Color bg;
    Color fg;

    switch (status) {
      case OrderStatus.pending:
        bg = cs.primary.withOpacity(0.12);
        fg = cs.primary;
        break;
      case OrderStatus.preparing:
        bg = Colors.orange.withOpacity(0.14);
        fg = Colors.orange;
        break;
      case OrderStatus.accepted:
        bg = Colors.blue.withOpacity(0.14);
        fg = Colors.blue;
        break;
      case OrderStatus.outForDelivery:
        bg = Colors.purple.withOpacity(0.14);
        fg = Colors.purple;
        break;
      case OrderStatus.completed:
        bg = Colors.green.withOpacity(0.14);
        fg = Colors.green;
        break;
      case OrderStatus.canceled:
        bg = cs.error.withOpacity(0.12);
        fg = cs.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}
