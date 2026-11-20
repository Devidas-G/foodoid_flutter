import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  const RoundIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 45,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: backgroundColor ?? theme.colorScheme.primary,

        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Center(
            child: Icon(
              icon,
              color: iconColor?? theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}