import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  static const int _pinLength = 4;
  static const String _correctPin = '1234';
  final List<String> _pinDigits = [];

  // 12 controllers: 0-8 = digits 1-9, 9 = backspace, 10 = digit 0, 11 = clear-all
  late final List<AnimationController> _keyControllers;
  late final List<Animation<double>> _keyScales;

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _keyControllers = List.generate(
      12,
          (_) => AnimationController(vsync: this, duration: const Duration(milliseconds: 120)),
    );
    _keyScales = _keyControllers
        .map((c) => Tween<double>(begin: 1.0, end: 0.92)
        .animate(CurvedAnimation(parent: c, curve: Curves.easeInOut)))
        .toList();

    _shakeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -12), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -12, end: 12), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 12, end: -10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: -6), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6, end: 6), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    for (final c in _keyControllers) c.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _onDigitPressed(String digit, int keyIndex) {
    HapticFeedback.lightImpact();
    _animateKey(keyIndex);
    if (_pinDigits.length >= _pinLength) return;
    setState(() { _hasError = false; _pinDigits.add(digit); });
    if (_pinDigits.length == _pinLength) _verifyPin();
  }

  void _onBackspace(int keyIndex) {
    HapticFeedback.lightImpact();
    _animateKey(keyIndex);
    if (_pinDigits.isEmpty) return;
    setState(() { _hasError = false; _pinDigits.removeLast(); });
  }

  // Clear all digits at once
  void _onClearAll(int keyIndex) {
    HapticFeedback.mediumImpact();
    _animateKey(keyIndex);
    if (_pinDigits.isEmpty) return;
    setState(() { _hasError = false; _pinDigits.clear(); });
  }

  void _verifyPin() async {
    await Future.delayed(const Duration(milliseconds: 150));
    final entered = _pinDigits.join();
    if (entered == _correctPin) {
      if (mounted) Navigator.of(context).pushReplacementNamed('/menu');
    } else {
      HapticFeedback.heavyImpact();
      setState(() => _hasError = true);
      await _shakeController.forward(from: 0);
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() { _pinDigits.clear(); _hasError = false; });
    }
  }

  Future<void> _animateKey(int index) async {
    await _keyControllers[index].forward();
    await _keyControllers[index].reverse();
  }

  void _onEnterShift() {
    if (_pinDigits.length < _pinLength) return;
    _verifyPin();
  }

  // ── PIN dot ────────────────────────────────
  Widget _pinDot(int index) {
    final isFilled = index < _pinDigits.length;
    final isError = _hasError && index < _pinDigits.length;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: 16, height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isError ? AppColors.error : isFilled ? AppColors.primary : AppColors.surfaceContainerHighest,
        border: isFilled ? null : Border.all(color: AppColors.outlineVariant.withOpacity(0.5), width: 1),
        boxShadow: isFilled && !isError
            ? [BoxShadow(color: AppColors.primary.withOpacity(0.45), blurRadius: 12, spreadRadius: 1)]
            : isError
            ? [BoxShadow(color: AppColors.error.withOpacity(0.5), blurRadius: 12, spreadRadius: 1)]
            : null,
      ),
    );
  }

  // ── Numpad key ─────────────────────────────
  Widget _numpadKey({
    required int keyIndex,
    String? digit,
    Widget? customChild,
    Color? iconColor,
    bool isTransparent = false,
    IconData? icon,
    VoidCallback? onTapOverride,
  }) {
    return ScaleTransition(
      scale: _keyScales[keyIndex],
      child: GestureDetector(
        onTap: onTapOverride ?? () {
          if (digit != null) _onDigitPressed(digit, keyIndex);
        },
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: isTransparent
                ? null
                : BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: customChild ??
                  (digit != null
                      ? Text(digit,
                      style: GoogleFonts.manrope(
                          fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white, height: 1.0))
                      : Icon(icon, size: 28, color: iconColor ?? AppColors.onSurfaceVariant)),
            ),
          ),
        ),
      ),
    );
  }

  // ── Corner glow ────────────────────────────
  Widget _cornerGlow(AlignmentGeometry a, Offset offset) => Align(
      alignment: a,
      child: Transform.translate(offset: offset,
          child: ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(width: 300, height: 300,
                  decoration: BoxDecoration(shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.05))))));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: _buildAppBar(),
      body: Stack(children: [
        _cornerGlow(Alignment.topRight, const Offset(80, -80)),
        _cornerGlow(Alignment.bottomLeft, const Offset(-80, 80)),
        SafeArea(child: Column(children: [
          Expanded(child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(children: [
              const SizedBox(height: 40),
              Text('تسجيل الدخول',
                  style: GoogleFonts.manrope(fontSize: 40, fontWeight: FontWeight.w800,
                      color: Colors.white, letterSpacing: -0.8, height: 1.1),
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('أدخل رمز PIN الخاص بك',
                  style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w500,
                      color: AppColors.onSurfaceVariant),
                  textAlign: TextAlign.center),
              const SizedBox(height: 32),
              // PIN dots with shake
              AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (_, child) => Transform.translate(
                    offset: Offset(_shakeAnimation.value, 0), child: child),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pinLength, (i) => Padding(
                      padding: EdgeInsets.only(left: i == 0 ? 0 : 16),
                      child: _pinDot(i))),
                ),
              ),
              const SizedBox(height: 40),
              // Numpad grid
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _numpadKey(keyIndex: 0, digit: '1'),
                  _numpadKey(keyIndex: 1, digit: '2'),
                  _numpadKey(keyIndex: 2, digit: '3'),
                  _numpadKey(keyIndex: 3, digit: '4'),
                  _numpadKey(keyIndex: 4, digit: '5'),
                  _numpadKey(keyIndex: 5, digit: '6'),
                  _numpadKey(keyIndex: 6, digit: '7'),
                  _numpadKey(keyIndex: 7, digit: '8'),
                  _numpadKey(keyIndex: 8, digit: '9'),
                  // Row 4: backspace | 0 | clear-all (C)
                  _numpadKey(
                    keyIndex: 9,
                    icon: Icons.backspace_rounded,
                    iconColor: AppColors.error,
                    isTransparent: true,
                    onTapOverride: () => _onBackspace(9),
                  ),
                  _numpadKey(keyIndex: 10, digit: '0'),
                  // C = clear all button
                  _numpadKey(
                    keyIndex: 11,
                    isTransparent: true,
                    onTapOverride: () => _onClearAll(11),
                    customChild: Text('C',
                        style: GoogleFonts.manrope(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurfaceVariant,
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ]),
          )),
          _buildFooter(),
        ])),
      ]),
    );
  }

  // ── AppBar ─────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0E0E0E),
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Row(children: [
        const Icon(Icons.menu, color: Color(0xFF2ECC71), size: 24),
        const SizedBox(width: 12),
        Text('XCORE',
            style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w900,
                color: const Color(0xFF2ECC71), letterSpacing: 1.0)),
      ]),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          // Instagram-style placeholder avatar — no network image
          child: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceContainerHigh,
              border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3), width: 1),
            ),
            child: const Icon(Icons.person_rounded, color: AppColors.onSurfaceVariant, size: 22),
          ),
        ),
      ],
    );
  }

  // ── Footer ─────────────────────────────────
  Widget _buildFooter() {
    final isReady = _pinDigits.length == _pinLength;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        GestureDetector(
          onTap: _onEnterShift,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity, height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: isReady ? AppGradients.primaryCta : null,
              color: isReady ? null : AppColors.surfaceContainerHighest,
              boxShadow: isReady ? AppShadows.primaryGlow : null,
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('ENTER SHIFT', style: GoogleFonts.manrope(
                  fontSize: 15, fontWeight: FontWeight.w800,
                  color: isReady ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                  letterSpacing: 1.4)),
              const SizedBox(width: 10),
              Icon(Icons.login_rounded, size: 20,
                  color: isReady ? AppColors.onPrimary : AppColors.onSurfaceVariant),
            ]),
          ),
        ),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          TextButton(onPressed: () {},
              style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
              child: Text('نسيت الـ PIN؟', style: GoogleFonts.manrope(
                  fontSize: 11, fontWeight: FontWeight.w700,
                  color: AppColors.onSurfaceVariant, letterSpacing: 0.5))),
          TextButton(onPressed: () {},
              style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
              child: Text('تجاوز المدير', style: GoogleFonts.manrope(
                  fontSize: 11, fontWeight: FontWeight.w700,
                  color: AppColors.onSurfaceVariant, letterSpacing: 0.5))),
        ]),
      ]),
    );
  }
}
