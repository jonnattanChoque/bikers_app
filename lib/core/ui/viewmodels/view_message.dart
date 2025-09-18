import 'package:bikers_app/core/ui/helpers/custom_snackbar.dart';
import 'package:flutter/material.dart';

class ViewMessage {
  final String text;
  final MessageType type;
  final IconData? icon;

  ViewMessage({required this.text, this.type = MessageType.info, this.icon});
}