import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoFade, _titleFade, _subtitleFade, _footerFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
    _logoFade     = CurvedAnimation(parent: _controller, curve: const Interval(0.0,  0.40, curve: Curves.easeOut));
    _titleFade    = CurvedAnimation(parent: _controller, curve: const Interval(0.25, 0.60, curve: Curves.easeOut));
    _subtitleFade = CurvedAnimation(parent: _controller, curve: const Interval(0.45, 0.75, curve: Curves.easeOut));
    _footerFade   = CurvedAnimation(parent: _controller, curve: const Interval(0.65, 1.00, curve: Curves.easeOut));
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  Widget _glow(AlignmentGeometry a, double size) => Align(
    alignment: a,
    child: Transform.translate(
      offset: Offset(a == Alignment.topRight ? size * .4 : -size * .4,
                     a == Alignment.topRight ? -size * .4 : size * .4),
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
        child: Container(width: size, height: size,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0x0DFFFFFF))),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Stack(children: [
        _glow(Alignment.topRight, 320),
        _glow(Alignment.bottomLeft, 320),
        SafeArea(child: Column(children: [
          Expanded(child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            FadeTransition(opacity: _logoFade, child: const _LogoCluster()),
            const SizedBox(height: 24),
            FadeTransition(opacity: _titleFade, child: Text('XCORE',
              style: GoogleFonts.manrope(fontSize: 48, fontWeight: FontWeight.w800,
                  color: Colors.white, letterSpacing: -0.96, height: 1.0))),
            const SizedBox(height: 16),
            FadeTransition(opacity: _subtitleFade, child: Container(width: 240, height: 1,
              decoration: const BoxDecoration(gradient: LinearGradient(colors: [
                Colors.transparent, Color(0x33FFFFFF), Colors.transparent])))),
            const SizedBox(height: 16),
            FadeTransition(opacity: _subtitleFade, child: Text('ADVANCED HOSPITALITY SYSTEMS',
              style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w500,
                  color: Colors.white, letterSpacing: 3.2, height: 1.0))),
          ]))),
          FadeTransition(opacity: _footerFade, child: Padding(
            padding: const EdgeInsets.only(bottom: 64),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const SizedBox(width: 32, height: 32,
                child: CircularProgressIndicator(strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white))),
              const SizedBox(height: 12),
              Text('INITIALIZING CORE MODULES', style: GoogleFonts.manrope(
                  fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white, letterSpacing: 1.5)),
            ]),
          )),
        ])),
      ]),
    );
  }
}

class _LogoCluster extends StatelessWidget {
  const _LogoCluster();
  @override
  Widget build(BuildContext context) => SizedBox(width: 120, height: 120,
    child: Stack(alignment: Alignment.center, children: [
      ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(width: 80, height: 80,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0x26FFFFFF)))),
      const Icon(Icons.restaurant, size: 96, color: Colors.white),
    ]));
}
