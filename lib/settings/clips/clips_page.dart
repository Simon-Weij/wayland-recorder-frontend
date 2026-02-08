// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import 'package:flutter/material.dart';
import '../../colors.dart';
import 'clips_settings_model.dart';
import 'clips_settings_service.dart';
import 'clips_controller.dart';
import 'clips_basic_settings.dart';
import 'clips_advanced_settings.dart';

class ClipsPage extends StatefulWidget {
  const ClipsPage({super.key});

  @override
  State<ClipsPage> createState() => _ClipsPageState();
}

class _ClipsPageState extends State<ClipsPage> {
  late ClipsController _controller;
  bool _showAdvancedSettings = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = ClipsController(ClipsSettings());
    _loadSettings();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await ClipsSettingsService.loadSettings();
      setState(() {
        _controller = ClipsController(settings);
        _controller.updateControllers();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) _showMessage('Failed to load settings: $e', isError: true);
    }
  }

  Future<void> _saveSettings() async {
    final error = await _controller.saveSettings();
    if (mounted) {
      if (error != null) {
        _showMessage(error, isError: true);
      } else {
        _showMessage('Settings saved', isError: false);
      }
    }
  }

  void _showMessage(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.accent : Colors.green,
        duration: Duration(seconds: isError ? 3 : 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.sidebar,
        title: const Text(
          'Recording Settings',
          style: TextStyle(color: AppColors.text),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Settings',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ClipsBasicSettings(
              settings: _controller.settings,
              controller: _controller,
              onUpdate: setState,
            ),
            const SizedBox(height: 30),
            ClipsAdvancedSettings(
              controller: _controller,
              isExpanded: _showAdvancedSettings,
              onExpansionChanged: (expanded) {
                setState(() => _showAdvancedSettings = expanded);
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _saveSettings,
              icon: const Icon(Icons.save, color: AppColors.text),
              label: const Text(
                'Save Settings',
                style: TextStyle(color: AppColors.text),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surface,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
