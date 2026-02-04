import 'package:flutter/material.dart';
import '../colors.dart';

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
