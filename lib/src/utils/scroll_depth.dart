import 'package:flutter/widgets.dart';
import 'package:portfolio/src/common/widgets/scroll_extras.dart';
import 'package:portfolio/src/utils/analytics.dart';

/// Sends `scroll_depth` once each at 25, 50 and 75 % of a page, so GA shows how far
/// visitors really read. GA4's own `scroll` event fires only at 90 %, and under a
/// different name, so the two never mix. A page too short to scroll sends nothing.
class ScrollDepthReporter extends StatefulWidget {
  const ScrollDepthReporter({
    super.key,
    required this.controller,
    required this.page,
    required this.child,
    this.report = Analytics.event,
  });

  final ScrollController controller;

  /// `home`, or a case study's slug.
  final String page;
  final Widget child;

  /// Where the events go; tests pass a collector.
  final void Function(String name, Map<String, String> params) report;

  static const thresholds = [25, 50, 75];

  @override
  State<ScrollDepthReporter> createState() => _ScrollDepthReporterState();
}

class _ScrollDepthReporterState extends State<ScrollDepthReporter> {
  final _sent = <int>{};

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(ScrollDepthReporter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onScroll);
      widget.controller.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final controller = widget.controller;
    if (!hasSinglePosition(controller) ||
        !controller.position.hasContentDimensions) {
      return;
    }
    final max = controller.position.maxScrollExtent;
    if (max <= 0) return;
    final percent = controller.offset / max * 100;
    for (final t in ScrollDepthReporter.thresholds) {
      if (percent >= t && _sent.add(t)) {
        widget.report('scroll_depth', {'percent': '$t', 'page': widget.page});
      }
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
