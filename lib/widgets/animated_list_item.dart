import 'package:flutter/material.dart';

class AnimatedListItem extends StatelessWidget {
  final bool visible;
  final Widget? child;

  const AnimatedListItem({
    super.key,
    this.visible = true,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (child, animation) {
        return SizeTransition(
          sizeFactor: animation,
          axisAlignment: 1.0,
          child: child,
        );
      },
      child: visible ? child : null,
    );
  }
}
