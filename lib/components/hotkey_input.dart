import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../colors.dart';

class HotkeyInput extends StatefulWidget {
  final String title;
  final String subtitle;
  final TextEditingController controller;

  const HotkeyInput({
    super.key,
    required this.title,
    required this.subtitle,
    required this.controller,
  });

  @override
  State<HotkeyInput> createState() => _HotkeyInputState();
}

class _HotkeyInputState extends State<HotkeyInput> {
  final FocusNode _focusNode = FocusNode();
  final Set<LogicalKeyboardKey> _pressedKeys = {};
  bool _isCapturing = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(widget.title, style: const TextStyle(color: AppColors.text)),
        subtitle: Text(
          widget.subtitle,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        trailing: _buildHotkeyField(),
      ),
    );
  }

  Widget _buildHotkeyField() {
    return SizedBox(
      width: 150,
      child: GestureDetector(
        onTap: _startCapture,
        child: KeyboardListener(
          focusNode: _focusNode,
          onKeyEvent: _handleKeyEvent,
          child: AbsorbPointer(
            child: TextField(
              controller: widget.controller,
              style: const TextStyle(color: AppColors.text),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                hintText: '...',
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                isDense: true,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _startCapture() {
    setState(() {
      _isCapturing = true;
      _pressedKeys.clear();
      widget.controller.text = '...';
    });
    _focusNode.requestFocus();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (!_isCapturing) return;

    if (_isKeyDown(event)) {
      _pressedKeys.add(event.logicalKey);
      _updateDisplay();
    } else if (_isKeyUp(event)) {
      if (_pressedKeys.isEmpty) return;
      
      _pressedKeys.remove(event.logicalKey);
      if (_pressedKeys.isEmpty) {
        _finishCapture();
      }
    }
  }

  void _updateDisplay() {
    final keyNames = _getKeyNames();
    if (keyNames.isNotEmpty) {
      widget.controller.text = keyNames.join(' + ');
    }
  }

  bool _isKeyDown(KeyEvent event) {
    return event.runtimeType.toString().contains('Down');
  }

  bool _isKeyUp(KeyEvent event) {
    return event.runtimeType.toString().contains('Up');
  }

  void _finishCapture() {
    setState(() {
      _isCapturing = false;
    });
    _focusNode.unfocus();
  }

  List<String> _getKeyNames() {
    final keyNames = _pressedKeys.map(_mapKeyToName).toList();
    keyNames.sort();
    return keyNames;
  }

  String _mapKeyToName(LogicalKeyboardKey key) {
    if (_isAltKey(key)) return 'alt';
    if (_isControlKey(key)) return 'ctrl';
    if (_isShiftKey(key)) return 'shift';
    return key.keyLabel;
  }

  bool _isAltKey(LogicalKeyboardKey key) {
    return key == LogicalKeyboardKey.altLeft ||
        key == LogicalKeyboardKey.altRight;
  }

  bool _isControlKey(LogicalKeyboardKey key) {
    return key == LogicalKeyboardKey.controlLeft ||
        key == LogicalKeyboardKey.controlRight;
  }

  bool _isShiftKey(LogicalKeyboardKey key) {
    return key == LogicalKeyboardKey.shiftLeft ||
        key == LogicalKeyboardKey.shiftRight;
  }
}
