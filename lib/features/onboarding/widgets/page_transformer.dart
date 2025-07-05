import 'package:flutter/material.dart';

class PageTransformer extends StatelessWidget {
  final PageController pageController;
  final int itemCount;
  final Function(int) onPageChanged;
  final Widget Function(BuildContext, int, double) itemBuilder;

  const PageTransformer({
    required this.pageController,
    required this.itemCount,
    required this.onPageChanged,
    required this.itemBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemCount: itemCount,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: pageController,
          builder: (context, child) {
            double pageOffset = 0;
            if (pageController.position.haveDimensions) {
              pageOffset = pageController.page! - index;
            }
            final double scale = (1 - (pageOffset.abs() * 0.2)).clamp(0.8, 1.0);
            final double opacity = (1 - pageOffset.abs()).clamp(0.5, 1.0);
            return Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity,
                child: itemBuilder(context, index, pageOffset),
              ),
            );
          },
        );
      },
    );
  }
}