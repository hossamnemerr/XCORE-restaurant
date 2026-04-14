import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────
//  COLOR TOKENS
// ─────────────────────────────────────────────
abstract final class AppColors {
  // Surfaces
  static const Color background       = Color(0xFF121212);
  static const Color surface          = Color(0xFF0E0E0E);
  static const Color surfaceContainerLowest = Color(0xFF000000);
  static const Color surfaceContainerLow   = Color(0xFF131313);
  static const Color surfaceContainer      = Color(0xFF1A1A1A);
  static const Color surfaceContainerHigh  = Color(0xFF1E1E1E);
  static const Color surfaceContainerHighest = Color(0xFF262626);
  static const Color surfaceBright     = Color(0xFF2C2C2C);
  static const Color surfaceVariant    = Color(0xFF262626);

  // Primary (Mint Green)
  static const Color primary           = Color(0xFF6BFE9C);
  static const Color primaryDim        = Color(0xFF5BEF90);
  static const Color primaryContainer  = Color(0xFF1FC46A);
  static const Color onPrimary         = Color(0xFF005F2F);
  static const Color onPrimaryFixed    = Color(0xFF004A23);
  static const Color inversePrimary    = Color(0xFF006E37);

  // Secondary
  static const Color secondary         = Color(0xFF72FBBD);
  static const Color secondaryDim      = Color(0xFF63ECAF);
  static const Color secondaryContainer = Color(0xFF006C49);
  static const Color onSecondary       = Color(0xFF005E3E);

  // Tertiary
  static const Color tertiary          = Color(0xFF7EE6FF);
  static const Color tertiaryContainer = Color(0xFF00DCFF);
  static const Color onTertiary        = Color(0xFF005361);

  // On-colors
  static const Color onSurface        = Color(0xFFFFFFFF);
  static const Color onSurfaceVariant = Color(0xFFADAAAA);
  static const Color onBackground     = Color(0xFFFFFFFF);

  // Outline
  static const Color outline          = Color(0xFF767575);
  static const Color outlineVariant   = Color(0xFF484847);

  // Error
  static const Color error            = Color(0xFFFF716C);
  static const Color errorDim         = Color(0xFFD7383B);
  static const Color errorContainer   = Color(0xFF9F0519);
  static const Color onError          = Color(0xFF490006);
  static const Color onErrorContainer = Color(0xFFFFA8A3);

  // Inverse
  static const Color inverseSurface   = Color(0xFFFCF9F8);
  static const Color inverseOnSurface = Color(0xFF565555);
}

// ─────────────────────────────────────────────
//  GRADIENT HELPERS
// ─────────────────────────────────────────────
abstract final class AppGradients {
  /// Signature mint-to-green CTA gradient (135°)
  static const LinearGradient primaryCta = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, AppColors.primaryContainer],
  );

  /// Subtle ambient background glow
  static const RadialGradient ambientGlow = RadialGradient(
    center: Alignment.topRight,
    radius: 1.4,
    colors: [Color(0x0D6BFE9C), Color(0x00000000)],
  );
}

// ─────────────────────────────────────────────
//  SHADOW TOKENS
// ─────────────────────────────────────────────
abstract final class AppShadows {
  /// Floating bottom bar / summary tray
  static const List<BoxShadow> floatingBar = [
    BoxShadow(
      color: Colors.black54,
      blurRadius: 32,
      offset: Offset(0, -12),
    ),
  ];

  /// Elevated modal / bottom sheet
  static const List<BoxShadow> modal = [
    BoxShadow(
      color: Color(0x80000000),
      blurRadius: 32,
      offset: Offset(0, 12),
    ),
  ];

  /// Primary CTA glow
  static const List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: Color(0x336BFE9C),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];
}

// ─────────────────────────────────────────────
//  BORDER RADIUS TOKENS
// ─────────────────────────────────────────────
abstract final class AppRadius {
  static const double card    = 16.0;
  static const double button  = 12.0;
  static const double chip    = 10.0;
  static const double input   = 16.0;
  static const double avatar  = 999.0;
  static const double sheet   = 28.0;  // bottom sheet top corners

