import 'package:flutter/material.dart';

class AppColors {
  // ============================================================================
  // COLORES PRINCIPALES DE LA MARCA - Inspirados en el mundo motero
  // ============================================================================
  
  // Naranja vibrante - Color principal (energía, aventura, velocidad)
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color primaryOrangeDark = Color(0xFFE85A2B);
  static const Color primaryOrangeLight = Color(0xFFFF8A5B);
  
  // Azul profundo - Color secundario (confianza, tecnología, cielo abierto)
  static const Color secondaryBlue = Color(0xFF2E86AB);
  static const Color secondaryBlueDark = Color(0xFF1E5F7C);
  static const Color secondaryBlueLight = Color(0xFF4A9BC1);
  
  // Gris antracita - Neutro sofisticado (asfalto, metal, modernidad)
  static const Color neutralCharcoal = Color(0xFF2C2C2E);
  static const Color neutralCharcoalLight = Color(0xFF48484A);
  
  // ============================================================================
  // TEMA CLARO - Colores frescos y energéticos
  // ============================================================================
  
  static const ColorScheme lightColorScheme = ColorScheme.light(
    // Colores principales
    primary: primaryOrange,
    primaryContainer: Color(0xFFFFE5DB),
    onPrimary: Colors.white,
    onPrimaryContainer: Color(0xFF8B2500),
    
    // Colores secundarios
    secondary: secondaryBlue,
    secondaryContainer: Color(0xFFD3E7F0),
    onSecondary: Colors.white,
    onSecondaryContainer: Color(0xFF0F2A3A),
    
    // Colores de superficie
    surface: Color(0xFFFAFAFA),
    onSurface: Color(0xFF1A1A1A),
    surfaceContainer: Color(0xFFF0F0F0),
    onSurfaceVariant: Color(0xFF5A5A5A),
    
    // Estados de error
    error: Color(0xFFD32F2F),
    onError: Colors.white,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    
    // Otros
    outline: Color(0xFFBDBDBD),
    outlineVariant: Color(0xFFE0E0E0),
    shadow: Color(0x33000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF313131),
    onInverseSurface: Color(0xFFF5F5F5),
    inversePrimary: Color(0xFFFFB59D),
  );
  
  // ============================================================================
  // TEMA OSCURO - Colores intensos y sofisticados
  // ============================================================================
  
  static const ColorScheme darkColorScheme = ColorScheme.dark(
    // Colores principales
    primary: primaryOrangeDark,
    primaryContainer: Color(0xFFB83A00),
    onPrimary: Color(0xFF5B1A00),
    onPrimaryContainer: Color(0xFFFFDAD1),
    
    // Colores secundarios
    secondary: Color(0xFFA8CCE0),
    secondaryContainer: Color(0xFF1E4A5F),
    onSecondary: Color(0xFF0F2A3A),
    onSecondaryContainer: Color(0xFFD3E7F0),
    
    // Colores de superficie
    surface: Color.fromARGB(255, 34, 34, 34),
    onSurface: Color(0xFFE8E8E8),
    surfaceContainer: Color(0xFF1E1E1E),
    onSurfaceVariant: Color(0xFFB8B8B8),

    
    // Estados de error
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    
    // Otros
    outline: Color(0xFF6A6A6A),
    outlineVariant: Color(0xFF404040),
    shadow: Color(0x33000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE8E8E8),
    onInverseSurface: Color(0xFF1A1A1A),
    inversePrimary: primaryOrange,
  );
  
  // ============================================================================
  // COLORES ESPECÍFICOS DE LA APP - Para mapas y funcionalidades especiales
  // ============================================================================
  
  // Colores para mapas y rutas
  static const Color routeActive = Color(0xFF00BCD4); // Cian vibrante
  static const Color routePlanned = Color(0xFFFF9800); // Ámbar
  static const Color routeCompleted = Color(0xFF4CAF50); // Verde éxito
  static const Color userLocationLight = primaryOrange;
  static const Color userLocationDark = Color(0xFFFFB59D);
  
  // Estados de validación
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningAmber = Color(0xFFFF9800);
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color infoBlue = Color(0xFF2196F3);
  
  // Colores para diferentes tipos de usuarios en mapa
  static const List<Color> riderColors = [
    Color(0xFFE91E63), // Rosa vibrante
    Color(0xFF9C27B0), // Púrpura
    Color(0xFF673AB7), // Índigo profundo
    Color(0xFF3F51B5), // Azul índigo
    Color(0xFF009688), // Teal
    Color(0xFF795548), // Marrón tierra
  ];
  
  // ============================================================================
  // GRADIENTES PARA EFECTOS ESPECIALES
  // ============================================================================
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryOrange, primaryOrangeDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryBlue, secondaryBlueDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Gradiente para mapas nocturnos
  static const LinearGradient mapNightGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}