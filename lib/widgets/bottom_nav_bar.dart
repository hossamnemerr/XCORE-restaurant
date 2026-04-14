import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

// ─────────────────────────────────────────────
//  NAV ITEM DEFINITION
// ─────────────────────────────────────────────

class _NavItem {
  final String label;
  final IconData icon;
  const _NavItem(this.label, this.icon);
}

const List<_NavItem> _navItems = [
  _NavItem('TABLES',  Icons.table_restaurant_rounded),
  _NavItem('MENU',    Icons.restaurant_menu_rounded),
  _NavItem('ORDERS',  Icons.shopping_cart_rounded),
  _NavItem('BILLING', Icons.payments_rounded),
];

// ─────────────────────────────────────────────
//  BOTTOM NAV BAR
// ─────────────────────────────────────────────

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        border: Border(
          top: BorderSide(
            color: Color(0x0DFFFFFF), // white @ 5%
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(
              _navItems.length,
              (index) => Expanded(
                child: _NavButton(
                  item: _navItems[index],
                  isActive: index == currentIndex,
                  onTap: () {
                    if (onTap != null) {
                      onTap!(index);
                    } else {
                      _defaultNavigate(context, index);
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _defaultNavigate(BuildContext context, int index) {
    if (index == currentIndex) return;
    const routes = ['/', '/login', '/menu', '/orders'];
    // Map index → route
    final destinations = ['/tables', '/menu', '/orders', '/billing'];
    final route = destinations[index];
    Navigator.of(context).pushNamed(route);
  }
}

// ─────────────────────────────────────────────
//  INDIVIDUAL NAV BUTTON
// ─────────────────────────────────────────────

class _NavButton extends StatefulWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    await _controller.forward();
    await _controller.reverse();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scale,
        child: widget.isActive ? _ActiveItem(item: widget.item) : _InactiveItem(item: widget.item),
      ),
    );
  }
}

// ── Active state — gradient pill ──────────────

class _ActiveItem extends StatelessWidget {
  final _NavItem item;
  const _ActiveItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: AppGradients.primaryCta,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              size: 20,
              color: AppColors.onPrimary,
            ),
            const SizedBox(height: 3),
            Text(
              item.label,
              style: GoogleFonts.manrope(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: AppColors.onPrimary,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Inactive state ────────────────────────────

class _InactiveItem extends StatelessWidget {
  final _NavItem item;
  const _InactiveItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.icon,
            size: 22,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 3),
          Text(
            item.label,
            style: GoogleFonts.manrope(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
