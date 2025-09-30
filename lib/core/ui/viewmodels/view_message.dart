import 'package:bikers_app/core/ui/helpers/custom_snackbar.dart';
import 'package:flutter/material.dart';

enum MessageFlowType { login, register, forget, profile }

class ViewMessage {
  final String text;
  final MessageType type;
  final IconData? icon;
  final MessageFlowType? flowType;

  ViewMessage({required this.text, this.type = MessageType.info, this.icon, this.flowType});
}