  static BorderRadius cardAll   = BorderRadius.circular(card);
  static BorderRadius buttonAll = BorderRadius.circular(button);
  static BorderRadius chipAll   = BorderRadius.circular(chip);
  static BorderRadius inputAll  = BorderRadius.circular(input);
  static BorderRadius sheetTop  = const BorderRadius.vertical(
    top: Radius.circular(sheet),
  );
}

// ─────────────────────────────────────────────
//  SPACING
// ─────────────────────────────────────────────
abstract final class AppSpacing {
  static const double xs   = 4.0;
  static const double sm   = 8.0;
  static const double md   = 12.0;
  static const double base = 16.0;
  static const double lg   = 20.0;
  static const double xl   = 24.0;
  static const double xxl  = 32.0;
  static const double xxxl = 48.0;
}

// ─────────────────────────────────────────────
//  TEXT THEME  (Manrope via google_fonts)
// ─────────────────────────────────────────────
TextTheme _buildTextTheme() {
  // Helper: create a Manrope TextStyle
  TextStyle m(double size, FontWeight weight, {double spacing = 0}) =>
      GoogleFonts.manrope(
        fontSize: size,
        fontWeight: weight,
        letterSpacing: spacing,
        color: AppColors.onSurface,
      );

  return TextTheme(
    // ── Display ──────────────────────────────
    // Used for totals, hero numbers, table numbers
    displayLarge: m(57, FontWeight.w800, spacing: -1.14),
    displayMedium: m(45, FontWeight.w800, spacing: -0.9),
    displaySmall: m(36, FontWeight.w800, spacing: -0.72),

    // ── Headline ─────────────────────────────
    // Page titles ("Orders Table 14"), section headers
    headlineLarge: m(40, FontWeight.w800, spacing: -0.8),
    headlineMedium: m(28, FontWeight.w800, spacing: -0.56),
    headlineSmall: m(24, FontWeight.w800, spacing: -0.48),

    // ── Title ────────────────────────────────
    // Menu item names, card primary text
    titleLarge: m(20, FontWeight.w700, spacing: -0.3),
    titleMedium: m(16, FontWeight.w700, spacing: -0.2),
    titleSmall: m(14, FontWeight.w600, spacing: -0.1),

    // ── Body ─────────────────────────────────
    // Descriptions, secondary information
    bodyLarge: m(16, FontWeight.w500),
    bodyMedium: m(14, FontWeight.w500),
    bodySmall: m(12, FontWeight.w400),

    // ── Label ────────────────────────────────
    // Modifiers, chips, nav labels — tight tracking + uppercase in usage
    labelLarge: m(12, FontWeight.w700, spacing: 1.2),
    labelMedium: m(10, FontWeight.w700, spacing: 1.6),
    labelSmall: m(9, FontWeight.w700, spacing: 1.8),
  );
}

// ─────────────────────────────────────────────
//  COLOR SCHEME
// ─────────────────────────────────────────────
const ColorScheme _colorScheme = ColorScheme(
  brightness: Brightness.dark,

  // Primary
  primary: AppColors.primary,
  onPrimary: AppColors.onPrimary,
  primaryContainer: AppColors.primaryContainer,
  onPrimaryContainer: Color(0xFF003417),

  // Secondary
  secondary: AppColors.secondary,
  onSecondary: AppColors.onSecondary,
  secondaryContainer: AppColors.secondaryContainer,
  onSecondaryContainer: Color(0xFFE1FFEB),

  // Tertiary
  tertiary: AppColors.tertiary,
  onTertiary: AppColors.onTertiary,
  tertiaryContainer: AppColors.tertiaryContainer,
  onTertiaryContainer: Color(0xFF004956),

  // Error
  error: AppColors.error,
  onError: AppColors.onError,
  errorContainer: AppColors.errorContainer,
  onErrorContainer: AppColors.onErrorContainer,

  // Surfaces
  surface: AppColors.surface,
  onSurface: AppColors.onSurface,
  surfaceContainerHighest: AppColors.surfaceContainerHighest,
  surfaceContainerHigh: AppColors.surfaceContainerHigh,
  surfaceContainer: AppColors.surfaceContainer,
  surfaceContainerLow: AppColors.surfaceContainerLow,
  surfaceContainerLowest: AppColors.surfaceContainerLowest,

  onSurfaceVariant: AppColors.onSurfaceVariant,
  outline: AppColors.outline,
  outlineVariant: AppColors.outlineVariant,

  // Inverse
  inverseSurface: AppColors.inverseSurface,
  onInverseSurface: AppColors.inverseOnSurface,
  inversePrimary: AppColors.inversePrimary,

  // Scrim / shadow
  scrim: Color(0xFF000000),
  shadow: Color(0xFF000000),
);

