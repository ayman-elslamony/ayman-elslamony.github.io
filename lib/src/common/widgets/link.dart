import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/constants/sizes.dart';
import 'package:portfolio/src/utils/launch_url_helper.dart';
import 'package:portfolio/src/utils/scaffold_messenger_helper.dart';

class LinkWidget extends StatefulHookConsumerWidget {
  const LinkWidget({
    super.key,
    required this.url,
    this.displayLink,
    this.iconData,
    this.displayLeadingIcon = false,
    this.underlined = false,
    this.hoverColor,
  });

  final String url;
  final String? displayLink;
  final IconData? iconData;
  final bool displayLeadingIcon;
  final bool underlined;
  /// Null means "use the theme's accent". It cannot default to a colour in the constructor,
  /// because a default argument has no BuildContext to read a theme from - which is how this
  /// widget ended up hovering to a hardcoded Colors.blue that no theme change ever reached.
  final Color? hoverColor;

  @override
  ConsumerState<LinkWidget> createState() => _LinkState();
}

class _LinkState extends ConsumerState<LinkWidget> {
  late ColorTween _colorTween;

  @override
  void didChangeDependencies() {
    _colorTween = ColorTween(
      //TODO:Check
      begin: Theme.of(context).colorScheme.inverseSurface,
      end: widget.hoverColor ?? Theme.of(context).colorScheme.primary,
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 200),
    );
    final colorAnimation = useAnimation(_colorTween.animate(controller));

    return DefaultSelectionStyle(
      //TODO:Check
      // selectionColor: Theme.of(context).colorScheme.tertiary,
      mouseCursor: MouseCursor.defer,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          if (!isHovered.value) {
            isHovered.value = true;
            controller.forward();
          }
        },
        onExit: (_) {
          if (isHovered.value) {
            isHovered.value = false;
            controller.reverse();
          }
        },
        child: GestureDetector(
          onTap: () => _onTap(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.displayLeadingIcon)
                Row(
                  children: [
                    Icon(
                      widget.iconData ?? Icons.link,
                      color: colorAnimation,
                    ),
                    gapW4,
                  ],
                ),
              Flexible(
                child: Text(
                  widget.displayLink ?? widget.url,
                  style: TextStyle(
                    decoration:
                        widget.underlined ? TextDecoration.underline : null,
                    color: colorAnimation,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context) async {
    try {
      await LaunchUrlHelper.launchURL(widget.url);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessengerHelper.showLaunchUrlError(context, url: widget.url);
    }
  }
}
