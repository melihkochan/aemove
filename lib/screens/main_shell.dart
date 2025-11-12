import 'dart:ui';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.12),
                    Colors.white.withValues(alpha: 0.06),
                  ],
                ),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 26,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: NavigationBar(
                height: 72,
                elevation: 0,
                backgroundColor: Colors.transparent,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                indicatorColor: theme.colorScheme.primary.withValues(
                  alpha: 0.22,
                ),
                selectedIndex: _currentIndex,
                onDestinationSelected: (value) =>
                    setState(() => _currentIndex = value),
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home_rounded),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.auto_fix_high_outlined),
                    selectedIcon: Icon(Icons.auto_fix_high_rounded),
                    label: 'Create',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.play_circle_outline),
                    selectedIcon: Icon(Icons.play_circle_filled_rounded),
                    label: 'My Videos',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person_outline),
                    selectedIcon: Icon(Icons.person_rounded),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
