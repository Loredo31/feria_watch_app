import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WatchColors {
  static const background = Color(0xFFF4F4FB);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceLight = Color(0xFFEEEEF8);
  static const primary = Color(0xFF6B45F0);
  static const primaryLight = Color(0xFF9D82FF);
  static const secondary = Color(0xFF00A882);
  static const secondaryDark = Color(0xFF007A60);
  static const alert = Color(0xFFE53935);
  static const alertDark = Color(0xFFB71C1C);
  static const warning = Color(0xFFFF8F00);
  static const textPrimary = Color(0xFF1A1A3A);
  static const textSecondary = Color(0xFF4A4A7A);
  static const textMuted = Color(0xFF9090B0);
  static const border = Color(0xFFD4D4EC);
  static const cardBg = Color(0xFFFFFFFF);
  static const success = Color(0xFF2E7D32);
  static const successLight = Color(0xFF4CAF50);
  static const metalGradientStart = Color(0xFFD0D0E8);
  static const metalGradientEnd = Color(0xFFB0B0D0);
}

/// Medidas seguras para pantallas redondas de smartwatch.
///
/// En vez de usar paddings fijos en píxeles (pensados para un tamaño de
/// reloj específico), estas funciones calculan el espacio como un
/// porcentaje del tamaño real de la pantalla. Así el mismo diseño se ve
/// bien tanto en un Wear OS "Small Round" como en un "Large Round",
/// sin que el contenido quede recortado por las esquinas redondeadas.
class WatchMetrics {
  /// Espacio lateral seguro (evita que el texto toque el borde curvo).
  static double side(BuildContext context) =>
      MediaQuery.sizeOf(context).width * 0.11;

  /// Espacio superior/inferior seguro para pantallas con encabezado propio.
  static double edge(BuildContext context) =>
      MediaQuery.sizeOf(context).height * 0.065;

  /// Ancho/alto disponible de la pantalla actual.
  static Size screenSize(BuildContext context) => MediaQuery.sizeOf(context);
}

class WatchTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF0F0FA),
      colorScheme: const ColorScheme.light(
        primary: WatchColors.primary,
        secondary: WatchColors.secondary,
        surface: WatchColors.surface,
        error: WatchColors.alert,
      ),
      textTheme: GoogleFonts.outfitTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            color: WatchColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
          displayMedium: TextStyle(
            color: WatchColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            color: WatchColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: TextStyle(
            color: WatchColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(
            color: WatchColors.textPrimary,
            fontSize: 13,
          ),
          bodyMedium: TextStyle(
            color: WatchColors.textSecondary,
            fontSize: 11,
          ),
          bodySmall: TextStyle(
            color: WatchColors.textMuted,
            fontSize: 9,
          ),
        ),
      ),
    );
  }
}
