import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final scrollControllerProvider = Provider<ScrollController>((ref) {
  return ScrollController();
});

/// Counts changes to the home page's height that happen without a scroll - "Show all",
/// "Read more" - so the section index can re-check which section is on screen.
class HomeLayoutTick extends Notifier<int> {
  @override
  int build() => 0;

  void bump() => state++;
}

final homeLayoutTickProvider = NotifierProvider<HomeLayoutTick, int>(
  HomeLayoutTick.new,
);
