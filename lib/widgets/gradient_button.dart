import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

// ─────────────────────────────────────────────
//  GRADIENT BUTTON
// ─────────────────────────────────────────────

class GradientButton extends StatefulWidget {
  /// Primary label text — rendered in uppercase automatically.
  final String label;

  /// Called when the button is tapped.
  final VoidCallback onPressed;

  /// Optional leading or trailing icon widget.
  final Widget? icon;

  /// Where to place the icon relative to the label.
  final IconPosition iconPosition;

  /// Button height. Defaults to 56.
  final double height;

  /// Override border radius. Defaults to AppRadius.button (12).
  final double? borderRadius;

  /// Whether to show a loading state.
  final bool isLoading;

  /// Whether the button is interactive.
  final bool enabled;

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.iconPosition = IconPosition.trailing,
    this.height = 56,
    this.borderRadius,
    this.isLoading = false,
    this.enabled = true,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

enum IconPosition { leading, trailing }

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (!widget.enabled || widget.isLoading) return;
    HapticFeedback.lightImpact();
    await _controller.forward();
    await _controller.reverse();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? AppRadius.button;
    final isActive = widget.enabled && !widget.isLoading;

    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTap: _handleTap,
        onTapDown: (_) {
          if (isActive) _controller.forward();
        },
        onTapUp: (_) {
          if (isActive) _controller.reverse();
        },
        onTapCancel: () {
          if (isActive) _controller.reverse();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: widget.height,
          decoration: BoxDecoration(
            gradient: isActive ? AppGradients.primaryCta : null,
            color: isActive ? null : AppColors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: isActive ? AppShadows.primaryGlow : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _handleTap,
                splashColor: AppColors.onPrimary.withOpacity(0.08),
                highlightColor: AppColors.onPrimary.withOpacity(0.04),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildContent(isActive),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool isActive) {
    final textColor = isActive
        ? AppColors.onPrimary
        : AppColors.onSurfaceVariant;

    final labelWidget = Text(
      widget.label.toUpperCase(),
      style: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: textColor,
        letterSpacing: 1.2,
      ),
    );

    // Loading state
    if (widget.isLoading) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          ),
          const SizedBox(width: 12),
          labelWidget,
        ],
      );
    }

    // No icon
    if (widget.icon == null) {
      return Center(child: labelWidget);
    }

    // Icon leading
    if (widget.iconPosition == IconPosition.leading) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconTheme(
            data: IconThemeData(color: textColor, size: 20),
            child: widget.icon!,
          ),
          const SizedBox(width: 10),
          labelWidget,
        ],
      );
    }

    // Icon trailing (default)
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        labelWidget,
        const SizedBox(width: 10),
        IconTheme(
          data: IconThemeData(color: textColor, size: 20),
          child: widget.icon!,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  CONVENIENCE CONSTRUCTORS
// ─────────────────────────────────────────────

/// Pre-built "Proceed to Payment" button variant.
class PaymentButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const PaymentButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GradientButton(
      label: 'Proceed to Payment',
      onPressed: onPressed,
      isLoading: isLoading,
      icon: const Icon(Icons.arrow_forward_rounded),
    );
  }
}

/// Pre-built "Add to Order" button variant.
class AddToOrderButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String price;
  final bool isLoading;

  const AddToOrderButton({
    super.key,
    required this.onPressed,
    required this.price,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GradientButton(
      label: 'Add to Order  $price',
      onPressed: onPressed,
      isLoading: isLoading,
      icon: const Icon(Icons.add_rounded),
      iconPosition: IconPosition.leading,
    );
  }
}
