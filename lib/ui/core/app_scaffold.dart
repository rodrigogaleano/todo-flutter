import 'package:flutter/material.dart';
import 'package:rg_design_system/rg_design_system.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.child,
    this.maxContentWidth = 420,
    super.key,
  });

  final Widget child;
  final double maxContentWidth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Padding(
              padding: const EdgeInsets.all(RGSpacing.lg),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
