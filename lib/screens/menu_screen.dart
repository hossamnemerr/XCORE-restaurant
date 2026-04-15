import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/customize_sheet.dart';

// ── Models ────────────────────────────────────

class MenuCategory {
  final String id, label; final IconData icon;
  const MenuCategory(this.id, this.label, this.icon);
}

class MenuItem {
  final String id, name, description, imageUrl, categoryId;
  final double price;
  final List<String> chips;
  final bool isFeatured;
  const MenuItem({
    required this.id, required this.name, required this.description,
    required this.price, required this.imageUrl, required this.categoryId,
    this.chips = const [], this.isFeatured = false,
  });
}

// ── Static Data ───────────────────────────────

const kCategories = [
  MenuCategory('all',      'الكل',    Icons.grid_view_rounded),
  MenuCategory('shawarma', 'شاورما',  Icons.kebab_dining_rounded),
  MenuCategory('broast',   'بروست',   Icons.set_meal_rounded),
  MenuCategory('burgers',  'برجر',    Icons.lunch_dining_rounded),
  MenuCategory('juices',   'عصائر',   Icons.local_drink_rounded),
  MenuCategory('sides',    'إضافات',  Icons.grain_rounded),
  MenuCategory('desserts', 'حلويات',  Icons.icecream_rounded),
];

