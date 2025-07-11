import 'package:flutter/material.dart';
import 'package:flutter_best_practices/provider.dart';
import 'package:flutter_best_practices/router.dart';
import 'package:flutter_best_practices/utils/navigation_guard.dart';
import 'package:go_router/go_router.dart';

class NavigationWidget extends StatefulWidget {
  final Widget child;
  const NavigationWidget({super.key, required this.child});

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  final _navigationBlocker = Provider.get<NavigationGuard>();
  late MediaQueryData _mediaQuery;
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSelectedTab(GoRouterState.of(context).matchedLocation);
  }

  void _updateSelectedTab(String currentPath) {
    final List<String> pathSegments = currentPath.split('/');
    final firstSegment = pathSegments[0];
    if (firstSegment == AppRoute.home.name) {
      _currentIndex = 0;
    } else if (firstSegment == AppRoute.settings.name) {
      _currentIndex = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    _mediaQuery = MediaQuery.of(context);
    return Material(
      child: Column(
        children: [
          Expanded(child: widget.child),
          _bottomNavBar(), //
        ],
      ),
    );
  }

  Widget _bottomNavBar() {
    final keyboardOpen = _mediaQuery.viewInsets.bottom != 0;
    if (keyboardOpen) {
      return const SizedBox.shrink();
    }
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) async {
        if (_navigationBlocker.checkIsAllowed != null) {
          final canNav = await _navigationBlocker.checkIsAllowed!();
          if (canNav == false) {
            return;
          }
        }
        _currentIndex = index;
        setState(() {});
        final routerGoName = switch (index) {
          0 => AppRoute.home.name,
          1 => AppRoute.settings.name,
          _ => AppRoute.home.name,
        };
        if (mounted) {
          context.goNamed(routerGoName);
        }
      },
      items: [
        const BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home),
        ),
        const BottomNavigationBarItem(
          label: 'Settings',
          icon: Icon(Icons.settings),
        ),
      ],
    );
  }
}
