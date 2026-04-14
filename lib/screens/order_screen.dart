import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';
import '../widgets/bottom_nav_bar.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});
  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with TickerProviderStateMixin {
  final Map<String, AnimationController> _qtyCtrlMap = {};
  final Map<String, Animation<double>> _qtyScaleMap = {};
  final Map<String, AnimationController> _delCtrlMap = {};
  final Map<String, Animation<double>> _delAnimMap = {};

  @override
  void dispose() {
    for (final c in _qtyCtrlMap.values) c.dispose();
    for (final c in _delCtrlMap.values) c.dispose();
    super.dispose();
  }

  void _ensureAnimations(String id) {
    if (!_qtyCtrlMap.containsKey(id)) {
      final c = AnimationController(vsync: this, duration: const Duration(milliseconds: 110));
      _qtyCtrlMap[id] = c;
      _qtyScaleMap[id] = Tween<double>(begin: 1.0, end: 0.78)
          .animate(CurvedAnimation(parent: c, curve: Curves.easeInOut));
    }
    if (!_delCtrlMap.containsKey(id)) {
      final c = AnimationController(vsync: this, duration: const Duration(milliseconds: 280));
      _delCtrlMap[id] = c;
      _delAnimMap[id] = CurvedAnimation(parent: c, curve: Curves.easeIn);
    }
  }

  Future<void> _tapQty(String id, bool isAdd) async {
    HapticFeedback.lightImpact();
    _ensureAnimations(id);
    await _qtyCtrlMap[id]!.forward();
    await _qtyCtrlMap[id]!.reverse();
    if (!mounted) return;
    final cart = CartProvider.read(context);
    isAdd ? cart.increment(id) : cart.decrement(id);
  }

  Future<void> _deleteItem(String id) async {
    HapticFeedback.mediumImpact();
    _ensureAnimations(id);
    await _delCtrlMap[id]!.forward();
    if (!mounted) return;
    CartProvider.read(context).removeItem(id);
    _qtyCtrlMap[id]?.dispose(); _qtyCtrlMap.remove(id); _qtyScaleMap.remove(id);
    _delCtrlMap[id]?.dispose(); _delCtrlMap.remove(id); _delAnimMap.remove(id);
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);
    final items = cart.items;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      appBar: _buildAppBar(),
      body: Stack(children: [
        items.isEmpty
            ? _buildEmptyCart()
            : ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 280),
          physics: const BouncingScrollPhysics(),
          children: [
            _buildPageHeader(items.length),
            const SizedBox(height: 20),
            ...items.map((item) {
              _ensureAnimations(item.id);
              return _buildOrderItemCard(item);
            }),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () => Navigator.of(context).pushNamed('/menu'),
              icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary, size: 20),
              label: Text('إضافة المزيد للطلب',
                  style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
              style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8)),
            ),
          ],
        ),
        if (items.isNotEmpty)
          Positioned(left: 0, right: 0, bottom: 0, child: _buildSummaryBar(cart)),
      ]),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }

  // ── APPBAR ─────────────────────────────────

  PreferredSizeWidget _buildAppBar() => AppBar(
    backgroundColor: AppColors.background,
    elevation: 0, scrolledUnderElevation: 0,
    automaticallyImplyLeading: false,
    titleSpacing: 16,
    title: Row(children: [
      const Icon(Icons.menu, color: Color(0xFF2ECC71), size: 24),
      const SizedBox(width: 12),
      Flexible(child: Text('XCORE', style: GoogleFonts.manrope(
          fontSize: 16, fontWeight: FontWeight.w900,
          color: const Color(0xFF2ECC71), letterSpacing: 1.0),
          overflow: TextOverflow.ellipsis)),
    ]),
    actions: [
      Padding(padding: const EdgeInsets.only(right: 16),
          child: Container(width: 36, height: 36,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceContainerHigh,
                  border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3), width: 1)),
              child: const Icon(Icons.person_rounded, color: AppColors.onSurfaceVariant, size: 20))),
    ],
  );

  // ── PAGE HEADER ────────────────────────────

  Widget _buildPageHeader(int itemCount) => Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('CURRENT SESSION', style: GoogleFonts.manrope(
          fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 2.0)),
      const SizedBox(height: 4),
      Text('طلب الطاولة 14', style: GoogleFonts.manrope(
          fontSize: 36, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.72, height: 1.05)),
    ])),
    Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: [
      Text('الأصناف: ${itemCount.toString().padLeft(2, '0')}',
          style: GoogleFonts.manrope(fontSize: 13, color: AppColors.onSurfaceVariant)),
      const SizedBox(height: 2),
      Text('النادل: Marcus V.', style: GoogleFonts.manrope(fontSize: 13, color: AppColors.onSurfaceVariant)),
    ]),
  ]);

  // ── ORDER ITEM CARD ─────────────────────────

  Widget _buildOrderItemCard(CartItem item) {
    final delAnim = _delAnimMap[item.id];
    final qtyScale = _qtyScaleMap[item.id];

    Widget card = Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(16)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        ClipRRect(borderRadius: BorderRadius.circular(8),
            child: SizedBox(width: 64, height: 64,
                child: Image.network(item.imageUrl, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceContainerHighest,
                        child: const Icon(Icons.image_outlined, color: AppColors.outlineVariant, size: 24))))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(item.name, style: GoogleFonts.manrope(
              fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.14),
              maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          if (item.category.isNotEmpty)
            Text('${item.category}${item.detail.isNotEmpty ? " • ${item.detail}" : ""}',
                style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700,
                    color: AppColors.primary, letterSpacing: 1.2)),
        ])),
        const SizedBox(width: 8),
        _buildStepper(item, qtyScale),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: [
          Text('${item.total.toStringAsFixed(0)} ج', style: GoogleFonts.manrope(
              fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.32)),
          if (item.quantity > 1) ...[
            const SizedBox(height: 2),
            Text('${item.unitPrice.toStringAsFixed(0)} ج / قطعة',
                style: GoogleFonts.manrope(fontSize: 10, color: AppColors.onSurfaceVariant)),
          ],
        ]),
        const SizedBox(width: 4),
        GestureDetector(onTap: () => _deleteItem(item.id),
            child: Padding(padding: const EdgeInsets.all(4),
                child: const Icon(Icons.delete_outline_rounded, color: AppColors.primary, size: 22))),
      ]),
    );

    if (delAnim != null) {
      card = AnimatedBuilder(
          animation: delAnim,
          builder: (_, child) => Opacity(opacity: 1.0 - delAnim.value,
              child: Transform.translate(offset: Offset(60 * delAnim.value, 0), child: child)),
          child: card);
    }
    return card;
  }

  // ── STEPPER ────────────────────────────────

  Widget _buildStepper(CartItem item, Animation<double>? scale) {
    Widget btn({required IconData icon, required bool isAdd}) {
      Widget b = GestureDetector(
          onTap: () => _tapQty(item.id, isAdd),
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(icon, size: 16,
                  color: (!isAdd && item.quantity <= 1) ? AppColors.outlineVariant : AppColors.onSurfaceVariant)));
      if (scale != null) b = ScaleTransition(scale: scale, child: b);
      return b;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(100)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        btn(icon: Icons.remove, isAdd: false),
        const SizedBox(width: 4),
        SizedBox(width: 28, child: Text(item.quantity.toString().padLeft(2, '0'),
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white))),
        const SizedBox(width: 4),
        btn(icon: Icons.add, isAdd: true),
      ]),
    );
  }

  // ── SUMMARY BAR ────────────────────────────

  Widget _buildSummaryBar(CartNotifier cart) => ClipRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E).withOpacity(0.95),
            boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 32, offset: Offset(0, -12))]),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: _SummaryCol(label: 'الإجمالي',
                value: '${cart.subtotal.toStringAsFixed(0)} ج', labelColor: AppColors.onSurfaceVariant, valueSize: 20)),
            Expanded(child: _SummaryCol(label: 'الخدمة 15%',
                value: '${cart.service.toStringAsFixed(0)} ج', labelColor: AppColors.onSurfaceVariant, valueSize: 20)),
            Expanded(child: _SummaryCol(label: 'الإجمالي الكلي',
                value: '${cart.grandTotal.toStringAsFixed(0)} ج',
                labelColor: AppColors.primary, valueSize: 24, valueBold: true, valueLetterSpacing: -1.0)),
          ]),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity, height: 56,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.15), blurRadius: 24, offset: const Offset(0, 8))]),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('PROCEED TO PAYMENT', style: GoogleFonts.manrope(
                    fontSize: 15, fontWeight: FontWeight.w900, color: const Color(0xFF121212), letterSpacing: 1.0)),
                const SizedBox(width: 12),
                const Icon(Icons.arrow_forward_rounded, color: Color(0xFF121212), size: 20),
              ]),
            ),
          ),
        ]),
      ),
    ),
  );

  // ── EMPTY CART ─────────────────────────────

  Widget _buildEmptyCart() => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    Icon(Icons.shopping_cart_outlined, size: 56, color: AppColors.outlineVariant),
    const SizedBox(height: 16),
    Text('لا توجد طلبات حتى الآن',
        style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
    const SizedBox(height: 8),
    Text('أضف أصنافاً من قائمة الطعام',
        style: GoogleFonts.manrope(fontSize: 13, color: AppColors.onSurfaceVariant)),
    const SizedBox(height: 24),
    GestureDetector(
        onTap: () => Navigator.of(context).pushNamed('/menu'),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(gradient: AppGradients.primaryCta, borderRadius: BorderRadius.circular(12)),
            child: Text('تصفح القائمة',
                style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.onPrimary)))),
  ]));
}

// ─────────────────────────────────────────────
//  SUMMARY COLUMN
// ─────────────────────────────────────────────

class _SummaryCol extends StatelessWidget {
  final String label, value;
  final Color labelColor;
  final double valueSize;
  final bool valueBold;
  final double valueLetterSpacing;

  const _SummaryCol({required this.label, required this.value, required this.labelColor,
    required this.valueSize, this.valueBold = false, this.valueLetterSpacing = -0.3});

  @override
  Widget build(BuildContext context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: GoogleFonts.manrope(fontSize: 9, fontWeight: FontWeight.w700,
            color: labelColor, letterSpacing: 1.0)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.manrope(
            fontSize: valueSize, fontWeight: valueBold ? FontWeight.w900 : FontWeight.w700,
            color: Colors.white, letterSpacing: valueLetterSpacing, height: 1.0)),
      ]);
}
