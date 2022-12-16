import 'package:flutter/widgets.dart';

class FlowMenuDelegate extends FlowDelegate {
  final Animation<double> controller;

  FlowMenuDelegate({required this.controller}) : super(repaint: controller);

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) => false;

  @override
  void paintChildren(FlowPaintingContext context) {
    final size = context.size;
    final xStart = size.width - 70;
    final yStart = size.height - 80;

    for (int i = context.childCount - 1; i >= 0; i--) {
      final childSize = context.getChildSize(i)!.width;
      final dx = (childSize + 15) * i;
      final x = xStart;
      final y = yStart - dx * controller.value;

      context.paintChild(
        i,
        transform: Matrix4.translationValues(
          x,
          y,
          0,
        ),
      );
    }
  }
}
