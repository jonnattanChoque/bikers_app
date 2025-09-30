import 'package:flutter/material.dart';

/// EditableLabel is a widget that shows a text label and turns into
/// a TextField when tapped, allowing inline editing.
/// By default, losing focus will cancel the edit (no save).
/// Set saveOnLoseFocus = true if you want to save when the field loses focus.
class EditableLabel extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;
  final TextStyle? textStyle;
  final InputDecoration? inputDecoration;
  final bool saveOnLoseFocus; // if true, save on losing focus; default false

  const EditableLabel({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.textStyle,
    this.inputDecoration,
    this.saveOnLoseFocus = false,
  });

  @override
  State<EditableLabel> createState() => _EditableLabelState();
}

class _EditableLabelState extends State<EditableLabel> {
  late final TextEditingController _controller;
  bool _isEditing = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);

    // Listen for focus changes: if we lose focus while editing, either save or cancel
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _isEditing) {
        if (widget.saveOnLoseFocus) {
          _stopEditingAndSave();
        } else {
          _cancelEditing();
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant EditableLabel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the external initialValue changed and we're not editing, update controller
    if (oldWidget.initialValue != widget.initialValue && !_isEditing) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() => _isEditing = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      _controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _controller.text.length,
      );
    });
  }

  void _stopEditingAndSave() {
    setState(() => _isEditing = false);
    final newValue = _controller.text.trim();
    if (newValue.isNotEmpty && newValue != widget.initialValue) {
      widget.onChanged(newValue);
    } else {
      // reset to initial value if empty or unchanged
      _controller.text = widget.initialValue;
    }
  }

  void _cancelEditing() {
    setState(() => _isEditing = false);
    // discard changes and reset text
    _controller.text = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Tapping the label enters edit mode
      onTap: () {
        if (!_isEditing) _startEditing();
      },
      child: _isEditing
          ? TextField(
              controller: _controller,
              focusNode: _focusNode,
              onSubmitted: (_) => _stopEditingAndSave(),
              decoration: (widget.inputDecoration ??
                      const InputDecoration(
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        border: OutlineInputBorder(),
                      ))
                  .copyWith(
                // Save icon at the end of the TextField
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: _stopEditingAndSave,
                ),
              ),
              autofocus: true,
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _controller.text,
                  style: widget.textStyle ??
                      const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.edit, size: 18, color: Colors.grey),
              ],
            ),
    );
  }
}
