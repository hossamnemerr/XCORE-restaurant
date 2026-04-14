import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';

// ─────────────────────────────────────────────
//  PUBLIC FUNCTION
// ─────────────────────────────────────────────

void showCustomizeSheet(BuildContext context, {CartItem? prefillItem}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.6),
    useSafeArea: false,
    builder: (_) => CustomizeSheet(prefillItem: prefillItem),
  );
}

// ─────────────────────────────────────────────
//  DATA MODELS (local)
// ─────────────────────────────────────────────

class _Topping {
  final String label;
  bool isSelected;
  _Topping(this.label, {this.isSelected = false});
}

class _DietaryOption {
  final String label;
  bool isChecked;
  _DietaryOption(this.label, {this.isChecked = false});
}

// ─────────────────────────────────────────────
//  CUSTOMIZE SHEET
// ─────────────────────────────────────────────

class CustomizeSheet extends StatefulWidget {
  final CartItem? prefillItem;
  const CustomizeSheet({super.key, this.prefillItem});

  @override
  State<CustomizeSheet> createState() => _CustomizeSheetState();
}

class _CustomizeSheetState extends State<CustomizeSheet>
    with SingleTickerProviderStateMixin {
  int _quantity = 1;

  final List<_Topping> _toppings = [
    _Topping('Extra Truffle', isSelected: true),
    _Topping('Prosciutto'),
    _Topping('Pine Nuts'),
    _Topping('Balsamic Glaze'),
  ];

  final List<_DietaryOption> _dietary = [
    _DietaryOption('Gluten-Free Crackers'),
    _DietaryOption('No Pine Nuts (Allergy)', isChecked: true),
  ];

  late final AnimationController _qtyCtrl;

  @override
  void initState() {
    super.initState();
    _qtyCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 110));
    if (widget.prefillItem != null) _quantity = widget.prefillItem!.quantity;
  }

  @override
  void dispose() { _qtyCtrl.dispose(); super.dispose(); }

  Future<void> _tapAdd() async {
    HapticFeedback.lightImpact();
    await _qtyCtrl.forward(); await _qtyCtrl.reverse();
    setState(() => _quantity++);
  }

  Future<void> _tapRemove() async {
    if (_quantity <= 1) return;
    HapticFeedback.lightImpact();
    await _qtyCtrl.forward(); await _qtyCtrl.reverse();
    setState(() => _quantity--);
  }

  double get _unitPrice => widget.prefillItem?.unitPrice ?? 0.0;
  double get _total => _unitPrice * _quantity;

  void _addToOrder() {
    HapticFeedback.mediumImpact();
    final cart = CartProvider.read(context);
    cart.addItem(CartItem(
      id: widget.prefillItem?.id ?? 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: widget.prefillItem?.name ?? 'Truffle Burrata Salad',
      category: widget.prefillItem?.category ?? 'SALADS',
      description: widget.prefillItem?.description ?? '',
      detail: _toppings.where((t) => t.isSelected).map((t) => t.label).join(', '),
      imageUrl: widget.prefillItem?.imageUrl ??
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300&q=80',
      unitPrice: _unitPrice,
      quantity: _quantity,
    ));
    Navigator.of(context).pop();
  }

  // ── BUILD ──────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(maxHeight: screenHeight * 0.92),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        _dragHandle(),
        _header(),
        Flexible(child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20, 0, 20, bottomInset + 100),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _itemHero(),
            const SizedBox(height: 28),
            _toppingsSection(),
            const SizedBox(height: 28),
            _dietarySection(),
            const SizedBox(height: 28),
            _specialInstructions(),
            const SizedBox(height: 12),
          ]),
        )),
        _footer(bottomInset),
      ]),
    );
  }

  Widget _dragHandle() => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 4),
    child: Center(child: Container(width: 48, height: 6,
      decoration: BoxDecoration(color: AppColors.surfaceContainerHighest, borderRadius: BorderRadius.circular(3)))));

  Widget _header() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 8, 12, 16),
    child: Row(children: [
      Text('تخصيص الطلب', style: GoogleFonts.manrope(
          fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.48)),
      const Spacer(),
      GestureDetector(onTap: () => Navigator.of(context).pop(),
        child: Container(width: 40, height: 40,
          decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, shape: BoxShape.circle),
          child: const Icon(Icons.close_rounded, color: Colors.white, size: 20))),
    ]));

  Widget _itemHero() => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    ClipRRect(borderRadius: BorderRadius.circular(16),
      child: SizedBox(width: 96, height: 96,
        child: Image.network(
          widget.prefillItem?.imageUrl ?? 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300&q=80',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceContainerHighest,
            child: const Icon(Icons.restaurant_rounded, color: AppColors.outlineVariant, size: 32))))),
    const SizedBox(width: 16),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(widget.prefillItem?.name ?? 'Truffle Burrata Salad',
        style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.4)),
      const SizedBox(height: 6),
      Text(widget.prefillItem?.description ?? 'Creamy burrata, black truffle shavings, aged balsamic, and seasonal microgreens.',
        style: GoogleFonts.manrope(fontSize: 13, color: AppColors.onSurfaceVariant, height: 1.5)),
    ])),
  ]);

  Widget _toppingsSection() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [
      Text('اختر الإضافات', style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.8)),
      const Spacer(),
      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
        child: Text('مطلوب', style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700,
            color: AppColors.onPrimary, letterSpacing: 0.8))),
    ]),
    const SizedBox(height: 12),
    Wrap(spacing: 8, runSpacing: 8,
      children: _toppings.map((t) => _ToppingChip(
        topping: t, onTap: () => setState(() => t.isSelected = !t.isSelected))).toList()),
  ]);

  Widget _dietarySection() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('ملاحظات غذائية', style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.8)),
    const SizedBox(height: 10),
    ..._dietary.asMap().entries.map((e) => Padding(
      padding: EdgeInsets.only(bottom: e.key < _dietary.length - 1 ? 10 : 0),
      child: _DietaryRow(option: e.value, onTap: () => setState(() => e.value.isChecked = !e.value.isChecked)))),
  ]);

  Widget _specialInstructions() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('تعليمات خاصة', style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.8)),
    const SizedBox(height: 10),
    Container(
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16)),
      child: TextFormField(
        minLines: 4, maxLines: 6,
        style: GoogleFonts.manrope(fontSize: 14, color: Colors.white),
        decoration: InputDecoration(
          hintText: 'مثال: بدون بصل، صوص خارجي...',
          hintStyle: GoogleFonts.manrope(fontSize: 13, color: AppColors.outline),
          filled: false,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.primaryDim.withOpacity(0.4), width: 2)),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    ),
  ]);

  Widget _footer(double bottomInset) => Container(
    decoration: BoxDecoration(color: const Color(0xFF1E1E1E),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.07), width: 1))),
    padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
    child: Row(children: [
      // Stepper
      Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: AppColors.surfaceContainerHighest, borderRadius: BorderRadius.circular(16)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          _QtyBtn(icon: Icons.remove_rounded, onTap: _tapRemove, enabled: _quantity > 1),
          SizedBox(width: 36, child: Text('$_quantity', textAlign: TextAlign.center,
            style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white))),
          _QtyBtn(icon: Icons.add_rounded, onTap: _tapAdd, enabled: true),
        ]),
      ),
      const SizedBox(width: 12),
      // CTA
      Expanded(child: _AddToOrderBtn(price: _total, onTap: _addToOrder)),
    ]),
  );
}

