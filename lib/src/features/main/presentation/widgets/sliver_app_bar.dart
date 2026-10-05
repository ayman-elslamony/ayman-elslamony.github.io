import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:portfolio/src/features/main/presentation/widgets/app_bar.dart';

class MySliverAppBar extends ConsumerWidget {
  const MySliverAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverPersistentHeader(
      delegate: _AppBarDelegate(),
      floating: true,
    );
  }
}

class _AppBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return const MyAppBar();
  }

  // MyAppBar draws its bottom hairline as part of its shape, which adds no height, so the
  // extent stays exactly kToolbarHeight. It does NOT stay that way if the line ever moves
  // back into a `bottom:` widget - that would make the app bar 1px taller than the extent
  // this sliver hands it.
  @override
  double get minExtent => kToolbarHeight;

  @override
  double get maxExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