const kMenuItems = [
  MenuItem(id: 'shawarma_special', name: 'شاورما سبيشال',
      description: 'شاورما دجاج مع صوص الثوم، المخلل، والبطاطس المقلية داخل الخبز.', price: 149,
      imageUrl: 'https://images.unsplash.com/photo-1599487489-0c7d3b2cf19d?w=800&q=80',
      categoryId: 'shawarma', chips: ['الأكثر طلباً', 'جديد'], isFeatured: true),
  MenuItem(id: 'shawarma_chicken', name: 'شاورما دجاج',
      description: 'دجاج مشوي متبل بالبهارات مع صوص طحينة وخضار.', price: 120,
      imageUrl: 'https://images.unsplash.com/photo-1561043433-9265f73e685f?w=400&q=80',
      categoryId: 'shawarma', chips: ['كلاسيك']),
  MenuItem(id: 'shawarma_meat', name: 'شاورما لحم',
      description: 'لحم عجل مشوي مع صوص الثوم والبصل المكرمل.', price: 165,
      imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400&q=80',
      categoryId: 'shawarma', chips: ['مميز']),
  MenuItem(id: 'shawarma_mix', name: 'شاورما ميكس',
      description: 'خليط دجاج ولحم مع توابل خاصة وخبز مقرمش.', price: 180,
      imageUrl: 'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?w=400&q=80',
      categoryId: 'shawarma', chips: ['مزدوج']),
  MenuItem(id: 'broast_half', name: 'بروست نص دجاجة',
      description: 'نصف دجاجة مقلية بعجينة مقرمشة مع بطاطس وصوص.', price: 200,
      imageUrl: 'https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58?w=400&q=80',
      categoryId: 'broast', chips: ['مقرمش']),
  MenuItem(id: 'broast_pieces', name: '6 قطع بروست',
      description: 'ست قطع دجاج بعجينة هشة مع صوص الثوم.', price: 175,
      imageUrl: 'https://images.unsplash.com/photo-1562967914-608f82629710?w=400&q=80',
      categoryId: 'broast', chips: ['عائلي']),
  MenuItem(id: 'broast_full', name: 'بروست دجاجة كاملة',
      description: 'دجاجة كاملة بروست مع بطاطس كبيرة وسلطة.', price: 280,
      imageUrl: 'https://images.unsplash.com/photo-1619881590738-a111d176d906?w=400&q=80',
      categoryId: 'broast', chips: ['عائلي', 'قيمة']),
  MenuItem(id: 'burger_smash', name: 'سماش برجر',
      description: 'ضلعان لحم بقري مسطح مع جبنة شيدر وصوص خاص.', price: 190,
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&q=80',
      categoryId: 'burgers', chips: ['سيف الشيف']),
  MenuItem(id: 'burger_crispy', name: 'كريسبي برجر',
      description: 'فيليه دجاج مقرمش مع كول سلو وخيار مخلل.', price: 155,
      imageUrl: 'https://images.unsplash.com/photo-1606755962773-d324e0a13086?w=400&q=80',
      categoryId: 'burgers', chips: ['مقرمش']),
  MenuItem(id: 'burger_double', name: 'دبل برجر',
      description: 'ضلعان لحم بقري مع خس وطماطم وجبنة مزدوجة.', price: 240,
      imageUrl: 'https://images.unsplash.com/photo-1553979459-d2229ba7433b?w=400&q=80',
      categoryId: 'burgers', chips: ['كبير', 'قيمة']),
  MenuItem(id: 'juice_mango', name: 'عصير مانجو',
      description: 'مانجو طازجة مخفوقة بالثلج.', price: 65,
      imageUrl: 'https://images.unsplash.com/photo-1623065422902-30a2d299bbe4?w=400&q=80',
      categoryId: 'juices', chips: ['طازج']),
  MenuItem(id: 'juice_lemon', name: 'ليمون بالنعناع',
      description: 'ليمون حامض مع نعناع طازج وشراب الصمغ.', price: 55,
      imageUrl: 'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=400&q=80',
      categoryId: 'juices', chips: ['منعش']),
  MenuItem(id: 'juice_avocado', name: 'موهيتو أفوكادو',
      description: 'أفوكادو كريمي مع الليمون والنعناع.', price: 85,
      imageUrl: 'https://images.unsplash.com/photo-1638176066959-22f5a0dc1b87?w=400&q=80',
      categoryId: 'juices', chips: ['مميز']),
  MenuItem(id: 'juice_strawberry', name: 'عصير فراولة',
      description: 'فراولة طازجة مع الحليب والسكر.', price: 70,
      imageUrl: 'https://images.unsplash.com/photo-1553361371-9b22f78e8b1d?w=400&q=80',
      categoryId: 'juices', chips: ['محبوب']),
  MenuItem(id: 'side_fries', name: 'بطاطس محمرة',
      description: 'بطاطس مقلية مقرمشة مع ملح البحر.', price: 55,
      imageUrl: 'https://images.unsplash.com/photo-1541592106381-b31e9677c0e5?w=400&q=80',
      categoryId: 'sides', chips: ['كلاسيك']),
  MenuItem(id: 'side_coleslaw', name: 'كول سلو',
      description: 'سلطة ملفوف كريمية خفيفة.', price: 50,
      imageUrl: 'https://images.unsplash.com/photo-1625938146419-bca35e98b5fc?w=400&q=80',
      categoryId: 'sides'),
  MenuItem(id: 'side_garlic_bread', name: 'خبز بالثوم',
      description: 'خبز محمص بزبدة الثوم والأعشاب.', price: 60,
      imageUrl: 'https://images.unsplash.com/photo-1619881589316-3f0c7a67d0a1?w=400&q=80',
      categoryId: 'sides'),
  MenuItem(id: 'dessert_kunafa', name: 'كنافة بالقشطة',
      description: 'كنافة ناعمة بالقشطة وعسل القطر.', price: 95,
      imageUrl: 'https://images.unsplash.com/photo-1598110750624-2b8b7e9b8a59?w=400&q=80',
      categoryId: 'desserts', chips: ['محبوب']),
  MenuItem(id: 'dessert_icecream', name: 'آيس كريم سوفتي',
      description: 'آيس كريم فانيلا ناعم مع صوص الشوكولاتة.', price: 75,
      imageUrl: 'https://images.unsplash.com/photo-1570197788417-0e82375c9371?w=400&q=80',
      categoryId: 'desserts'),
  MenuItem(id: 'dessert_brownie', name: 'براوني دافئ',
      description: 'براوني شوكولاتة دافئ مع كريمة مثلجة.', price: 100,
      imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400&q=80',
      categoryId: 'desserts', chips: ['ساخن']),
];

