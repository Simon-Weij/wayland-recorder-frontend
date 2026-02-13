// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'hoverable_container.dart';

class Sidebar extends StatelessWidget {
  final List<Widget> children;
  final Widget? footer;

  const Sidebar({super.key, required this.children, this.footer});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: AppColors.sidebar,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: children,
            ),
          ),
          ?footer,
        ],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return HoverableContainer(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: AppColors.text),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: AppColors.text)),
        ],
      ),
    );
  }
}
