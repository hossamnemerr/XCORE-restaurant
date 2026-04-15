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

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  static const _pinLength = 4;
  static const _correctPin = '1234';
  final List<String> _digits = [];
  bool _hasError = false;

  late final List<AnimationController> _keyCtrls;
  late final AnimationController _shakeCtrl;
  late final Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _keyCtrls = List.generate(12, (_) =>
        AnimationController(vsync: this, duration: const Duration(milliseconds: 120)));
    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0,   end: -12.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -12.0, end:  12.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin:  12.0, end: -10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10.0, end:  10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin:  10.0, end:  -6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin:  -6.0, end:   6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin:   6.0, end:   0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    for (final c in _keyCtrls) c.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  Future<void> _tap(int idx) async {
    await _keyCtrls[idx].forward();
    _keyCtrls[idx].reverse();
  }

  void _onDigit(String d, int idx) {
    HapticFeedback.lightImpact();
    _tap(idx);
    if (_digits.length >= _pinLength) return;
    setState(() {
      _hasError = false;
      _digits.add(d);
    });
    if (_digits.length == _pinLength) {
      _verify();
    }
  }

  void _onBack(int idx) {
    HapticFeedback.lightImpact(); _tap(idx);
    if (_digits.isEmpty) return;
    setState(() { _hasError = false; _digits.removeLast(); });
  }

  void _onClear(int idx) {
    HapticFeedback.mediumImpact(); _tap(idx);
    if (_digits.isEmpty) return;
    setState(() { _hasError = false; _digits.clear(); });
  }

  void _verify() async {
    await Future.delayed(const Duration(milliseconds: 150));
    if (_digits.join() == _correctPin) {
      if (mounted) Navigator.of(context).pushReplacementNamed('/menu');
    } else {
      HapticFeedback.heavyImpact();
      setState(() => _hasError = true);
      await _shakeCtrl.forward(from: 0);
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() { _digits.clear(); _hasError = false; });
    }
  }

  Widget _dot(int i) {
    final filled = i < _digits.length;
    final err = _hasError && filled;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: 16, height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: err ? AppColors.error : filled ? AppColors.primary : AppColors.surfaceContainerHighest,
        border: filled ? null : Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: filled && !err
            ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.45), blurRadius: 12, spreadRadius: 1)]
            : err
            ? [BoxShadow(color: AppColors.error.withValues(alpha: 0.5), blurRadius: 12, spreadRadius: 1)]
            : null,
      ),
    );
  }

  Widget _key({required int idx, String? digit, Widget? child, bool transparent = false,
    IconData? icon, Color? iconColor, VoidCallback? onTap}) {
    final scale = Tween<double>(begin: 1.0, end: 0.92)
        .animate(CurvedAnimation(parent: _keyCtrls[idx], curve: Curves.easeInOut));
    return ScaleTransition(
      scale: scale,
      child: GestureDetector(
        onTap: onTap ?? () => _onDigit(digit!, idx),
        child: AspectRatio(aspectRatio: 1,
          child: Container(
            decoration: transparent ? null : BoxDecoration(
                color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12)),
            child: Center(child: child ?? (digit != null
                ? Text(digit, style: GoogleFonts.manrope(
                fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white, height: 1.0))
                : Icon(icon, size: 28, color: iconColor ?? AppColors.onSurfaceVariant))),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isReady = _digits.length == _pinLength;
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E0E), elevation: 0,
        scrolledUnderElevation: 0, automaticallyImplyLeading: false, titleSpacing: 16,
        title: Row(children: [
          const Icon(Icons.menu, color: Color(0xFF2ECC71), size: 24), const SizedBox(width: 12),
          Text('XCORE', style: GoogleFonts.manrope(
              fontSize: 16, fontWeight: FontWeight.w900, color: const Color(0xFF2ECC71), letterSpacing: 1.0)),
        ]),
        actions: [Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Container(width: 40, height: 40,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.surfaceContainerHigh,
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3))),
              child: const Icon(Icons.person_rounded, color: AppColors.onSurfaceVariant, size: 22)),
        )],
      ),
      body: Stack(children: [
        // Corner glows
        for (final a in [Alignment.topRight, Alignment.bottomLeft])
          Align(alignment: a,
            child: Transform.translate(
              offset: a == Alignment.topRight ? const Offset(80, -80) : const Offset(-80, 80),
              child: ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                  child: Container(width: 300, height: 300,
                      decoration: BoxDecoration(shape: BoxShape.circle,
                          color: AppColors.primary.withValues(alpha: 0.05)))),
            ),
          ),
        SafeArea(child: Column(children: [
          Expanded(child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(children: [
              const SizedBox(height: 40),
              Text('تسجيل الدخول', style: GoogleFonts.manrope(
                  fontSize: 40, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.8),
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('ادخل الرمز سري', style: GoogleFonts.manrope(
                  fontSize: 14, color: AppColors.onSurfaceVariant), textAlign: TextAlign.center),
              const SizedBox(height: 32),
              AnimatedBuilder(
                animation: _shakeAnim,
                builder: (_, child) => Transform.translate(offset: Offset(_shakeAnim.value, 0), child: child!),
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pinLength, (i) =>
                        Padding(padding: EdgeInsets.only(left: i == 0 ? 0 : 16), child: _dot(i)))),
              ),
              const SizedBox(height: 40),
              GridView.count(crossAxisCount: 3, shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12, mainAxisSpacing: 12,
                children: [
                  for (int i = 1; i <= 9; i++) _key(idx: i - 1, digit: '$i'),
                  _key(idx: 9, icon: Icons.backspace_rounded, iconColor: AppColors.error,
                      transparent: true, onTap: () => _onBack(9)),
                  _key(idx: 10, digit: '0'),
                  _key(idx: 11, transparent: true, onTap: () => _onClear(11),
                      child: Text('C', style: GoogleFonts.manrope(
                          fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.onSurfaceVariant))),
                ],
              ),
              const SizedBox(height: 24),
            ]),
          )),
          // Footer
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              GestureDetector(
                onTap: isReady ? _verify : null,
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
                        fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 1.4,
                        color: isReady ? AppColors.onPrimary : AppColors.onSurfaceVariant)),
                    const SizedBox(width: 10),
                    Icon(Icons.login_rounded, size: 20,
                        color: isReady ? AppColors.onPrimary : AppColors.onSurfaceVariant),
                  ]),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(onPressed: () {},
                    child: Text('نسيت الرقم السري؟', style: GoogleFonts.manrope(
                        fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant))),
              ),
            ]),
          ),
        ])),
      ]),
    );
  }
}
