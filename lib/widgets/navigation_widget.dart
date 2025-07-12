import 'package:flutter/material.dart';
import 'package:flutter_best_practices/provider.dart';
import 'package:flutter_best_practices/router.dart';
import 'package:flutter_best_practices/utils/navigation_guard.dart';
import 'package:go_router/go_router.dart';

enum _NavigationItem {
  home(
    label: 'Home',
    icon: Icons.home,
  ),
  settings(
    label: 'Settings',
    icon: Icons.settings,
  );

  final String label;
  final IconData icon;
  const _NavigationItem({
    required this.label,
    required this.icon,
  });
}

class NavigationWidget extends StatefulWidget {
  final Widget child;
  const NavigationWidget({super.key, required this.child});

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  late MediaQueryData _mediaQuery;

  final _navigationBlocker = Provider.get<NavigationGuard>();
  int _currentIndex = 0;

  bool _leftNavExpanded = true;

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
    if (_mediaQuery.size.width < 800) {
      return Material(
        child: Column(
          children: [
            Expanded(child: widget.child),
            _bottomNavBar(),
          ],
        ),
      );
    }
    return Material(
      child: Row(
        children: [
          _sideNavBar(),
          Expanded(child: widget.child),
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
        for (final item in _NavigationItem.values)
          BottomNavigationBarItem(
            label: item.label,
            icon: Icon(item.icon),
          ),
      ],
    );
  }

  Widget _sideNavBar() {
    return NavigationRail(
      extended: _leftNavExpanded,
      destinations: [
        const NavigationRailDestination(
          icon: Icon(Icons.menu),
          label: Text('Flutter Best Practices'),
        ),
        for (final item in _NavigationItem.values)
          NavigationRailDestination(
            icon: Icon(item.icon),
            label: Text(item.label),
          ),
      ],
      selectedIndex: _currentIndex + 1,
      onDestinationSelected: (index) async {
        if (index == 0) {
          _leftNavExpanded = !_leftNavExpanded;
          setState(() {});
          return;
        }
        _navigate(index - 1);
      },
    );
  }

  Future<void> _navigate(int index) async {
    if (_navigationBlocker.checkIsAllowed != null) {
      final canNav = await _navigationBlocker.checkIsAllowed!();
      if (canNav == false) {
        return;
      }
    }
    _currentIndex = index;
    setState(() {});
    final routerGoName = switch (_currentIndex) {
      0 => AppRoute.home.name,
      1 => AppRoute.settings.name,
      _ => AppRoute.home.name,
    };
    if (mounted) {
      context.goNamed(routerGoName);
    }
  }
}
