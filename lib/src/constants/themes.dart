import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Made for FlexColorScheme version 7.0.0. Make sure you
// use same or higher package version, but still same major version.
// If you use a lower version, some properties may not be supported.
// In that case remove them after copying this theme to your app.
///
/// | NAME           | SIZE |  WEIGHT |  SPACING |             |
/// |----------------|------|---------|----------|-------------|
/// | displayLarge   | 96.0 | light   | -1.5     |             |
/// | displayMedium  | 60.0 | light   | -0.5     |             |
/// | displaySmall   | 48.0 | regular |  0.0     |             |
/// | headlineMedium | 34.0 | regular |  0.25    |             |
/// | headlineSmall  | 24.0 | regular |  0.0     |             |
/// | titleLarge     | 20.0 | medium  |  0.15    |             |
/// | titleMedium    | 16.0 | regular |  0.15    |             |
/// | titleSmall     | 14.0 | medium  |  0.1     |             |
/// | bodyLarge      | 16.0 | regular |  0.5     |             |
/// | bodyMedium     | 14.0 | regular |  0.25    |             |
/// | bodySmall      | 12.0 | regular |  0.4     |             |
/// | labelLarge     | 14.0 | medium  |  1.25    |             |
/// | labelSmall     | 10.0 | regular |  1.5     |             |
///
/// ...where "light" is `FontWeight.w300`, "regular" is `FontWeight.w400` and
/// "medium" is `FontWeight.w500`.
final lightTheme = FlexThemeData.light(
  // APPLE SYSTEM PALETTE. Every value below is read from Flutter's own
  // packages/flutter/lib/src/cupertino/colors.dart, which carries Apple's published UIColor
  // values - not an eyeballed imitation of them:
  //
  //   systemMint              #00C7BE light / #63E6E2 dark   -> primary, see the note below
  //   systemBackground        #FFFFFF light / #1C1C1E dark   -> surface (elevated dark)
  //   systemGroupedBackground #F2F2F7 light / #000000 dark   -> scaffoldBackground
  //   label                   #000000 light / #FFFFFF dark   -> onSurface
  //   systemRed               #FF3B30 light / #FF453A dark   -> error
  //   systemGray              #8E8E93                        -> tertiary (dark)
  //
  // The dark page is true black, which is what iOS does and what the owner asked for. The
  // card at #1C1C1E is Apple's own elevated background, so the separation between page and
  // card is Apple's, not a number chosen here.
  //
  // THE ONE DELIBERATE DEVIATION, and it is measured rather than judged: Apple's own
  // systemMint #00C7BE scores 2.12:1 on white and 1.90:1 on #F2F2F7 - it fails text
  // contrast badly, because iOS uses it on tinted glass and not as a label on paper. The
  // light accent is therefore the same hue darkened to #007A75, which measures 5.20:1 on
  // white and 4.66:1 on the grouped background, both clearing 4.5:1.
  //
  // The dark accent is Apple's systemMint too, but its LIGHT-mode value #00C7BE rather
  // than its dark one. #63E6E2 was tried first and read as washed-out neon on black: it is
  // 90% lightness, which iOS gets away with on tinted glass and this page does not. #00C7BE
  // keeps the colour saturated and still scores 8.03:1 on the #1C1C1E card.
  colors: const FlexSchemeColor(
    primary: Color(0xff007A75),
    primaryContainer: Color(0xffCFF1EF),
    secondary: Color(0xff3C3C43),
    secondaryContainer: Color(0xffE5E5EA),
    tertiary: Color(0xff6C6C70),
    tertiaryContainer: Color(0xffE5E5EA),
    appBarColor: Color(0xffF2F2F7),
    error: Color(0xffFF3B30),
  ),
  surfaceMode: FlexSurfaceMode.level,
  blendLevel: 0,
  // The light theme used to let the blend compute its surfaces. They are pinned now for
  // the same reason the dark ones are: a blend tints every surface toward the primary, and
  // the identity is a neutral field with one blue accent, not a blue page.
  surface: const Color(0xffFFFFFF),
  scaffoldBackground: const Color(0xffF2F2F7),
  onSurface: const Color(0xff000000),
  // scheme: FlexScheme.bahamaBlue,
  // surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  // blendLevel: 7,
  // subThemesData: const FlexSubThemesData(
  //   blendOnLevel: 10,
  //   blendOnColors: false,
  //   useTextTheme: true,
  //   alignedDropdown: true,
  //   useInputDecoratorThemeInDialogs: true,
  // ),
  // scheme: FlexScheme.blumineBlue,
  // scheme: FlexScheme.mandyRed,
  // background: Colors.white,
  // scaffoldBackground: Colors.white,
  // colors: FlexSchemeColor.from(primary: Colors.white //Color(0xffbfd7ed),
  //     // primaryContainer: Color(0xff0074b7),
  //     // secondary: Color(0xff60a3d9),
  //     // secondaryContainer: Color(0xff003b73),
  //     // tertiary: Color(0xff8a9cbb),
  //     // tertiaryContainer: Color(0xff000000),
  //     // appBarColor: Color(0xff003b73),
  //     // error: Color(0xffb00020),
  //     ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 57),
    displayMedium: TextStyle(fontSize: 45),
    displaySmall: TextStyle(fontSize: 36),
    headlineLarge: TextStyle(fontSize: 32),
    headlineMedium: TextStyle(fontSize: 28),
    headlineSmall: TextStyle(fontSize: 26),
    titleLarge: TextStyle(fontSize: 24),
    titleMedium: TextStyle(fontSize: 18),
    titleSmall: TextStyle(fontSize: 16),
    bodyLarge: TextStyle(fontSize: 18),
    bodyMedium: TextStyle(fontSize: 16),
    bodySmall: TextStyle(fontSize: 14),
  ),
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 0,
    blendOnColors: false,
    useTextTheme: true,
    useM2StyleDividerInM3: true,
    alignedDropdown: true,
    useInputDecoratorThemeInDialogs: true,
    interactionEffects: false,
    tintedDisabledControls: false,
    inputDecoratorBorderType: FlexInputBorderType.underline,
    inputDecoratorUnfocusedBorderIsColored: false,
    chipRadius: 20.0,
    tooltipRadius: 4.0,
    tooltipSchemeColor: SchemeColor.inverseSurface,
    tooltipOpacity: 0.9,
    snackBarElevation: 6.0,
    snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
    navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
    navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
    navigationBarMutedUnselectedLabel: false,
    navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
    navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
    navigationBarMutedUnselectedIcon: false,
    navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
    navigationBarIndicatorOpacity: 1.00,
    navigationRailSelectedLabelSchemeColor: SchemeColor.onSurface,
    navigationRailUnselectedLabelSchemeColor: SchemeColor.onSurface,
    navigationRailMutedUnselectedLabel: false,
    navigationRailSelectedIconSchemeColor: SchemeColor.onSurface,
    navigationRailUnselectedIconSchemeColor: SchemeColor.onSurface,
    navigationRailMutedUnselectedIcon: false,
    navigationRailIndicatorSchemeColor: SchemeColor.secondaryContainer,
    navigationRailIndicatorOpacity: 1.00,
    navigationRailBackgroundSchemeColor: SchemeColor.surface,
    navigationRailLabelType: NavigationRailLabelType.none,
  ),
  keyColors: const FlexKeyColors(
    useSecondary: true,
    keepPrimary: true,
    keepSecondary: true,
    keepTertiary: true,
    keepPrimaryContainer: true,
    keepSecondaryContainer: true,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  // To use the playground font, add GoogleFonts package and uncomment
  // fontFamily: GoogleFonts.notoSans().fontFamily,
  fontFamily: GoogleFonts.nunito().fontFamily,
);

