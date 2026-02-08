// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../colors.dart';

class HotkeyInput extends StatefulWidget {
  final TextEditingController controller;

  const HotkeyInput({super.key, required this.controller});

  @override
  State<HotkeyInput> createState() => _HotkeyInputState();
}

class _HotkeyInputState extends State<HotkeyInput> {
  bool _isListening = false;
  final List<LogicalKeyboardKey> _pressedKeys = [];
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _startListening() {
    setState(() {
      _isListening = true;
      _pressedKeys.clear();
    });
    _focusNode.requestFocus();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (!_isListening) return;

    if (event is KeyDownEvent) {
      if (!_pressedKeys.contains(event.logicalKey)) {
        _pressedKeys.add(event.logicalKey);

        if (_pressedKeys.length > 2) {
          _pressedKeys.removeAt(0);
        }

        if (_pressedKeys.length == 2) {
          final keyNames = _pressedKeys.map(_mapKeyToName).toList();
          widget.controller.text = keyNames.join(' + ');
          setState(() {
            _isListening = false;
            _pressedKeys.clear();
          });
        } else {
          setState(() {});
        }
      }
    }
  }

  String _getCurrentKeys() {
    if (_isListening && _pressedKeys.isEmpty) {
      return '...';
    }

    if (_pressedKeys.isNotEmpty) {
      final keyNames = _pressedKeys.map(_mapKeyToName).toList();
      return keyNames.join(' + ');
    }

    return widget.controller.text.isEmpty ? 'Not set' : widget.controller.text;
  }

  String _mapKeyToName(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.altLeft ||
        key == LogicalKeyboardKey.altRight) {
      return 'alt';
    }
    if (key == LogicalKeyboardKey.controlLeft ||
        key == LogicalKeyboardKey.controlRight) {
      return 'ctrl';
    }
    if (key == LogicalKeyboardKey.shiftLeft ||
        key == LogicalKeyboardKey.shiftRight) {
      return 'shift';
    }
    if (key == LogicalKeyboardKey.metaLeft ||
        key == LogicalKeyboardKey.metaRight) {
      return 'super';
    }
    return key.keyLabel.toLowerCase();
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
        title: Text(
          'Save Clip Hotkey',
          style: TextStyle(color: AppColors.text),
        ),
        subtitle: Text(
          'Keyboard shortcut to save recording',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        trailing: KeyboardListener(
          focusNode: _focusNode,
          onKeyEvent: _handleKeyEvent,
          child: ElevatedButton(
            onPressed: () {
              if (!_isListening) {
                widget.controller.text = '...';
                _startListening();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.background,
              foregroundColor: AppColors.text,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              _getCurrentKeys(),
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}
