import 'package:flutter/material.dart';

class ScreenStabilizer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;

  const ScreenStabilizer({
    super.key,
    required this.child,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? _getMaxWidth(context),
        ),
        child: child,
      ),
    );
  }

  double _getMaxWidth(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return double.infinity; // Mobile: Full width
    } else if (width < 1200) {
      return 900; // Tablet
    } else {
      return 1400; // Desktop
    }
  }
}

class VideoStabilizer extends StatelessWidget {
  final Widget child;

  const VideoStabilizer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 1200,
        ),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: child,
        ),
      ),
    );
  }
}
