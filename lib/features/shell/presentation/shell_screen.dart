import 'package:flutter/material.dart';
import 'package:restaurant_customer_app/app/app_state.dart';
import 'package:restaurant_customer_app/features/home/presentation/home_screen.dart';
import 'package:restaurant_customer_app/features/orders/presentation/orders_screen.dart';

class ShellScreen extends StatelessWidget {
  const ShellScreen({super.key});

  String _t(BuildContext context, String en, String ar) {
    return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
  }

  @override
  Widget build(BuildContext context) {
    final app = AppStateScope.of(context);
    final index = app.shellTabIndex;

    final pages = <Widget>[
      HomeScreenReact(
        brightness: Theme.of(context).brightness,
        languageCode: Localizations.localeOf(context).languageCode,
        onOrdersClick: () => app.setTab(1),
      ),
      const OrdersScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: index,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: app.setTab,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: _t(context, 'Home', 'الرئيسية'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: _t(context, 'Orders', 'طلباتي'),
          ),
        ],
      ),
    );
  }
}