final darkTheme = FlexThemeData.dark(
  // scheme: FlexScheme.indigo,
  // background: Colors.black12,
  // scaffoldBackground: Colors.black12,
  // colors: const FlexSchemeColor(
  //   primary: Color(0xff274472),
  //   primaryContainer: Color(0xff41729f),
  //   secondary: Color(0xff122035),
  //   secondaryContainer: Color(0xffc3e0e5),
  //   tertiary: Color(0xff8a9cbb),
  //   tertiaryContainer: Color(0xff000000),
  //   appBarColor: Color(0xffc3e0e5),
  //   error: Color(0xffcf6679),
  // ),
  colors: const FlexSchemeColor(
    primary: Color(0xff00C7BE),
    primaryContainer: Color(0xff07403D),
    secondary: Color(0xffEBEBF5),
    secondaryContainer: Color(0xff2C2C2E),
    tertiary: Color(0xff8E8E93),
    tertiaryContainer: Color(0xff2C2C2E),
    appBarColor: Color(0xff1C1C1E),
    error: Color(0xffFF453A),
  ),
  // Surfaces are pinned rather than blended, and blendLevel/blendOnLevel are both 0.
  // FlexColorScheme otherwise tints every surface AND every on-colour toward the primary,
  // which both turns the page blue and washes out the accent - the opposite of the iOS
  // look, where the greys are neutral and the accent is the one saturated thing.
  surfaceMode: FlexSurfaceMode.level,
  blendLevel: 0,
  scaffoldBackground: const Color(0xff000000),
  surface: const Color(0xff1C1C1E),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 57),
    displayMedium: TextStyle(fontSize: 45),
    displaySmall: TextStyle(fontSize: 36),
    headlineLarge: TextStyle(fontSize: 32),
    headlineMedium: TextStyle(fontSize: 28),
    headlineSmall: TextStyle(fontSize: 26),
    titleLarge: TextStyle(fontSize: 24),
    titleMedium: TextStyle(fontSize: 18),
    titleSmall: TextStyle(fontSize: 16),
    bodyLarge: TextStyle(fontSize: 18),
    bodyMedium: TextStyle(fontSize: 16),
    bodySmall: TextStyle(fontSize: 14),
  ),
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 0,
    blendOnColors: false,
    useTextTheme: true,
    useM2StyleDividerInM3: true,
    alignedDropdown: true,
    useInputDecoratorThemeInDialogs: true,
    //dbdfbf/dbf/bdf
    interactionEffects: false,
    tintedDisabledControls: false,
    inputDecoratorBorderType: FlexInputBorderType.underline,
    inputDecoratorUnfocusedBorderIsColored: false,
    chipRadius: 20.0,
    tooltipRadius: 4.0,
    tooltipSchemeColor: SchemeColor.inverseSurface,
    tooltipOpacity: 0.9,
    snackBarElevation: 6.0,
    snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
    navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
    navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
    navigationBarMutedUnselectedLabel: false,
    navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
    navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
    navigationBarMutedUnselectedIcon: false,
    navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
    navigationBarIndicatorOpacity: 1.00,
    navigationRailSelectedLabelSchemeColor: SchemeColor.onSurface,
    navigationRailUnselectedLabelSchemeColor: SchemeColor.onSurface,
    navigationRailMutedUnselectedLabel: false,
    navigationRailSelectedIconSchemeColor: SchemeColor.onSurface,
    navigationRailUnselectedIconSchemeColor: SchemeColor.onSurface,
    navigationRailMutedUnselectedIcon: false,
    navigationRailIndicatorSchemeColor: SchemeColor.secondaryContainer,
    navigationRailIndicatorOpacity: 1.00,
    navigationRailBackgroundSchemeColor: SchemeColor.surface,
    navigationRailLabelType: NavigationRailLabelType.none,
  ),
  keyColors: const FlexKeyColors(
    useSecondary: true,
    keepPrimary: true,
    keepSecondary: true,
    keepTertiary: true,
    keepPrimaryContainer: true,
    keepSecondaryContainer: true,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  // To use the Playground font, add GoogleFonts package and uncomment
  // fontFamily: GoogleFonts.notoSans().fontFamily,
  fontFamily: GoogleFonts.nunito().fontFamily,
);
