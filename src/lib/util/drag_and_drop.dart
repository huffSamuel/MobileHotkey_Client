import 'package:flutter/material.dart';

class DraggableWidget extends StatelessWidget {
  const DraggableWidget(this.position, this.childPosition, this.child, this.callback);

  final int position;
  final int childPosition;
  final Widget child;
  final ValueChanged<int> callback;

  static final GlobalKey kDraggableWidgetKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    final Widget childOutline = new Container(
        child: const CustomPaint(
          painter: const DashedTileOutlinePainter()
        )
      );

    if (position == childPosition) {
      return new Draggable<bool>(
        data: true,
        child: child,
        childWhenDragging: childOutline,
        feedback: child,
        maxSimultaneousDrags: 1,
      );
    } else {
      return new DragTarget<bool>(
        onAccept: (bool data) { callback(position); },
        builder: (BuildContext context, List<bool> accepted, List<dynamic> rejected) {
          return childOutline;
        }
      );
    }
  }
}

class DashTileOutlinePainter extends CustomPainter {
  const DashTileOutlinePainter();

  static const int segments = 17;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = new Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final Path path = new Path();
    final Rect box = Offset.zero & size;
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(DashTileOutlinePainter oldDelegate) => false;
}

class DraggableTileSource extends StatelessWidget {
  const DraggableTileSource({
    Key key,
    this.color,
    this.heavy: false,
    this.under: true,
    this.child
  }) : super(key: key);

  final Color color;
  final bool heavy;
  final bool under;
  final Widget child;

  static const double kDotSize = 50.0;
  static const double kHeavyMultiplier = 1.5;
  static const double kFingerSize = 50.0;

  @override
  Widget build(BuildContext context) {
    double size = kDotSize;
    if(heavy)  {
      size *= kHeavyMultiplier;
    }

    final Widget contents = new DefaultTextStyle(
      style: Theme.of(context).textTheme.body1,
      textAlign: TextAlign.center,
      child: null
    );

    Widget feedback = new Opacity(
      opacity: 0.75,
      child: contents
    );

    Offset feedbackOffset;
    DragAnchor anchor;
    if (!under) {
      feedback = new Transform(
        transform: new Matrix4.identity()
                    ..translate(-size / 2.0, -(size / 2.0 + kFingerSize)),
        child: feedback,
      );
      feedbackOffset = const Offset(0.0, -kFingerSize);
      anchor = DragAnchor.pointer;
    } else {
      feedbackOffset = Offset.zero;
      anchor = DragAnchor.child;
    }

    if (heavy) {
      return new LongPressDraggable<Color>(
        data: color,
        child: contents,
        feedback: feedback,
        feedbackOffset: feedbackOffset,
        dragAnchor: anchor
      );
    }
  }
}