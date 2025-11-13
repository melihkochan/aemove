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
  final int _availableCredits = 24;

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
            top: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 20, 0),
                child: _GlobalCreditPill(
                  credits: _availableCredits,
                  onTap: () => setState(() => _currentIndex = 3),
                ),
              ),
            ),
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
                  bottomInset > 0 ? bottomInset : 18,
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

  static const _duration = Duration(milliseconds: 220);

  @override
  Widget build(BuildContext context) {
    final accent = theme.colorScheme.primary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          child: AnimatedContainer(
            duration: _duration,
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: isActive
                  ? accent.withValues(alpha: 0.18)
                  : Colors.white.withValues(alpha: 0.015),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: _duration,
                  curve: Curves.easeOutCubic,
                  width: isActive ? 30 : 26,
                  height: isActive ? 30 : 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isActive
                        ? LinearGradient(
                            colors: [accent, accent.withValues(alpha: 0.6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isActive
                        ? null
                        : Colors.white.withValues(alpha: 0.08),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: accent.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    isActive ? item.activeIcon : item.icon,
                    color: Colors.white,
                    size: isActive ? 20 : 18,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: _duration,
                  curve: Curves.easeOutCubic,
                  style: theme.textTheme.labelMedium?.copyWith(
                        fontSize: isActive ? 11 : 10,
                        fontWeight:
                            isActive ? FontWeight.w700 : FontWeight.w500,
                        color: isActive
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.7),
                        letterSpacing: 0.1,
                      ) ??
                      TextStyle(
                        fontSize: isActive ? 11 : 10,
                        fontWeight:
                            isActive ? FontWeight.w700 : FontWeight.w500,
                        color: isActive
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.7),
                      ),
                  child: Text(
                    'nav.${item.labelKey}'.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
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
            height: 66,
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

class _GlobalCreditPill extends StatelessWidget {
  const _GlobalCreditPill({required this.credits, required this.onTap});

  final int credits;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2857FF), Color(0xFF4F46E5)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2857FF).withOpacity(0.28),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
                child: const Icon(Icons.bolt, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mevcut',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white.withOpacity(0.85),
                      letterSpacing: 0.3,
                    ),
                  ),
                  Text(
                    '$credits kredi',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