// ─────────────────────────────────────────────
//  SUB-WIDGETS
// ─────────────────────────────────────────────

class _ToppingChip extends StatelessWidget {
  final _Topping topping;
  final VoidCallback onTap;
  const _ToppingChip({required this.topping, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isActive = topping.isSelected;
    return GestureDetector(
      onTap: () { HapticFeedback.selectionClick(); onTap(); },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: isActive ? AppGradients.primaryCta : null,
          color: isActive ? null : AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive ? [BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4))] : null,
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(isActive ? Icons.check_circle : Icons.add_rounded, size: 16,
              color: isActive ? AppColors.onPrimary : Colors.white),
          const SizedBox(width: 8),
          Text(topping.label, style: GoogleFonts.manrope(fontSize: 13,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
              color: isActive ? AppColors.onPrimary : Colors.white)),
        ]),
      ),
    );
  }
}

class _DietaryRow extends StatelessWidget {
  final _DietaryOption option;
  final VoidCallback onTap;
  const _DietaryRow({required this.option, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () { HapticFeedback.selectionClick(); onTap(); },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(color: const Color(0xFF131313), borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        Text(option.label, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
        const Spacer(),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 24, height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: option.isChecked ? AppColors.primary : Colors.transparent,
            border: option.isChecked ? null : Border.all(color: AppColors.outlineVariant, width: 2),
            boxShadow: option.isChecked ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8)] : null,
          ),
          child: option.isChecked ? const Icon(Icons.check_rounded, size: 16, color: AppColors.onPrimary) : null,
        ),
      ]),
    ),
  );
}

class _QtyBtn extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;
  const _QtyBtn({required this.icon, required this.onTap, required this.enabled});
  @override
  State<_QtyBtn> createState() => _QtyBtnState();
}

class _QtyBtnState extends State<_QtyBtn> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _s;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _s = Tween<double>(begin: 1.0, end: 0.78).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }
  @override void dispose() { _c.dispose(); super.dispose(); }
  Future<void> _tap() async { if (!widget.enabled) return; await _c.forward(); await _c.reverse(); widget.onTap(); }
  @override
  Widget build(BuildContext context) => ScaleTransition(scale: _s,
    child: GestureDetector(onTap: _tap,
      child: Container(width: 40, height: 40,
        decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
        child: Icon(widget.icon, size: 22, color: widget.enabled ? AppColors.primary : AppColors.outlineVariant))));
}

class _AddToOrderBtn extends StatefulWidget {
  final double price;
  final VoidCallback onTap;
  const _AddToOrderBtn({required this.price, required this.onTap});
  @override
  State<_AddToOrderBtn> createState() => _AddToOrderBtnState();
}

class _AddToOrderBtnState extends State<_AddToOrderBtn> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _s;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _s = Tween<double>(begin: 1.0, end: 0.96).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }
  @override void dispose() { _c.dispose(); super.dispose(); }
  Future<void> _tap() async { await _c.forward(); await _c.reverse(); widget.onTap(); }
  @override
  Widget build(BuildContext context) => ScaleTransition(scale: _s,
    child: GestureDetector(onTap: _tap, onTapDown: (_) => _c.forward(), onTapUp: (_) => _c.reverse(), onTapCancel: () => _c.reverse(),
      child: Container(height: 60,
        decoration: BoxDecoration(gradient: AppGradients.primaryCta, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.primaryGlow),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(children: [
          Text('إضافة للطلب', style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.onPrimary, letterSpacing: -0.2)),
          const Spacer(),
          Text('${widget.price.toStringAsFixed(0)} ج', style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.onPrimary, letterSpacing: -0.3)),
        ]))));
}
