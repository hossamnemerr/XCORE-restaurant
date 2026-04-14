import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/customize_sheet.dart';

// ─────────────────────────────────────────────
//  DATA MODELS
// ─────────────────────────────────────────────

class MenuCategory {
  final String id;
  final String label;
  final IconData icon;
  const MenuCategory({required this.id, required this.label, required this.icon});
}

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryId;
  final List<String> chips;
  final bool isFeatured;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    this.chips = const [],
    this.isFeatured = false,
  });
}

// ─────────────────────────────────────────────
//  STATIC DATA  — fast food menu
// ─────────────────────────────────────────────

const List<MenuCategory> kCategories = [
  MenuCategory(id: 'all',      label: 'الكل',      icon: Icons.grid_view_rounded),
  MenuCategory(id: 'shawarma', label: 'شاورما',    icon: Icons.kebab_dining_rounded),
  MenuCategory(id: 'broast',   label: 'بروست',     icon: Icons.set_meal_rounded),
  MenuCategory(id: 'burgers',  label: 'برجر',      icon: Icons.lunch_dining_rounded),
  MenuCategory(id: 'juices',   label: 'عصائر',     icon: Icons.local_drink_rounded),
  MenuCategory(id: 'sides',    label: 'إضافات',    icon: Icons.grain_rounded),
  MenuCategory(id: 'desserts', label: 'حلويات',    icon: Icons.icecream_rounded),
];

const List<MenuItem> kMenuItems = [
  // ── Featured ───────────────────────────────
  MenuItem(
    id: 'shawarma_special',
    name: 'شاورما سبيشال',
    description: 'شاورما دجاج مع صوص الثوم، المخلل، والبطاطس المقلية داخل الخبز.',
    price: 25.00,
    imageUrl: 'https://images.unsplash.com/photo-1599487489-0c7d3b2cf19d?w=800&q=80',
    categoryId: 'shawarma',
    chips: ['الأكثر طلباً', 'جديد'],
    isFeatured: true,
  ),
  // ── Shawarma ────────────────────────────────
  MenuItem(
    id: 'shawarma_chicken',
    name: 'شاورما دجاج',
    description: 'دجاج مشوي متبل بالبهارات مع صوص طحينة وخضار.',
    price: 22.00,
    imageUrl: 'https://images.unsplash.com/photo-1561043433-9265f73e685f?w=400&q=80',
    categoryId: 'shawarma',
    chips: ['كلاسيك'],
  ),
  MenuItem(
    id: 'shawarma_meat',
    name: 'شاورما لحم',
    description: 'لحم عجل مشوي مع صوص الثوم والبصل المكرمل.',
    price: 28.00,
    imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400&q=80',
    categoryId: 'shawarma',
    chips: ['مميز'],
  ),
  // ── Broast ──────────────────────────────────
  MenuItem(
    id: 'broast_half',
    name: 'بروست نص دجاجة',
    description: 'نصف دجاجة مقلية بعجينة مقرمشة مع بطاطس وصوص.',
    price: 35.00,
    imageUrl: 'https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58?w=400&q=80',
    categoryId: 'broast',
    chips: ['مقرمش'],
  ),
  MenuItem(
    id: 'broast_pieces',
    name: '6 قطع بروست',
    description: 'ست قطع دجاج بعجينة هشة مع صوص الثوم.',
    price: 30.00,
    imageUrl: 'https://images.unsplash.com/photo-1562967914-608f82629710?w=400&q=80',
    categoryId: 'broast',
    chips: ['عائلي'],
  ),
  // ── Burgers ─────────────────────────────────
  MenuItem(
    id: 'burger_smash',
    name: 'سماش برجر',
    description: 'ضلعان لحم بقري مسطح مع جبنة شيدر وصوص خاص.',
    price: 32.00,
    imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&q=80',
    categoryId: 'burgers',
    chips: ['سيف الشيف'],
  ),
  MenuItem(
    id: 'burger_crispy',
    name: 'كريسبي برجر',
    description: 'فيليه دجاج مقرمش مع كول سلو وخيار مخلل.',
    price: 28.00,
    imageUrl: 'https://images.unsplash.com/photo-1606755962773-d324e0a13086?w=400&q=80',
    categoryId: 'burgers',
    chips: ['مقرمش'],
  ),
  // ── Juices ──────────────────────────────────
  MenuItem(
    id: 'juice_mango',
    name: 'عصير مانجو طازج',
    description: 'مانجو طازجة مخفوقة بالثلج.',
    price: 12.00,
    imageUrl: 'https://images.unsplash.com/photo-1623065422902-30a2d299bbe4?w=400&q=80',
    categoryId: 'juices',
    chips: ['طازج'],
  ),
  MenuItem(
    id: 'juice_lemon',
    name: 'ليمون بالنعناع',
    description: 'ليمون حامض مع نعناع طازج وشراب الصمغ.',
    price: 10.00,
    imageUrl: 'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=400&q=80',
    categoryId: 'juices',
    chips: ['منعش'],
  ),
  MenuItem(
    id: 'juice_avocado',
    name: 'موهيتو أفوكادو',
    description: 'أفوكادو كريمي مع الليمون والنعناع.',
    price: 15.00,
    imageUrl: 'https://images.unsplash.com/photo-1638176066959-22f5a0dc1b87?w=400&q=80',
    categoryId: 'juices',
    chips: ['مميز'],
  ),
  // ── Sides ───────────────────────────────────
  MenuItem(
    id: 'side_fries',
    name: 'بطاطس محمرة',
    description: 'بطاطس مقلية مقرمشة مع ملح البحر.',
    price: 8.00,
    imageUrl: 'https://images.unsplash.com/photo-1541592106381-b31e9677c0e5?w=400&q=80',
    categoryId: 'sides',
    chips: ['كلاسيك'],
  ),
  MenuItem(
    id: 'side_coleslaw',
    name: 'كول سلو',
    description: 'سلطة ملفوف كريمية خفيفة.',
    price: 7.00,
    imageUrl: 'https://images.unsplash.com/photo-1625938146419-bca35e98b5fc?w=400&q=80',
    categoryId: 'sides',
  ),
  // ── Desserts ────────────────────────────────
  MenuItem(
    id: 'dessert_kunafa',
    name: 'كنافة بالقشطة',
    description: 'كنافة ناعمة بالقشطة وعسل القطر.',
    price: 18.00,
    imageUrl: 'https://images.unsplash.com/photo-1598110750624-2b8b7e9b8a59?w=400&q=80',
    categoryId: 'desserts',
    chips: ['محبوب'],
  ),
  MenuItem(
    id: 'dessert_icecream',
    name: 'آيس كريم سوفتي',
    description: 'آيس كريم فانيلا ناعم مع صوص الشوكولاتة.',
    price: 10.00,
    imageUrl: 'https://images.unsplash.com/photo-1570197788417-0e82375c9371?w=400&q=80',
    categoryId: 'desserts',
  ),
];

