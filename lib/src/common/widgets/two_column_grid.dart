import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Lays [children] out two to a row once there is room ([minTwoColumnWidth]), one to a row
/// below that. The two cards of a row take the height of the taller one, so rows line up
/// and every row ends level - two independent columns drift apart as the heights add up.
class TwoColumnGrid extends StatelessWidget {
  const TwoColumnGrid({
    super.key,
    required this.children,
    this.spacing = 16,
    this.minTwoColumnWidth = 760,
  });

  final List<Widget> children;
  final double spacing;
  final double minTwoColumnWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final twoColumns = constraints.maxWidth >= minTwoColumnWidth;
        final rows = <Widget>[
          if (twoColumns)
            for (var i = 0; i < children.length; i += 2)
              _EqualHeightPair(
                spacing: spacing,
                children: [
                  children[i],
                  // An odd last card keeps half the width rather than stretching.
                  if (i + 1 < children.length)
                    children[i + 1]
                  else
                    const SizedBox.shrink(),
                ],
              )
          else
            ...children,
        ];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) SizedBox(height: spacing),
              rows[i],
            ],
          ],
        );
      },
    );
  }
}

/// Two children side by side, each half the width less [spacing], both as tall as the
/// taller. Measured directly, not through intrinsic sizes: a card holding a
/// `LayoutBuilder` (the project image) cannot report one.
class _EqualHeightPair extends MultiChildRenderObjectWidget {
  const _EqualHeightPair({required this.spacing, required super.children});

  final double spacing;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderEqualHeightPair(spacing);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderEqualHeightPair renderObject,
  ) {
    renderObject.spacing = spacing;
  }
}

class _PairParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderEqualHeightPair extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _PairParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _PairParentData> {
  _RenderEqualHeightPair(this._spacing);

  double _spacing;
  set spacing(double value) {
    if (value == _spacing) return;
    _spacing = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _PairParentData) {
      child.parentData = _PairParentData();
    }
  }

  @override
  void performLayout() {
    final width = constraints.maxWidth;
    final columnWidth = (width - _spacing) / 2;
    var height = 0.0;
    var child = firstChild;
    while (child != null) {
      child.layout(
        BoxConstraints.tightFor(width: columnWidth),
        parentUsesSize: true,
      );
      if (child.size.height > height) height = child.size.height;
      child = childAfter(child);
    }
    var x = 0.0;
    child = firstChild;
    while (child != null) {
      child.layout(
        BoxConstraints.tightFor(width: columnWidth, height: height),
        parentUsesSize: true,
      );
      (child.parentData! as _PairParentData).offset = Offset(x, 0);
      x += columnWidth + _spacing;
      child = childAfter(child);
    }
    size = constraints.constrain(Size(width, height));
  }

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
}
