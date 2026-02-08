import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void showHotkeyDialog(BuildContext context, TextEditingController controller) {
  showDialog(
    context: context,
    builder: (BuildContext context) => _HotkeyDialog(controller: controller),
  );
}

class _HotkeyDialog extends StatefulWidget {
  final TextEditingController controller;

  const _HotkeyDialog({required this.controller});

  @override
  State<_HotkeyDialog> createState() => _HotkeyDialogState();
}

class _HotkeyDialogState extends State<_HotkeyDialog> {
  String _capturedKeys = '';
  final Set<LogicalKeyboardKey> _pressedKeys = {};

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Hotkey'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildInstructions(),
          const SizedBox(height: 10),
          _buildCapturedText(),
          const SizedBox(height: 10),
          _buildKeyListener(),
        ],
      ),
      actions: _buildActions(),
    );
  }

  Widget _buildInstructions() {
    return const Text(
      'Press the key combination you want to use as hotkey.',
    );
  }

  Widget _buildCapturedText() {
    return Text(
      'Captured: $_capturedKeys',
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildKeyListener() {
    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: _handleKeyEvent,
      child: ElevatedButton(
        onPressed: () {},
        child: const Text('Press Keys Here'),
      ),
    );
  }

  List<Widget> _buildActions() {
    return [
      TextButton(
        onPressed: _cancel,
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: _confirm,
        child: const Text('OK'),
      ),
    ];
  }

  void _handleKeyEvent(KeyEvent event) {
    _updatePressedKeys(event);
    _updateCapturedKeys();
    setState(() {});
  }

  void _updatePressedKeys(KeyEvent event) {
    final key = event.logicalKey;
    if (event.runtimeType.toString().contains('Down')) {
      _pressedKeys.add(key);
    } else if (event.runtimeType.toString().contains('Up')) {
      _pressedKeys.remove(key);
    }
  }

  void _updateCapturedKeys() {
    final keyNames = _getKeyNames();
    _capturedKeys = keyNames.join(' + ');
  }

  List<String> _getKeyNames() {
    final keyNames = _pressedKeys.map(_mapKeyToName).toList();
    keyNames.sort();
    return keyNames;
  }

  String _mapKeyToName(LogicalKeyboardKey key) {
    if (_isAltKey(key)) {
      return 'alt';
    }
    if (_isControlKey(key)) {
      return 'ctrl';
    }
    if (_isShiftKey(key)) {
      return 'shift';
    }
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

  void _cancel() {
    Navigator.of(context).pop();
  }

  void _confirm() {
    if (_capturedKeys.isNotEmpty) {
      widget.controller.text = _capturedKeys;
    }
    Navigator.of(context).pop();
  }
}