// ─────────────────────────────────────────────
//  COMPONENT THEMES
// ─────────────────────────────────────────────

AppBarTheme _appBarTheme() => AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      titleTextStyle: GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w900,
        color: AppColors.primary,
        letterSpacing: -0.36,
      ),
    );

CardThemeData _cardTheme() => CardThemeData(
      color: AppColors.surfaceContainerHigh,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.cardAll),
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
    );

ElevatedButtonThemeData _elevatedButtonTheme() => ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.surfaceContainerHighest;
          }
          return AppColors.primary;
        }),
        foregroundColor: WidgetStateProperty.all(AppColors.onPrimary),
        overlayColor: WidgetStateProperty.all(
          AppColors.onPrimary.withValues(alpha: 0.08),
        ),
        elevation: WidgetStateProperty.all(0),
        shadowColor: WidgetStateProperty.all(Colors.transparent),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.base,
          ),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: AppRadius.buttonAll),
        ),
        textStyle: WidgetStateProperty.all(
          GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
          ),
        ),
        animationDuration: const Duration(milliseconds: 150),
      ),
    );

OutlinedButtonThemeData _outlinedButtonTheme() => OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(AppColors.onSurface),
        overlayColor: WidgetStateProperty.all(
          AppColors.onSurface.withValues(alpha: 0.06),
        ),
        side: WidgetStateProperty.all(
          const BorderSide(color: AppColors.outlineVariant, width: 1),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.base,
          ),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: AppRadius.buttonAll),
        ),
      ),
    );

TextButtonThemeData _textButtonTheme() => TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(AppColors.primary),
        overlayColor: WidgetStateProperty.all(
          AppColors.primary.withValues(alpha: 0.08),
        ),
        textStyle: WidgetStateProperty.all(
          GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
        ),
      ),
    );

InputDecorationTheme _inputDecorationTheme() => InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceContainerLowest,
      // No border by default — "No-Line" rule
      border: OutlineInputBorder(
        borderRadius: AppRadius.inputAll,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.inputAll,
        borderSide: BorderSide.none,
      ),
      // Soft primary halo on focus — "Ghost Border" rule
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.inputAll,
        borderSide: BorderSide(
          color: AppColors.primaryDim.withValues(alpha: 0.4),
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.inputAll,
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppRadius.inputAll,
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.base,
      ),
      hintStyle: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.outline,
      ),
      labelStyle: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurfaceVariant,
      ),
      floatingLabelStyle: GoogleFonts.manrope(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
        letterSpacing: 0.8,
      ),
    );

ChipThemeData _chipTheme() => ChipThemeData(
      backgroundColor: AppColors.surfaceContainerHigh,
      selectedColor: AppColors.primaryContainer,
      disabledColor: AppColors.surfaceContainerHighest,
      labelStyle: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
      secondaryLabelStyle: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.onPrimary,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.sm,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.chip),
        side: BorderSide.none,
      ),
      side: BorderSide.none,
      elevation: 0,
    );

BottomNavigationBarThemeData _bottomNavTheme() =>
    const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.onPrimary,
      unselectedItemColor: AppColors.onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    );

