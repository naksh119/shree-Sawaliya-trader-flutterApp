import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Defers mounting [child] until its shell branch is selected for the first time.
///
/// Inactive tabs stay unmounted so they do not fire API calls on app launch.
/// After the first visit, [child] is kept alive while offstage.
class LazyShellTab extends StatefulWidget {
  const LazyShellTab({
    required this.branchIndex,
    required this.child,
    super.key,
  });

  final int branchIndex;
  final Widget child;

  @override
  State<LazyShellTab> createState() => _LazyShellTabState();
}

class _LazyShellTabState extends State<LazyShellTab>
    with AutomaticKeepAliveClientMixin {
  bool _everVisible = false;

  @override
  bool get wantKeepAlive => _everVisible;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final shell = StatefulNavigationShell.maybeOf(context);
    final isActive = shell?.currentIndex == widget.branchIndex;
    if (isActive) {
      _everVisible = true;
    }

    if (!_everVisible) {
      return const SizedBox.shrink();
    }

    return Offstage(
      offstage: !isActive,
      child: TickerMode(
        enabled: isActive,
        child: widget.child,
      ),
    );
  }
}
