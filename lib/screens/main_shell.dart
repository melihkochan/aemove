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
    final theme = Theme.of(context);
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF111b33), Color(0xFF0b1326)],
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 28,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: SizedBox(
                height: 78,
                child: Row(
                  children: _items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isActive = index == _currentIndex;
                    return Expanded(
                      child: _NavButton(
                        item: item,
                        isActive: isActive,
                        onTap: () => setState(() => _currentIndex = index),
                        theme: theme,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: isActive
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      accent.withValues(alpha: 0.64),
                      accent.withValues(alpha: 0.42),
                    ],
                  )
                : null,
            color: isActive ? null : Colors.transparent,
            border: Border.all(
              color: isActive
                  ? accent.withValues(alpha: 0.65)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isActive ? item.activeIcon : item.icon,
                color: isActive ? Colors.white : Colors.white60,
              ),
              if (isActive) ...[
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'nav.${item.labelKey}'.tr(),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