NavigationBarThemeData _navigationBarTheme() => NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: AppColors.primaryContainer,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final isSelected = states.contains(WidgetState.selected);
        return GoogleFonts.manrope(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final isSelected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
          size: 24,
        );
      }),
      height: 64,
      elevation: 0,
    );

DividerThemeData _dividerTheme() => const DividerThemeData(
      // Effectively invisible — use SizedBox for spacing instead
      color: Colors.transparent,
      thickness: 0,
      space: 0,
    );

SnackBarThemeData _snackBarTheme() => SnackBarThemeData(
      backgroundColor: AppColors.surfaceContainerHigh,
      contentTextStyle: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurface,
      ),
      actionTextColor: AppColors.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.cardAll),
      elevation: 0,
    );

DialogThemeData _dialogTheme() => DialogThemeData(
      backgroundColor: AppColors.surfaceContainerHigh,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.cardAll),
      titleTextStyle: GoogleFonts.manrope(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: AppColors.onSurface,
        letterSpacing: -0.44,
      ),
      contentTextStyle: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurfaceVariant,
      ),
    );

BottomSheetThemeData _bottomSheetTheme() => const BottomSheetThemeData(
      backgroundColor: AppColors.surfaceContainerHigh,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      modalElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.sheet),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      dragHandleColor: AppColors.surfaceContainerHighest,
      dragHandleSize: Size(48, 4),
    );

SwitchThemeData _switchTheme() => SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.onPrimary;
        return AppColors.outline;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.surfaceContainerHighest;
      }),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    );

CheckboxThemeData _checkboxTheme() => CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary;
        return AppColors.surfaceVariant;
      }),
      checkColor: WidgetStateProperty.all(AppColors.onPrimary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      side: const BorderSide(color: AppColors.outlineVariant, width: 1.5),
    );

RadioThemeData _radioTheme() => RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary;
        return AppColors.outlineVariant;
      }),
    );

IconButtonThemeData _iconButtonTheme() => IconButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(
          AppColors.onSurface.withValues(alpha: 0.08),
        ),
        foregroundColor: WidgetStateProperty.all(AppColors.onSurfaceVariant),
      ),
    );

FloatingActionButtonThemeData _fabTheme() =>
    const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.button)),
      ),
    );

// ─────────────────────────────────────────────
//  MAIN THEME
// ─────────────────────────────────────────────
abstract final class AppTheme {
  static ThemeData get dark {
    final textTheme = _buildTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      splashColor: AppColors.primary.withValues(alpha: 0.06),
      highlightColor: AppColors.primary.withValues(alpha: 0.04),
      splashFactory: InkRipple.splashFactory,

      // ── Typography ───────────────────────
      textTheme: textTheme,
      primaryTextTheme: textTheme,

      // ── Icons ────────────────────────────
      iconTheme: const IconThemeData(
        color: AppColors.onSurfaceVariant,
        size: 24,
      ),
      primaryIconTheme: const IconThemeData(
        color: AppColors.primary,
        size: 24,
      ),

      // ── Component Themes ─────────────────
      appBarTheme: _appBarTheme(),
      cardTheme: _cardTheme(),
      elevatedButtonTheme: _elevatedButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(),
      textButtonTheme: _textButtonTheme(),
      iconButtonTheme: _iconButtonTheme(),
      floatingActionButtonTheme: _fabTheme(),
      inputDecorationTheme: _inputDecorationTheme(),
      chipTheme: _chipTheme(),
      bottomNavigationBarTheme: _bottomNavTheme(),
      navigationBarTheme: _navigationBarTheme(),
      dividerTheme: _dividerTheme(),
      snackBarTheme: _snackBarTheme(),
      dialogTheme: _dialogTheme(),
      bottomSheetTheme: _bottomSheetTheme(),
      switchTheme: _switchTheme(),
      checkboxTheme: _checkboxTheme(),
      radioTheme: _radioTheme(),

      // ── Page Transitions ─────────────────
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
