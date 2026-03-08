import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Gruda App Theme - Vintage/Art Deco inspired Dark Mode Theme
///
/// Color Palette:
/// - Background: #4A2624 (Deep warm burgundy/mahogany)
/// - Primary/Accent: #E89596 (Dusty muted pink/rose)
/// - Text Primary: #FFFFFF (White)
/// - Text Secondary: #E0D8D8 (Muted white/gray)
/// - Surface/Cards: #5A3230 (Slightly lighter mahogany)

class AppTheme {
  // Color definitions
  static const Color _primaryBackgroundColor = Color(0xFF4A2624);
  static const Color _primaryAccentColor = Color(0xFFE89596);
  static const Color _textPrimaryColor = Color(0xFFFFFFFF);
  static const Color _textSecondaryColor = Color(0xFFE0D8D8);
  static const Color _surfaceColor = Color(0xFF5A3230);
  static const Color _borderColor = Color(0xFFE89596);

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _primaryBackgroundColor,
      primaryColor: _primaryAccentColor,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: _primaryAccentColor,
        onPrimary: _primaryBackgroundColor,
        secondary: _textSecondaryColor,
        onSecondary: _primaryBackgroundColor,
        tertiary: _borderColor,
        surface: _surfaceColor,
        onSurface: _textPrimaryColor,
        error: Color(0xFFE74C3C),
        onError: _textPrimaryColor,
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryBackgroundColor,
        foregroundColor: _textPrimaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: _textPrimaryColor,
          letterSpacing: 1.5,
        ),
      ),

      // Text Themes
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: _textPrimaryColor,
          letterSpacing: 1.5,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: _textPrimaryColor,
          letterSpacing: 1.2,
        ),
        displaySmall: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: _textPrimaryColor,
          letterSpacing: 1.0,
        ),
        headlineLarge: GoogleFonts.playfairDisplay(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: _textPrimaryColor,
          letterSpacing: 0.8,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: _textPrimaryColor,
          letterSpacing: 0.6,
        ),
        headlineSmall: GoogleFonts.playfairDisplay(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: _textPrimaryColor,
          letterSpacing: 0.4,
        ),
        titleLarge: GoogleFonts.montserrat(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _textPrimaryColor,
          letterSpacing: 0.2,
        ),
        titleMedium: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _textPrimaryColor,
        ),
        titleSmall: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: _textSecondaryColor,
        ),
        bodyLarge: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: _textPrimaryColor,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: _textPrimaryColor,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: _textSecondaryColor,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: _primaryAccentColor,
        ),
        labelMedium: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _primaryAccentColor,
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryAccentColor,
          foregroundColor: _primaryBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 4,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryAccentColor,
          side: const BorderSide(color: _primaryAccentColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryAccentColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _primaryAccentColor, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _primaryAccentColor, width: 2),
        ),
        hintStyle: GoogleFonts.montserrat(color: _textSecondaryColor),
        labelStyle: GoogleFonts.montserrat(color: _primaryAccentColor),
      ),

      // Card Theme (Poprawiona nazwa i usunięta ramka)
      cardTheme: CardThemeData(
        color: _surfaceColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: _textPrimaryColor, size: 24),

      // Switch Theme (Poprawione na WidgetState)
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _primaryAccentColor;
          }
          return _textSecondaryColor;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _primaryAccentColor.withValues(alpha: 0.5);
          }
          return _surfaceColor;
        }),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: _surfaceColor,
        selectedColor: _primaryAccentColor,
        side: const BorderSide(color: _borderColor),
        labelStyle: GoogleFonts.montserrat(
          color: _textPrimaryColor,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: _borderColor),
        ),
      ),

      // Dialog Theme (Poprawiona nazwa)
      dialogTheme: DialogThemeData(
        backgroundColor: _surfaceColor,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: _textPrimaryColor,
        ),
        contentTextStyle: GoogleFonts.montserrat(
          fontSize: 14,
          color: _textPrimaryColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: _borderColor, width: 1),
        ),
      ),
    );
  }

  /// Light theme (optional, for completeness)
  static ThemeData get lightTheme {
    return ThemeData.light();
  }
}