// ── Screen ────────────────────────────────────

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});
  @override State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  int _catIdx = 0;
  final Map<String, AnimationController> _ctrls = {};
  final Map<String, Animation<double>> _scales = {};

  List<MenuItem> get _visible {
    final catId = kCategories[_catIdx].id;
    final list = kMenuItems.where((m) => !m.isFeatured);
    return catId == 'all' ? list.toList() : list.where((m) => m.categoryId == catId).toList();
  }

  @override
  void initState() {
    super.initState();
    for (final item in kMenuItems) {
      final c = AnimationController(vsync: this, duration: const Duration(milliseconds: 130));
      _ctrls[item.id] = c;
      _scales[item.id] = Tween<double>(begin: 1.0, end: 0.85)
          .animate(CurvedAnimation(parent: c, curve: Curves.easeInOut));
    }
  }

  @override
  void dispose() { for (final c in _ctrls.values) c.dispose(); super.dispose(); }

  CartItem _toCartItem(MenuItem m) => CartItem(
    id: m.id, name: m.name, category: m.categoryId.toUpperCase(),
    description: m.description, detail: m.chips.isNotEmpty ? m.chips.first : '',
    imageUrl: m.imageUrl, unitPrice: m.price,
  );

  void _openSheet(MenuItem m) => showCustomizeSheet(context, prefillItem: _toCartItem(m));

  Future<void> _quickAdd(MenuItem m) async {
    HapticFeedback.lightImpact();
    final c = _ctrls[m.id]!;
    await c.forward(); await c.reverse();
    if (!mounted) return;
    CartProvider.read(context).addItem(_toCartItem(m));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.check_circle_rounded, color: Colors.black, size: 20),
        const SizedBox(width: 12),
        Text('${m.name} أُضيف للطلب',
            style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.black)),
      ]),
      duration: const Duration(seconds: 1),
      backgroundColor: AppColors.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);
    return Scaffold(
      backgroundColor: AppColors.background, extendBody: true,
      appBar: _appBar(cart.totalCount),
      body: Stack(children: [
        CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
          SliverToBoxAdapter(child: _categories()),
          SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _featuredCard(kMenuItems.first))),
          SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(_catIdx == 0 ? 'قائمة الطعام كاملة' : kCategories[_catIdx].label,
                  style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700,
                      color: AppColors.onSurfaceVariant, letterSpacing: 1.6)))),
          _visible.isEmpty
              ? SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.search_off_rounded, size: 40, color: AppColors.outlineVariant),
                const SizedBox(height: 12),
                Text('لا توجد عناصر في هذا القسم',
                    style: GoogleFonts.manrope(fontSize: 13, color: AppColors.onSurfaceVariant)),
              ]))))
              : SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100), // تقليل المسافة السفلية بعد حذف البار
              sliver: SliverList.separated(
                itemCount: _visible.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (_, i) => _itemCard(_visible[i]),
              )),
        ]),
        // تم حذف الـ checkoutBar من هنا كما طلبت
      ]),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  PreferredSizeWidget _appBar(int count) => AppBar(
    backgroundColor: AppColors.background, elevation: 0, scrolledUnderElevation: 0,
    automaticallyImplyLeading: false, titleSpacing: 16,
    title: Row(children: [
      const Icon(Icons.menu, color: Color(0xFF2ECC71), size: 24), const SizedBox(width: 12),
      Flexible(child: Text('XCORE', style: GoogleFonts.manrope(
          fontSize: 16, fontWeight: FontWeight.w900, color: const Color(0xFF2ECC71), letterSpacing: 1.0),
          overflow: TextOverflow.ellipsis)),
    ]),
    actions: [
      Padding(padding: const EdgeInsets.only(right: 4),
          child: Stack(clipBehavior: Clip.none, children: [
            IconButton(icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 24),
                onPressed: () => Navigator.of(context).pushNamed('/orders')),
            if (count > 0) Positioned(top: 6, right: 6,
                child: Container(width: 16, height: 16,
                    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    child: Center(child: Text('$count', style: GoogleFonts.manrope(
                        fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.onPrimary))))),
          ])),
      Padding(padding: const EdgeInsets.only(right: 16),
          child: Container(width: 36, height: 36,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.surfaceContainerHigh,
                  border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3))),
              child: const Icon(Icons.person_rounded, color: AppColors.onSurfaceVariant, size: 20))),
    ],
  );

  Widget _categories() => SizedBox(height: 52,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: kCategories.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (_, i) {
        final cat = kCategories[i]; final active = i == _catIdx;
        return GestureDetector(
          onTap: () => setState(() => _catIdx = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                gradient: active ? AppGradients.primaryCta : null,
                color: active ? null : AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(100)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(cat.icon, size: 16, color: active ? AppColors.onPrimary : AppColors.onSurfaceVariant),
              const SizedBox(width: 8),
              Text(cat.label, style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w700,
                  color: active ? AppColors.onPrimary : AppColors.onSurface)),
            ]),
          ),
        );
      },
    ),
  );

  Widget _featuredCard(MenuItem m) => GestureDetector(
    onTap: () => _openSheet(m),
    child: ClipRRect(borderRadius: BorderRadius.circular(16),
      child: SizedBox(width: double.infinity, height: 200,
        child: Stack(fit: StackFit.expand, children: [
          Image.network(m.imageUrl, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceContainerHigh)),
          Container(decoration: const BoxDecoration(gradient: LinearGradient(
              begin: Alignment.centerRight, end: Alignment.centerLeft,
              colors: [Color(0x00000000), Color(0xCC000000)], stops: [0.3, 1.0]))),
          Padding(padding: const EdgeInsets.all(20), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(m.name, style: GoogleFonts.manrope(fontSize: 22, fontWeight: FontWeight.w800,
                  color: Colors.white, letterSpacing: -0.44, height: 1.15)),
              const SizedBox(height: 4),
              Text(m.description, style: GoogleFonts.manrope(fontSize: 12, color: Colors.white70),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 12),
              Row(children: [
                Text('${m.price.toStringAsFixed(0)} ج', style: GoogleFonts.manrope(
                    fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: -0.48)),
                const Spacer(),
                GestureDetector(onTap: () => _quickAdd(m),
                    child: Container(width: 40, height: 40,
                        decoration: BoxDecoration(gradient: AppGradients.primaryCta, borderRadius: BorderRadius.circular(100)),
                        child: const Icon(Icons.add, color: AppColors.onPrimary, size: 22))),
              ]),
            ],
          )),
        ]),
      ),
    ),
  );

  Widget _itemCard(MenuItem m) {
    final scale = _scales[m.id];
    return GestureDetector(
      onTap: () => _openSheet(m),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          ClipRRect(borderRadius: BorderRadius.circular(8),
              child: SizedBox(width: 64, height: 64,
                  child: Image.network(m.imageUrl, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceContainerHighest,
                          child: const Icon(Icons.image_outlined, color: AppColors.outlineVariant))))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text(m.name, style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w700,
                color: Colors.white, letterSpacing: -0.15), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 3),
            Text(m.description, style: GoogleFonts.manrope(fontSize: 12, color: AppColors.onSurfaceVariant, height: 1.35),
                maxLines: 2, overflow: TextOverflow.ellipsis),
            if (m.chips.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(spacing: 6, runSpacing: 4, children: m.chips.map((c) => _Chip(c)).toList()),
            ],
          ])),
          const SizedBox(width: 12),
          Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('${m.price.toStringAsFixed(0)} ج', style: GoogleFonts.manrope(
                fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: -0.34)),
            const SizedBox(height: 8),
            GestureDetector(onTap: () => _quickAdd(m), behavior: HitTestBehavior.opaque,
                child: scale != null
                    ? ScaleTransition(scale: scale, child: const _AddBtn())
                    : const _AddBtn()),
          ]),
        ]),
      ),
    );
  }

  Widget _checkoutBar(int count) => ClipRect(
    child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E).withOpacity(0.95), boxShadow: AppShadows.floatingBar),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed('/orders'),
          child: Container(width: double.infinity, height: 56,
            decoration: BoxDecoration(gradient: AppGradients.primaryCta,
                borderRadius: BorderRadius.circular(12), boxShadow: AppShadows.primaryGlow),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.receipt_long_rounded, color: AppColors.onPrimary, size: 20),
              const SizedBox(width: 10),
              Text(count > 0 ? 'عرض الطلب ($count)' : 'عرض الطلب',
                  style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w800,
                      color: AppColors.onPrimary, letterSpacing: 1.0)),
            ]),
          ),
        ),
      ),
    ),
  );
}

class _Chip extends StatelessWidget {
  final String label; const _Chip(this.label);
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: AppColors.surfaceContainerHighest, borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: GoogleFonts.manrope(
          fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant, letterSpacing: 0.8)));
}

class _AddBtn extends StatelessWidget {
  const _AddBtn();
  @override
  Widget build(BuildContext context) => Container(width: 36, height: 36,
      decoration: BoxDecoration(color: AppColors.surfaceContainerHighest, borderRadius: BorderRadius.circular(8)),
      child: const Icon(Icons.add_rounded, color: Colors.white, size: 20));
}
