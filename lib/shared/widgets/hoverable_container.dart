// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class HoverableContainer extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final BoxDecoration? decoration;
  final BorderRadius? borderRadius;

  const HoverableContainer({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.decoration,
    this.borderRadius,
  });

  @override
  State<HoverableContainer> createState() => _HoverableContainerState();
}

class _HoverableContainerState extends State<HoverableContainer> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        child: Container(
          padding: widget.padding ?? const EdgeInsets.all(12),
          decoration:
              widget.decoration?.copyWith(
                color: _hovered
                    ? AppColors.accentHover
                    : (widget.decoration?.color ?? Colors.transparent),
              ) ??
              BoxDecoration(
                color: _hovered ? AppColors.accentHover : Colors.transparent,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
              ),
          child: widget.child,
        ),
      ),
    );
  }
}
