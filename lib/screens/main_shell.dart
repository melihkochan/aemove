import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'create_screen.dart';
import 'home_screen.dart';
import 'my_videos_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final _pages = const [
    HomeScreen(),
    CreateScreen(),
    MyVideosScreen(),
    ProfileScreen(),
  ];
  final _items = const [
    _NavItem(
      labelKey: 'home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    _NavItem(
      labelKey: 'create',
      icon: Icons.auto_fix_high_outlined,
      activeIcon: Icons.auto_fix_high_rounded,
    ),
    _NavItem(
      labelKey: 'videos',
      icon: Icons.play_circle_outline,
      activeIcon: Icons.play_circle_filled_rounded,
    ),
    _NavItem(
      labelKey: 'account',
      icon: Icons.person_outline,
      activeIcon: Icons.person_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.padding.bottom;
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: IndexedStack(index: _currentIndex, children: _pages),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  bottomInset > 0 ? bottomInset : 6,
                ),
                child: _FrostedNavBar(
                  items: _items,
                  currentIndex: _currentIndex,
                  onItemSelected: (index) =>
                      setState(() => _currentIndex = index),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.labelKey,
    required this.icon,
    required this.activeIcon,
  });

  final String labelKey;
  final IconData icon;
  final IconData activeIcon;
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.isActive,
    required this.onTap,
    required this.theme,
  });

  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final accent = theme.colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: isActive
                ? theme.colorScheme.primary.withValues(alpha: 0.14)
                : Colors.white.withValues(alpha: 0.018),
          ),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 150),
            scale: isActive ? 1.0 : 0.93,
            curve: Curves.easeOutCubic,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 140),
                  child: Icon(
                    isActive ? item.activeIcon : item.icon,
                    key: ValueKey<bool>(isActive),
                    color: isActive
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.68),
                    size: 17,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'nav.${item.labelKey}'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 9,
                    color: isActive
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.65),
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FrostedNavBar extends StatelessWidget {
  const _FrostedNavBar({
    required this.items,
    required this.currentIndex,
    required this.onItemSelected,
  });

  final List<_NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final glassStart = Colors.white.withValues(alpha: 0.05);
    final glassEnd = Colors.white.withValues(alpha: 0.01);
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [glassStart, glassEnd],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: SizedBox(
            height: 50,
            child: Row(
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Expanded(
                  child: _NavButton(
                    item: item,
                    isActive: index == currentIndex,
                    onTap: () => onItemSelected(index),
                    theme: theme,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
