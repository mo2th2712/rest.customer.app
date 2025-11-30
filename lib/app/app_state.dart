import 'dart:async';
import 'package:flutter/material.dart';

import 'package:restaurant_customer_app/features/branch/models/branch_models.dart';
import 'package:restaurant_customer_app/features/orders/models/order_models.dart';

class AppState extends ChangeNotifier {
  Branch _branch;
  final List<RestaurantOrder> _orders = [];

  int _shellTabIndex = 0;
  int get shellTabIndex => _shellTabIndex;

  void setTab(int index) {
    if (index == _shellTabIndex) return;
    if (index < 0) return;
    _shellTabIndex = index;
    notifyListeners();
  }

  final Map<String, List<Timer>> _orderTimers = {};

  AppState({required Branch initialBranch}) : _branch = initialBranch;

  Branch get branch => _branch;

  // رجّعنا الليست نفسها عشان تقدر تنضاف وتتعدل بدون ما يطلع خطأ
  List<RestaurantOrder> get orders => _orders;

  void setBranch(Branch b) {
    if (b.id == _branch.id) return;
    _branch = b;
    notifyListeners();
  }

  void addOrder(RestaurantOrder order) {
    _orders.insert(0, order);
    notifyListeners();
  }

  RestaurantOrder? getOrderById(String id) {
    final idx = _orders.indexWhere((o) => o.id == id);
    if (idx == -1) return null;
    return _orders[idx];
  }

  void setOrderStatus(String orderId, OrderStatus status) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx == -1) return;

    final current = _orders[idx];

    if (current.status == OrderStatus.completed ||
        current.status == OrderStatus.canceled) return;
    if (current.status == status) return;

    _orders[idx] = RestaurantOrder(
      id: current.id,
      createdAt: current.createdAt,
      branchSnapshot: current.branchSnapshot,
      type: current.type,
      paymentMethod: current.paymentMethod,
      lines: current.lines,
      deliveryFee: current.deliveryFee,
      status: status,
      deliveryAddress: current.deliveryAddress,
      deliveryLat: current.deliveryLat,
      deliveryLng: current.deliveryLng,
      notes: current.notes,
      promoCode: current.promoCode,
      discountAmount: current.discountAmount,
      scheduledFor: current.scheduledFor,
    );

    notifyListeners();
  }

  void cancelOrder(String orderId) {
    _cancelDemoProgress(orderId);
    setOrderStatus(orderId, OrderStatus.canceled);
  }

  void startDemoProgressFor(String orderId) {
    _cancelDemoProgress(orderId);

    final order = getOrderById(orderId);
    if (order == null) return;

    if (order.status == OrderStatus.completed ||
        order.status == OrderStatus.canceled) return;

    final steps = <_DemoStep>[
      _DemoStep(const Duration(seconds: 2), OrderStatus.preparing),
      _DemoStep(const Duration(seconds: 6), OrderStatus.accepted),
      if (order.isDelivery)
        _DemoStep(const Duration(seconds: 10), OrderStatus.outForDelivery),
      _DemoStep(
        order.isDelivery
            ? const Duration(seconds: 16)
            : const Duration(seconds: 12),
        OrderStatus.completed,
      ),
    ];

    _orderTimers[orderId] = steps
        .map(
          (s) => Timer(
            s.delay,
            () => setOrderStatus(orderId, s.status),
          ),
        )
        .toList();
  }

  void _cancelDemoProgress(String orderId) {
    final timers = _orderTimers.remove(orderId);
    if (timers == null) return;
    for (final t in timers) {
      t.cancel();
    }
  }

  @override
  void dispose() {
    for (final timers in _orderTimers.values) {
      for (final t in timers) {
        t.cancel();
      }
    }
    _orderTimers.clear();
    super.dispose();
  }
}

class _DemoStep {
  final Duration delay;
  final OrderStatus status;
  const _DemoStep(this.delay, this.status);
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState state,
    required Widget child,
  }) : super(notifier: state, child: child);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    final state = scope?.notifier;
    if (state == null) {
      throw FlutterError(
        'AppStateScope not found. Wrap your app with AppStateScope.',
      );
    }
    return state;
  }
}