// ─────────────────────────────────────────────
//  SCREEN
// ─────────────────────────────────────────────

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  int _selectedCategoryIdx = 0;

  // Filtered items based on selected category
  List<MenuItem> get _visibleItems {
    final cat = kCategories[_selectedCategoryIdx];
    final nonFeatured = kMenuItems.where((m) => !m.isFeatured);
    if (cat.id == 'all') return nonFeatured.toList();
    return nonFeatured.where((m) => m.categoryId == cat.id).toList();
  }

  // Add button animations — keyed by item id
  final Map<String, AnimationController> _addCtrls = {};
  final Map<String, Animation<double>> _addScales = {};

  @override
  void initState() {
    super.initState();
    // Pre-create controllers for all items
    for (final item in kMenuItems) {
      final c = AnimationController(vsync: this, duration: const Duration(milliseconds: 130));
      _addCtrls[item.id] = c;
      _addScales[item.id] = Tween<double>(begin: 1.0, end: 0.85)
          .animate(CurvedAnimation(parent: c, curve: Curves.easeInOut));
    }
  }

  @override
  void dispose() {
    for (final c in _addCtrls.values) c.dispose();
    super.dispose();
  }

  Future<void> _animateAndAdd(MenuItem item) async {
    HapticFeedback.lightImpact();
    final ctrl = _addCtrls[item.id];
    if (ctrl != null) {
      await ctrl.forward();
      await ctrl.reverse();
    }
    if (!mounted) return;
    // Add to cart directly (1 qty)
    CartProvider.read(context).addItem(CartItem(
      id: item.id,
      name: item.name,
      category: item.categoryId.toUpperCase(),
      detail: item.chips.isNotEmpty ? item.chips.first : '',
      imageUrl: item.imageUrl,
      unitPrice: item.price,
    ));
    // Show snack
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${item.name} أُضيف للطلب',
            style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ));
    }
  }

  // ── BUILD ──────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Listen to cart count for badge
    final cart = CartProvider.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      appBar: _buildAppBar(cart.totalCount),
      body: Stack(children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Categories
            SliverToBoxAdapter(child: _buildCategoryRow()),

            // Featured card (always shown)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: _buildFeaturedCard(kMenuItems.first),
              ),
            ),

            // Section header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  _selectedCategoryIdx == 0
                      ? 'قائمة الطعام كاملة'
                      : kCategories[_selectedCategoryIdx].label,
                  style: GoogleFonts.manrope(
                    fontSize: 10, fontWeight: FontWeight.w700,
                    color: AppColors.onSurfaceVariant, letterSpacing: 1.6,
                  ),
                ),
              ),
            ),

            // Filtered item list
            _visibleItems.isEmpty
                ? SliverToBoxAdapter(child: _buildEmptyState())
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 180),
                    sliver: SliverList.separated(
                      itemCount: _visibleItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 6),
                      itemBuilder: (ctx, i) => _buildMenuItemCard(_visibleItems[i]),
                    ),
                  ),
          ],
        ),

        // Sticky checkout bar
        Positioned(left: 0, right: 0, bottom: 0, child: _buildCheckoutBar(cart.totalCount)),
      ]),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  // ── APPBAR ─────────────────────────────────

  PreferredSizeWidget _buildAppBar(int cartCount) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Row(children: [
        const Icon(Icons.menu, color: Color(0xFF2ECC71), size: 24),
        const SizedBox(width: 12),
        Flexible(child: Text('XCORE',
          style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w900,
              color: const Color(0xFF2ECC71), letterSpacing: 1.0),
          overflow: TextOverflow.ellipsis)),
      ]),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Stack(clipBehavior: Clip.none, children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 24),
              onPressed: () => Navigator.of(context).pushNamed('/orders'),
            ),
            if (cartCount > 0)
              Positioned(
                top: 6, right: 6,
                child: Container(
                  width: 16, height: 16,
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: Center(child: Text('$cartCount',
                    style: GoogleFonts.manrope(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.onPrimary))),
                ),
              ),
          ]),
        ),
        CircleAvatar(radius: 16, backgroundColor: AppColors.surfaceContainerHigh,
            backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=11')),
        IconButton(icon: const Icon(Icons.more_vert, color: AppColors.onSurfaceVariant), onPressed: () {}),
      ],
    );
  }

  // ── CATEGORY CHIPS ─────────────────────────

  Widget _buildCategoryRow() {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: kCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = kCategories[index];
          final isActive = index == _selectedCategoryIdx;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategoryIdx = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: isActive ? AppGradients.primaryCta : null,
                color: isActive ? null : AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(cat.icon, size: 16,
                    color: isActive ? AppColors.onPrimary : AppColors.onSurfaceVariant),
                const SizedBox(width: 8),
                Text(cat.label, style: GoogleFonts.manrope(
                  fontSize: 13, fontWeight: FontWeight.w700,
                  color: isActive ? AppColors.onPrimary : AppColors.onSurface)),
              ]),
            ),
          );
        },
      ),
    );
  }

  // ── FEATURED CARD ──────────────────────────

  Widget _buildFeaturedCard(MenuItem item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: double.infinity, height: 200,
        child: Stack(fit: StackFit.expand, children: [
          Image.network(item.imageUrl, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceContainerHigh)),
          Container(decoration: const BoxDecoration(gradient: LinearGradient(
            begin: Alignment.centerRight, end: Alignment.centerLeft,
            colors: [Color(0x00000000), Color(0xCC000000)], stops: [0.3, 1.0]))),
          Padding(padding: const EdgeInsets.all(20), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(item.name, style: GoogleFonts.manrope(
                  fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white,
                  letterSpacing: -0.44, height: 1.15)),
              const SizedBox(height: 4),
              Text(item.description, style: GoogleFonts.manrope(
                  fontSize: 12, color: Colors.white70),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 12),
              Row(children: [
                Text('\$${item.price.toStringAsFixed(2)}', style: GoogleFonts.manrope(
                    fontSize: 24, fontWeight: FontWeight.w800,
                    color: AppColors.primary, letterSpacing: -0.48)),
                const Spacer(),
                GestureDetector(
                  onTap: () => _animateAndAdd(item),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(gradient: AppGradients.primaryCta,
                        borderRadius: BorderRadius.circular(100)),
                    child: const Icon(Icons.add, color: AppColors.onPrimary, size: 22),
                  ),
                ),
              ]),
            ],
          )),
        ]),
      ),
    );
  }

  // ── MENU ITEM CARD ─────────────────────────

  Widget _buildMenuItemCard(MenuItem item) {
    final scale = _addScales[item.id];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        ClipRRect(borderRadius: BorderRadius.circular(8),
          child: SizedBox(width: 64, height: 64,
            child: Image.network(item.imageUrl, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceContainerHighest,
                child: const Icon(Icons.image_outlined, color: AppColors.outlineVariant))))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(item.name, style: GoogleFonts.manrope(
              fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.15),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 3),
          Text(item.description, style: GoogleFonts.manrope(
              fontSize: 12, color: AppColors.onSurfaceVariant, height: 1.35),
              maxLines: 2, overflow: TextOverflow.ellipsis),
          if (item.chips.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(spacing: 6, runSpacing: 4,
              children: item.chips.map((c) => _StatusChip(label: c)).toList()),
          ],
        ])),
        const SizedBox(width: 12),
        Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('\$${item.price.toStringAsFixed(2)}', style: GoogleFonts.manrope(
              fontSize: 17, fontWeight: FontWeight.w800,
              color: AppColors.primary, letterSpacing: -0.34)),
          const SizedBox(height: 8),
          scale != null
              ? ScaleTransition(scale: scale,
                  child: GestureDetector(onTap: () => _animateAndAdd(item), child: const _AddButton()))
              : GestureDetector(onTap: () => _animateAndAdd(item), child: const _AddButton()),
        ]),
      ]),
    );
  }

  // ── EMPTY STATE ────────────────────────────

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.search_off_rounded, size: 40, color: AppColors.outlineVariant),
        const SizedBox(height: 12),
        Text('لا توجد عناصر في هذا القسم', style: GoogleFonts.manrope(
            fontSize: 13, color: AppColors.onSurfaceVariant)),
      ])),
    );
  }

  // ── CHECKOUT BAR ───────────────────────────

  Widget _buildCheckoutBar(int count) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E).withOpacity(0.95),
            boxShadow: AppShadows.floatingBar,
          ),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('/orders'),
            child: Container(
              width: double.infinity, height: 56,
              decoration: BoxDecoration(
                gradient: AppGradients.primaryCta,
                borderRadius: BorderRadius.circular(12),
                boxShadow: AppShadows.primaryGlow,
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.receipt_long_rounded, color: AppColors.onPrimary, size: 20),
                const SizedBox(width: 10),
                Text(count > 0 ? 'عرض الطلب ($count)' : 'CHECK OUT (TABLE 14)',
                  style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w800,
                      color: AppColors.onPrimary, letterSpacing: 1.0)),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  SUB-WIDGETS
// ─────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  final String label;
  const _StatusChip({required this.label});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: AppColors.surfaceContainerHighest, borderRadius: BorderRadius.circular(6)),
    child: Text(label, style: GoogleFonts.manrope(fontSize: 9, fontWeight: FontWeight.w700,
        color: AppColors.onSurfaceVariant, letterSpacing: 0.8)));
}

class _AddButton extends StatelessWidget {
  const _AddButton();
  @override
  Widget build(BuildContext context) => Container(
    width: 36, height: 36,
    decoration: BoxDecoration(color: AppColors.surfaceContainerHighest, borderRadius: BorderRadius.circular(8)),
    child: const Icon(Icons.add_rounded, color: Colors.white, size: 20));
}
