// ignore_for_file: unrelated_type_equality_checks
import 'package:bikers_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum MessageType { success, error, info }

class CustomSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    MessageType type = MessageType.info,
    Duration duration = const Duration(seconds: 2),
    bool top = false,
    IconData? icon,
  }) {
    final theme = Theme.of(context).colorScheme;
    final color = _getColor(type, theme);
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    
    entry = OverlayEntry(
      builder: (ctx) {
        return _AnimatedSnack(
          message: message,
          icon: icon,
          color: color,
          duration: duration,
          top: top,
          onClose: () => entry.remove(),
        );
      },
    );
    overlay.insert(entry);
  }

  static Color _getColor(MessageType type, ColorScheme theme) {
    switch (type) {
      case MessageType.success:
        return AppColors.successGreen;
      case MessageType.error:
        return AppColors.errorRed;
      case MessageType.info:
        return AppColors.infoBlue;
      }
  }
}

/// Widget interno que maneja la animación de entrada/salida del snack.
/// Internal widget that handles entry/exit animation.
class _AnimatedSnack extends StatefulWidget {
  final String message;
  final IconData? icon;
  final Color color;
  final Duration duration;
  final bool top;
  final VoidCallback onClose;

  const _AnimatedSnack({
    required this.message,
    required this.icon,
    required this.color,
    required this.duration,
    required this.top,
    required this.onClose,
  });

  @override
  State<_AnimatedSnack> createState() => _AnimatedSnackState();
}

class _AnimatedSnackState extends State<_AnimatedSnack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    // Configuramos animación según posición
    Offset begin;
    if (widget.top == true) {
      begin = const Offset(0, -1); // entra desde arriba
    } else {
      begin = const Offset(0, 1); // entra desde abajo
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 200),
    );

    _offsetAnimation = Tween<Offset>(
      begin: begin,
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();

    // Espera y luego sale
    Future.delayed(widget.duration, () async {
      if (mounted) {
        await _controller.reverse();
        widget.onClose();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top == true ? 50 : null,
      bottom: widget.top == false ? 45 : null,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: widget.top
              ? const EdgeInsets.only(top: 16, left: 16, right: 16)
              : const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: widget.color,
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
            ),
            child: Row(
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: Colors.black87),
                  const SizedBox(width: 8),
                ],
                Expanded(child: Text(widget.message, style: TextStyle(color: Colors.black),)),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  child: const Icon(Icons.close, color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
