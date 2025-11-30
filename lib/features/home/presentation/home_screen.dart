import 'dart:math' as math;
import 'package:flutter/material.dart';

class HomeScreenReact extends StatefulWidget {
  final Brightness brightness;
  final String languageCode;

  final VoidCallback? onProductClick;
  final VoidCallback? onCartClick;
  final VoidCallback? onOrdersClick;

  const HomeScreenReact({
    super.key,
    this.brightness = Brightness.light,
    this.languageCode = 'en',
    this.onProductClick,
    this.onCartClick,
    this.onOrdersClick,
  });

  @override
  State<HomeScreenReact> createState() => _HomeScreenReactState();
}

class _HomeScreenReactState extends State<HomeScreenReact>
    with SingleTickerProviderStateMixin {
  String _selectedCategory = 'all';
  int _cartItems = 2;
  double _cartTotal = 85.00;

  late final AnimationController _gridCtrl;

  bool get _isAr => widget.languageCode.toLowerCase() == 'ar';
  TextDirection get _dir => _isAr ? TextDirection.rtl : TextDirection.ltr;
  bool get _isDark => widget.brightness == Brightness.dark;
  String _t(String en, String ar) => _isAr ? ar : en;

  final _searchCtrl = TextEditingController();

  final List<_Category> _categories = const [
    _Category(id: 'all', en: 'All', ar: 'الكل'),
    _Category(id: 'burgers', en: 'Burgers', ar: 'برجر'),
    _Category(id: 'pizza', en: 'Pizza', ar: 'بيتزا'),
    _Category(id: 'sandwiches', en: 'Sandwiches', ar: 'ساندويتش'),
    _Category(id: 'drinks', en: 'Drinks', ar: 'مشروبات'),
    _Category(id: 'desserts', en: 'Desserts', ar: 'حلويات'),
  ];

  late final List<_Product> _products = const [
    _Product(
      id: 1,
      categoryId: 'burgers',
      categoryEn: 'Burgers',
      categoryAr: 'برجر',
      nameEn: 'Classic Burger',
      nameAr: 'برجر كلاسيك',
      descEn: 'Delicious burger with lettuce, tomato and special sauce',
      descAr: 'برجر لذيذ مع الخس والطماطم والصوص الخاص',
      price: 25.00,
    ),
    _Product(
      id: 2,
      categoryId: 'pizza',
      categoryEn: 'Pizza',
      categoryAr: 'بيتزا',
      nameEn: 'Cheese Pizza',
      nameAr: 'بيتزا الجبن',
      descEn: 'Classic pizza with mozzarella cheese and tomato sauce',
      descAr: 'بيتزا كلاسيكية مع جبن الموزاريلا وصلصة الطماطم',
      price: 45.00,
    ),
    _Product(
      id: 3,
      categoryId: 'sandwiches',
      categoryEn: 'Sandwiches',
      categoryAr: 'ساندويتش',
      nameEn: 'Chicken Sandwich',
      nameAr: 'ساندويتش دجاج',
      descEn: 'Grilled chicken breast with fresh vegetables',
      descAr: 'صدر دجاج مشوي مع الخضار الطازجة',
      price: 30.00,
    ),
    _Product(
      id: 4,
      categoryId: 'burgers',
      categoryEn: 'Burgers',
      categoryAr: 'برجر',
      nameEn: 'Double Burger',
      nameAr: 'برجر مضاعف',
      descEn: 'Two beef patties with cheese and special sauce',
      descAr: 'قطعتان من اللحم مع الجبن والصوص الخاص',
      price: 35.00,
    ),
    _Product(
      id: 5,
      categoryId: 'pizza',
      categoryEn: 'Pizza',
      categoryAr: 'بيتزا',
      nameEn: 'Pepperoni Pizza',
      nameAr: 'بيتزا بيبروني',
      descEn: 'Pizza topped with pepperoni and mozzarella',
      descAr: 'بيتزا مغطاة بالبيبروني والموزاريلا',
      price: 50.00,
    ),
    _Product(
      id: 6,
      categoryId: 'drinks',
      categoryEn: 'Drinks',
      categoryAr: 'مشروبات',
      nameEn: 'Fresh Juice',
      nameAr: 'عصير طازج',
      descEn: 'Freshly squeezed orange juice',
      descAr: 'عصير برتقال طازج',
      price: 15.00,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _gridCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _searchCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _gridCtrl.dispose();
    super.dispose();
  }

  void _addToCart(_Product p) {
    setState(() {
      _cartItems += 1;
      _cartTotal += p.price;
    });
  }

  void _setCategory(String id) {
    setState(() {
      _selectedCategory = id;
      _gridCtrl
        ..reset()
        ..forward();
    });
  }

  bool _matches(_Product p, String q) {
    if (q.trim().isEmpty) return true;
    final qq = q.trim().toLowerCase();
    final name = (_isAr ? p.nameAr : p.nameEn).toLowerCase();
    final desc = (_isAr ? p.descAr : p.descEn).toLowerCase();
    final cat = (_isAr ? p.categoryAr : p.categoryEn).toLowerCase();
    return name.contains(qq) || desc.contains(qq) || cat.contains(qq);
  }

  @override
  Widget build(BuildContext context) {
    final cs = ColorScheme.fromSeed(
      seedColor: const Color(0xFFDC2626),
      brightness: widget.brightness,
    );

    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      scaffoldBackgroundColor:
          _isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF7F7F7),
      appBarTheme: AppBarTheme(
        backgroundColor: _isDark ? const Color(0xFF0F0F10) : Colors.white,
        foregroundColor: _isDark ? Colors.white : const Color(0xFF111111),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    );

    final bg = _isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF7F7F7);
    final card = _isDark ? const Color(0xFF141416) : Colors.white;
    final border = _isDark ? const Color(0xFF2A2A2E) : const Color(0xFFE6E6E9);
    final text = _isDark ? Colors.white : const Color(0xFF121214);
    final muted = _isDark ? const Color(0xFFA3A3AA) : const Color(0xFF616169);

    final q = _searchCtrl.text;
    final filteredProducts = (_selectedCategory == 'all'
            ? _products
            : _products.where((p) => p.categoryId == _selectedCategory))
        .where((p) => _matches(p, q))
        .toList();

    return Theme(
      data: theme,
      child: Directionality(
        textDirection: _dir,
        child: Scaffold(
          backgroundColor: bg,
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                      decoration: BoxDecoration(
                        color: card,
                        border: Border(bottom: BorderSide(color: border)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: _isAr
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: _isAr
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _t('Hello, Ahmed', 'أهلاً، أحمد'),
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: text,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _t(
                                    'Ready to order your favorite meal?',
                                    'جاهز نجهزلك طلبك؟',
                                  ),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          _BranchCard(
                            isAr: _isAr,
                            isDark: _isDark,
                            card: card,
                            border: border,
                            text: text,
                            muted: muted,
                            onTap: () {},
                          ),
                          const SizedBox(height: 12),
                          _SearchBar(
                            isAr: _isAr,
                            isDark: _isDark,
                            border: border,
                            text: text,
                            muted: muted,
                            controller: _searchCtrl,
                            onFilterTap: () {},
                            onClear: () {
                              _searchCtrl.clear();
                              FocusScope.of(context).unfocus();
                            },
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 44,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              reverse: _isAr,
                              itemCount: _categories.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 10),
                              itemBuilder: (context, index) {
                                final c = _categories[index];
                                final selected = _selectedCategory == c.id;
                                return _CategoryChip(
                                  label: _isAr ? c.ar : c.en,
                                  selected: selected,
                                  isDark: _isDark,
                                  onTap: () => _setCategory(c.id),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
                        child: filteredProducts.isEmpty
                            ? _EmptyResults(
                                q: q,
                                isAr: _isAr,
                                card: card,
                                border: border,
                                muted: muted,
                                text: text,
                              )
                            : GridView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: filteredProducts.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 14,
                                  crossAxisSpacing: 14,
                                  childAspectRatio: 0.72,
                                ),
                                itemBuilder: (context, index) {
                                  final p = filteredProducts[index];
                                  final start = (index * 0.05).clamp(0.0, 0.6);
                                  final end =
                                      (start + 0.45).clamp(0.0, 1.0);
                                  final anim = CurvedAnimation(
                                    parent: _gridCtrl,
                                    curve: Interval(
                                      start,
                                      end,
                                      curve: Curves.easeOutCubic,
                                    ),
                                  );

                                  return FadeTransition(
                                    opacity: anim,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0, 0.08),
                                        end: Offset.zero,
                                      ).animate(anim),
                                      child: _ProductCard(
                                        isAr: _isAr,
                                        isDark: _isDark,
                                        card: card,
                                        border: border,
                                        text: text,
                                        muted: muted,
                                        product: p,
                                        onTap: () => widget.onProductClick?.call(),
                                        onAdd: () => _addToCart(p),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 86,
                  child: _CartBar(
                    isAr: _isAr,
                    isDark: _isDark,
                    border: border,
                    text: text,
                    muted: muted,
                    cartItems: _cartItems,
                    cartTotal: _cartTotal,
                    onTap: () => widget.onCartClick?.call(),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _BottomNav(
                    isAr: _isAr,
                    isDark: _isDark,
                    border: border,
                    muted: muted,
                    onOrdersTap: () => widget.onOrdersClick?.call(),
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

class _BranchCard extends StatelessWidget {
  final bool isAr;
  final bool isDark;
  final Color card;
  final Color border;
  final Color text;
  final Color muted;
  final VoidCallback onTap;

  const _BranchCard({
    required this.isAr,
    required this.isDark,
    required this.card,
    required this.border,
    required this.text,
    required this.muted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgIcon = isDark ? const Color(0xFF2A2A2E) : const Color(0xFFFFEBEE);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          child: Row(
            textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: bgIcon,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: Color(0xFFDC2626),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAr ? 'الفرع الحالي' : 'Current Branch',
                      style: TextStyle(
                        fontSize: 12,
                        color: muted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isAr ? 'فرع الرياض' : 'Riyadh Branch',
                      style: TextStyle(
                        fontSize: 13,
                        color: text,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Transform.rotate(
                angle: isAr ? math.pi : 0,
                child: Icon(Icons.chevron_right, color: muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final bool isAr;
  final bool isDark;
  final Color border;
  final Color text;
  final Color muted;
  final TextEditingController controller;
  final VoidCallback onFilterTap;
  final VoidCallback onClear;

  const _SearchBar({
    required this.isAr,
    required this.isDark,
    required this.border,
    required this.text,
    required this.muted,
    required this.controller,
    required this.onFilterTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final fill = isDark ? const Color(0xFF141416) : Colors.white;
    final hasText = controller.text.trim().isNotEmpty;

    return Stack(
      children: [
        TextField(
          controller: controller,
          textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
          style: TextStyle(color: text, fontWeight: FontWeight.w700),
          decoration: InputDecoration(
            filled: true,
            fillColor: fill,
            hintText: isAr ? 'ابحث عن منتج...' : 'Search for a product...',
            hintStyle: TextStyle(color: muted, fontWeight: FontWeight.w600),
            contentPadding: EdgeInsetsDirectional.only(
              start: isAr ? 52 : 44,
              end: isAr ? 44 : 52,
              top: 14,
              bottom: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: Color(0xFFDC2626), width: 1.6),
            ),
          ),
        ),
        PositionedDirectional(
          start: isAr ? null : 14,
          end: isAr ? 14 : null,
          top: 0,
          bottom: 0,
          child: Icon(Icons.search, color: muted),
        ),
        PositionedDirectional(
          end: isAr ? null : 8,
          start: isAr ? 8 : null,
          top: 0,
          bottom: 0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasText)
                IconButton(
                  onPressed: onClear,
                  icon: Icon(Icons.close, color: muted),
                  splashRadius: 22,
                )
              else
                const SizedBox(width: 4),
              IconButton(
                onPressed: onFilterTap,
                icon: Icon(Icons.tune, color: muted),
                splashRadius: 22,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? const Color(0xFFDC2626)
        : (isDark ? const Color(0xFF2A2A2E) : const Color(0xFFF0F0F2));
    final fg = selected
        ? Colors.white
        : (isDark ? const Color(0xFFD1D1D7) : const Color(0xFF45454D));

    return AnimatedScale(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      scale: selected ? 1.0 : 0.99,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Text(
              label,
              style: TextStyle(
                color: fg,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final bool isAr;
  final bool isDark;
  final Color card;
  final Color border;
  final Color text;
  final Color muted;

  final _Product product;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  const _ProductCard({
    required this.isAr,
    required this.isDark,
    required this.card,
    required this.border,
    required this.text,
    required this.muted,
    required this.product,
    required this.onTap,
    required this.onAdd,
  });

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _pressed = false;

  String get _emoji {
    switch (widget.product.categoryId) {
      case 'burgers':
        return '🍔';
      case 'pizza':
        return '🍕';
      case 'sandwiches':
        return '🥪';
      case 'drinks':
        return '🥤';
      case 'desserts':
        return '🍰';
      default:
        return '🍽️';
    }
  }

  Future<void> _tapAdd() async {
    if (_pressed) return;
    setState(() => _pressed = true);
    widget.onAdd();
    await Future.delayed(const Duration(milliseconds: 120));
    if (!mounted) return;
    setState(() => _pressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            color: widget.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: widget.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(widget.isDark ? 0.25 : 0.06),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(18)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: widget.isDark
                          ? const [Color(0xFF2B2B30), Color(0xFF1E1E22)]
                          : const [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(_emoji, style: const TextStyle(fontSize: 46)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: widget.isAr
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: widget.isDark
                            ? const Color(0xFF2A2A2E)
                            : const Color(0xFFF0F0F2),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        widget.isAr ? p.categoryAr : p.categoryEn,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: widget.isDark
                              ? const Color(0xFFD1D1D7)
                              : const Color(0xFF66666F),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.isAr ? p.nameAr : p.nameEn,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: widget.text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.isAr ? p.descAr : p.descEn,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                        color: widget.muted,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      textDirection:
                          widget.isAr ? TextDirection.rtl : TextDirection.ltr,
                      children: [
                        Text(
                          widget.isAr
                              ? '${p.price.toStringAsFixed(2)} ر.س'
                              : 'SAR ${p.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Color(0xFFDC2626),
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                        const Spacer(),
                        AnimatedScale(
                          duration: const Duration(milliseconds: 120),
                          curve: Curves.easeOut,
                          scale: _pressed ? 0.9 : 1.0,
                          child: Material(
                            color: const Color(0xFFDC2626),
                            borderRadius: BorderRadius.circular(999),
                            child: InkWell(
                              onTap: _tapAdd,
                              borderRadius: BorderRadius.circular(999),
                              child: const SizedBox(
                                width: 30,
                                height: 30,
                                child: Icon(
                                  Icons.add,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartBar extends StatelessWidget {
  final bool isAr;
  final bool isDark;
  final Color border;
  final Color text;
  final Color muted;

  final int cartItems;
  final double cartTotal;
  final VoidCallback onTap;

  const _CartBar({
    required this.isAr,
    required this.isDark,
    required this.border,
    required this.text,
    required this.muted,
    required this.cartItems,
    required this.cartTotal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final visible = cartItems > 0;

    return AnimatedSlide(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutBack,
      offset: visible ? Offset.zero : const Offset(0, 1.2),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: visible ? 1 : 0,
        child: Material(
          color: isDark ? const Color(0xFF141416) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          elevation: 14,
          child: InkWell(
            onTap: visible ? onTap : null,
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: border),
              ),
              child: Row(
                textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAr ? '$cartItems منتج' : '$cartItems items',
                          style: TextStyle(
                            color: text,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          isAr
                              ? '${cartTotal.toStringAsFixed(2)} ر.س'
                              : 'SAR ${cartTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Color(0xFFDC2626),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                      children: [
                        Text(
                          isAr ? 'عرض السلة' : 'View Cart',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Transform.rotate(
                          angle: isAr ? math.pi : 0,
                          child: const Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final bool isAr;
  final bool isDark;
  final Color border;
  final Color muted;
  final VoidCallback onOrdersTap;

  const _BottomNav({
    required this.isAr,
    required this.isDark,
    required this.border,
    required this.muted,
    required this.onOrdersTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141416) : Colors.white,
        border: Border(top: BorderSide(color: border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _NavItem(
              isActive: true,
              icon: Icons.home_filled,
              label: isAr ? 'الرئيسية' : 'Home',
              activeColor: const Color(0xFFDC2626),
              inactiveColor: muted,
              onTap: () {},
            ),
          ),
          Expanded(
            child: _NavItem(
              isActive: false,
              icon: Icons.shopping_bag_outlined,
              label: isAr ? 'طلباتي' : 'My Orders',
              activeColor: const Color(0xFFDC2626),
              inactiveColor: muted,
              onTap: onOrdersTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final bool isActive;
  final IconData icon;
  final String label;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.isActive,
    required this.icon,
    required this.label,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = isActive ? activeColor : inactiveColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: c, size: 26),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: c,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  final String q;
  final bool isAr;
  final Color card;
  final Color border;
  final Color muted;
  final Color text;

  const _EmptyResults({
    required this.q,
    required this.isAr,
    required this.card,
    required this.border,
    required this.muted,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final title = q.trim().isEmpty
        ? (isAr ? 'ما في عناصر حالياً.' : 'No items yet.')
        : (isAr ? 'لا يوجد نتائج لـ "$q".' : 'No results for "$q".');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Icon(Icons.search_off, color: muted),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: text, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _Category {
  final String id;
  final String en;
  final String ar;
  const _Category({required this.id, required this.en, required this.ar});
}

class _Product {
  final int id;
  final String categoryId;
  final String categoryEn;
  final String categoryAr;
  final String nameEn;
  final String nameAr;
  final String descEn;
  final String descAr;
  final double price;

  const _Product({
    required this.id,
    required this.categoryId,
    required this.categoryEn,
    required this.categoryAr,
    required this.nameEn,
    required this.nameAr,
    required this.descEn,
    required this.descAr,
    required this.price,
  });
}
