import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'theme/app_theme.dart';
import 'providers/cart_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/order_screen.dart';
import 'widgets/bottom_nav_bar.dart'; // إضافة هذا السطر لإصلاح الخطأ

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF121212),
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  runApp(const XCoreApp());
}

class XCoreApp extends StatefulWidget {
  const XCoreApp({super.key});
  @override
  State<XCoreApp> createState() => _XCoreAppState();
}

class _XCoreAppState extends State<XCoreApp> {
  final _cart = CartNotifier();
  @override void dispose() { _cart.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => CartProvider(
    notifier: _cart,
    child: MaterialApp(
      title: 'XCORE',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark, darkTheme: AppTheme.dark, themeMode: ThemeMode.dark,
      initialRoute: '/',
      routes: {
        '/':        (_) => const SplashScreen(),
        '/login':   (_) => const LoginScreen(),
        '/menu':    (_) => const MenuScreen(),
        '/orders':  (_) => const OrderScreen(),
        '/tables':  (_) => const _StubScreen('Tables'),
        '/billing': (_) => const _StubScreen('Billing'),
      },
      scrollBehavior: const _BouncingScrollBehavior(),
      builder: (_, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Color(0xFF121212),
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: child!,
      ),
    ),
  );
}

class _BouncingScrollBehavior extends ScrollBehavior {
  const _BouncingScrollBehavior();
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails _) => child;
}

class _StubScreen extends StatelessWidget {
  final String title;
  const _StubScreen(this.title);

  int _getIndex() {
    if (title.toLowerCase() == 'tables') return 0;
    if (title.toLowerCase() == 'billing') return 3;
    return 1;
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false, // منع الرجوع العادي الذي يسبب الشاشة السوداء
    onPopInvokedWithResult: (didPop, result) {
      if (didPop) return;
      // بدلاً من الخروج، نعود دائماً للمنيو
      Navigator.of(context).pushReplacementNamed('/menu');
    },
    child: Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background, elevation: 0,
        title: Text(title.toUpperCase(), style: const TextStyle(
            color: Color(0xFF2ECC71), fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1.2)),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/menu');
            }),
      ),
      body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.construction_rounded, size: 48, color: AppColors.outlineVariant),
        const SizedBox(height: 16),
        Text('$title screen coming soon', style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant)),
      ])),
      bottomNavigationBar: BottomNavBar(currentIndex: _getIndex()),
    ),
  );
}
