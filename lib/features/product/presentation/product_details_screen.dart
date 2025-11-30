import 'package:flutter/material.dart';
import 'package:restaurant_customer_app/l10n/l10n_ext.dart';

import 'package:restaurant_customer_app/design_system/motion.dart';
import 'package:restaurant_customer_app/features/cart/models/cart_models.dart';
import 'package:restaurant_customer_app/features/cart/presentation/cart_bottom_sheet.dart';
import 'package:restaurant_customer_app/features/menu/models/menu_models.dart';

class ProductDetailsBottomSheet extends StatefulWidget {
  final MenuItem initialItem;
  final List<MenuItem> allItems;
  final ValueNotifier<List<CartLineItem>> cart;
  final VoidCallback onClose;

  const ProductDetailsBottomSheet({
    super.key,
    required this.initialItem,
    required this.allItems,
    required this.cart,
    required this.onClose,
  });

  static Future<void> show({
    required BuildContext context,
    required TickerProvider vsync,
    required MenuItem item,
    required List<MenuItem> allItems,
    required ValueNotifier<List<CartLineItem>> cart,
  }) {
    final nav = Navigator.of(context, rootNavigator: true);

    return nav.push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => ProductDetailsBottomSheet(
          initialItem: item,
          allItems: allItems,
          cart: cart,
          onClose: () => nav.pop(),
        ),
      ),
    );
  }

  @override
  State<ProductDetailsBottomSheet> createState() =>
      _ProductDetailsBottomSheetState();
}

class _ProductDetailsBottomSheetState extends State<ProductDetailsBottomSheet>
    with TickerProviderStateMixin {
  late MenuItem _item;
  int _qty = 1;
  bool _openingCart = false;

  @override
  void initState() {
    super.initState();
    _item = widget.initialItem;
  }

  void _addToCart(MenuItem p, int qty) {
    final items = List<CartLineItem>.from(widget.cart.value);
    final idx = items.indexWhere((e) => e.id == p.id);

    if (idx == -1) {
      items.add(
        CartLineItem(
          id: p.id,
          title: p.nameFor(context),
          unitPrice: p.price,
          qty: qty,
        ),
      );
    } else {
      items[idx] = items[idx].copyWith(qty: items[idx].qty + qty);
    }
    widget.cart.value = items;
  }

  void _inc(String id) {
    final items = List<CartLineItem>.from(widget.cart.value);
    final idx = items.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    items[idx] = items[idx].copyWith(qty: items[idx].qty + 1);
    widget.cart.value = items;
  }

  void _dec(String id) {
    final items = List<CartLineItem>.from(widget.cart.value);
    final idx = items.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    final next = items[idx].qty - 1;
    if (next <= 0) {
      items.removeAt(idx);
    } else {
      items[idx] = items[idx].copyWith(qty: next);
    }
    widget.cart.value = items;
  }

  void _remove(String id) {
    final items = List<CartLineItem>.from(widget.cart.value);
    items.removeWhere((e) => e.id == id);
    widget.cart.value = items;
  }

  int _cartCount(List<CartLineItem> items) =>
      items.fold<int>(0, (s, it) => s + it.qty);

  void _openCart() {
    if (_openingCart) return;
    _openingCart = true;

    final rootNav = Navigator.of(context, rootNavigator: true);

    CartBottomSheet.show(
      context: rootNav.context,
      vsync: this,
      items: widget.cart,
      onInc: _inc,
      onDec: _dec,
      onRemove: _remove,
      onClearIfEmpty: () {},
    ).whenComplete(() {
      _openingCart = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;

    final desc = _item.descFor(context);
    final alsoLike = widget.allItems
        .where((x) => x.id != _item.id && x.categoryId == _item.categoryId)
        .take(10)
        .toList();

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            widget.onClose();
          },
          icon: const Icon(Icons.close),
        ),
        titleSpacing: 0,
        title: Text(
          _item.nameFor(context),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w900),
        ),
        actions: [
          ValueListenableBuilder<List<CartLineItem>>(
            valueListenable: widget.cart,
            builder: (context, items, _) {
              final count = _cartCount(items);
              return Stack(
                children: [
                  IconButton(
                    onPressed: _openCart,
                    icon: const Icon(Icons.shopping_bag_outlined),
                  ),
                  if (count > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: cs.primary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
            children: [
              Hero(
                tag: 'product_image_${_item.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: _MenuImage(item: _item),
                ),
              ),
              const SizedBox(height: 14),
              if (desc.isNotEmpty)
                Text(
                  desc,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Text(
                      '${_item.price.toStringAsFixed(2)} د.أ',
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed:
                              _qty > 1 ? () => setState(() => _qty--) : null,
                          icon: const Icon(Icons.remove),
                        ),
                        AnimatedSwitcher(
                          duration: AppMotion.micro,
                          child: Text(
                            '$_qty',
                            key: ValueKey(_qty),
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: () => setState(() => _qty++),
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (alsoLike.isNotEmpty) ...[
                const SizedBox(height: 18),
                Text(
                  l10n.youMayAlsoLike,
                  style:
                      Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 170,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: alsoLike.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      final it = alsoLike[i];
                      return _AlsoLikeCard(
                        item: it,
                        onTap: () {
                          setState(() {
                            _item = it;
                            _qty = 1;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
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
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: AppMotion.micro,
                        child: Text(
                          '${(_item.price * _qty).toStringAsFixed(2)} د.أ',
key: ValueKey('${_item.id}_$_qty'),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      height: 54,
                      child: FilledButton.icon(
                        onPressed: () {
                          _addToCart(_item, _qty);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.addedToCart),
                              duration:
                                  const Duration(milliseconds: 900),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_shopping_cart),
                        label: Text(
                          l10n.addToCart,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
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
      ),
    );
  }
}

class _MenuImage extends StatelessWidget {
  final MenuItem item;
  const _MenuImage({required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (item.imageUrl.trim().isNotEmpty) {
      return Image.network(
        item.imageUrl,
        height: 240,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(cs),
      );
    }
    return _placeholder(cs);
  }

  Widget _placeholder(ColorScheme cs) {
    return Container(
      height: 240,
      width: double.infinity,
      color: cs.surfaceContainerHighest,
      child: Icon(
        Icons.fastfood,
        color: cs.primary,
        size: 56,
      ),
    );
  }
}

class _AlsoLikeCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onTap;

  const _AlsoLikeCard({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      width: 160,
      child: Material(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: cs.outlineVariant),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _ThumbImage(item: item),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  item.nameFor(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.price.toStringAsFixed(2)} د.أ',
                  style: TextStyle(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ThumbImage extends StatelessWidget {
  final MenuItem item;
  const _ThumbImage({required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (item.imageUrl.trim().isNotEmpty) {
      return Image.network(
        item.imageUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(cs),
      );
    }
    return _placeholder(cs);
  }

  Widget _placeholder(ColorScheme cs) {
    return Container(
      width: double.infinity,
      color: cs.surfaceContainerHighest,
      child: Icon(
        Icons.fastfood,
        color: cs.primary,
        size: 40,
      ),
    );
  }
}