import 'package:flutter/material.dart';

/// Extension para estilos de texto reutilizables en la app.
/// Se puede usar así: Text("Sign up", style: Theme.of(context).textTheme.bodyMedium?.link)
extension TextDecorations on TextStyle {
  /// Estilo para links: azul, bold y subrayado
  TextStyle get link => copyWith(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
        decorationColor: Colors.blue
      );

  /// Estilo para mensajes de error
  TextStyle get error => copyWith(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      );

  /// Estilo para títulos principales
  TextStyle get title => copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      );

  /// Estilo para subtítulos
  TextStyle get subtitle => copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.grey[700],
      );

  /// Estilo para botones o labels importantes
  TextStyle get buttonLabel => copyWith(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  /// Estilo para hints de formulario o placeholders
  TextStyle get hint => copyWith(
        fontSize: 14,
        color: Colors.grey[500],
      );
}
