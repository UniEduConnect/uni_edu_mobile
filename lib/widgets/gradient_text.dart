import 'package:flutter/material.dart';

/// Paints [text] with a [Gradient] fill. Used for the highlighted parts of
/// section titles (e.g. "nổi bật", "hoạt động") to match the web "text-gradient".
class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.style,
    required this.gradient,
    this.textAlign,
  });

  final String text;
  final TextStyle style;
  final Gradient gradient;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      // Color must be white for srcIn to show the gradient.
      child: Text(text, textAlign: textAlign, style: style.copyWith(color: Colors.white)),
    );
  }
}
