
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'theme/app_theme.dart';
import 'providers/cart_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/order_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF121212),
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
  runApp(const MidnightSommelierApp());
}

class MidnightSommelierApp extends StatefulWidget {
  const MidnightSommelierApp({super.key});
  @override
  State<MidnightSommelierApp> createState() => _MidnightSommelierAppState();
}

class _MidnightSommelierAppState extends State<MidnightSommelierApp> {
  // Single cart instance — lives above MaterialApp, survives all route changes
  final CartNotifier _cart = CartNotifier();

  @override
  void dispose() {
    _cart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CartProvider(
      notifier: _cart,
      child: MaterialApp(
        title: 'XCORE',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        initialRoute: '/',
        routes: {
          '/':        (_) => const SplashScreen(),
          '/login':   (_) => const LoginScreen(),
          '/menu':    (_) => const MenuScreen(),
          '/orders':  (_) => const OrderScreen(),
          '/tables':  (_) => const _StubScreen(title: 'Tables'),
          '/billing': (_) => const _StubScreen(title: 'Billing'),
        },
        scrollBehavior: const _AppScrollBehavior(),
        builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
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
}

class _AppScrollBehavior extends ScrollBehavior {
  const _AppScrollBehavior();
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) => child;
}

class _StubScreen extends StatelessWidget {
  final String title;
  const _StubScreen({required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(title.toUpperCase(),
            style: const TextStyle(color: Color(0xFF2ECC71), fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1.2)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.of(context).pop()),
      ),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.construction_rounded, size: 48, color: AppColors.outlineVariant),
          const SizedBox(height: 16),
          Text('$title screen coming soon', style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant)),
        ]),
      ),
    );
  }
}
