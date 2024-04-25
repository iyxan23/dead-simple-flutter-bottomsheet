library dead_simple_flutter_bottomsheet;

import 'package:flutter/material.dart';

class DeadSimpleBottomSheet extends StatefulWidget {
  const DeadSimpleBottomSheet(
      {super.key,

      /// A callback function called with a value between 0 (collapsed) and 1 (expanded).
      /// Called every time the user moves the sheet.
      this.onProgress,

      /// The expanded height of the sheet
      required this.expandedHeight,

      /// The collapsed height of the sheet
      required this.collapsedHeight,

      /// A builder function to build the child. Called every time the user moves the sheet.
      required this.child,
      
      /// The maximum alpha of the shadow that appears in the background when the sheet is expanded.
      this.maxShadowAlpha = 0.5
  });

  final Function(double)? onProgress;
  final double maxShadowAlpha;
  final double expandedHeight;
  final double collapsedHeight;
  final Widget Function() child;

  @override
  State<DeadSimpleBottomSheet> createState() => _DeadSimpleBottomSheetState();
}

enum SheetState {
  expanded,
  moving,
  collapsed,
}

class _DeadSimpleBottomSheetState extends State<DeadSimpleBottomSheet>
    with SingleTickerProviderStateMixin {
  // 0 to 1
  double get progress =>
      (p - widget.collapsedHeight) /
      (widget.expandedHeight - widget.collapsedHeight);
  late double p;

  late AnimationController _controller;
  late Animation<double> _pAnimation;

  @override
  void initState() {
    p = widget.collapsedHeight;

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..addListener(() {
        setState(() {
          p = _pAnimation.value;
        });
      });

    _pAnimation =
        Tween(begin: widget.collapsedHeight, end: widget.expandedHeight)
            .animate(_controller);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IgnorePointer(
          ignoring: progress == 0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _controller.fling(velocity: -1.0);
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black
                    .withAlpha((shadowAlpha * progress * 255).round()),
              ),
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _pAnimation,
          builder: (context, child) {
            return Positioned.directional(
              textDirection: TextDirection.ltr,
              bottom: 0,
              start: 0,
              end: 0,
              child: SizedBox(
                height: _pAnimation.value,
                child: OverflowBox(
                  child: GestureDetector(
                    onVerticalDragEnd: (details) {
                      if (progress > 0.5) {
                        _controller.fling();
                        widget.onProgress?.call(1);
                      } else {
                        _controller.fling(velocity: -1.0);
                        widget.onProgress?.call(0);
                      }
                    },
                    onVerticalDragUpdate: (details) {
                      double dy = details.primaryDelta! * -1;
                      setState(() {
                        if (_pAnimation.value + dy < widget.collapsedHeight) {
                          _controller.value = 0;
                        } else if (_pAnimation.value + dy >
                            widget.expandedHeight) {
                          _controller.value = 1;
                        } else {
                          _controller.value += dy /
                              (widget.expandedHeight - widget.collapsedHeight);
                        }
                      });

                      widget.onProgress?.call(progress);
                    },
                    child: widget.child(),
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
