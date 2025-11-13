import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'create_screen.dart';
import 'home_screen.dart';
import 'gallery_screen.dart';
import 'coffee_fortune_screen.dart';
import 'profile_screen.dart';
import '../services/auth_service.dart';
import '../services/firestore_repository.dart';
import '../models/user_profile.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  StreamSubscription<UserProfile>? _profileSubscription;
  UserProfile? _profile;
  int _currentIndex = 0;

  final _pages = const [
    HomeScreen(),
    GalleryScreen(),
    CreateScreen(),
    CoffeeFortuneScreen(),
    ProfileScreen(),
  ];
  final _items = const [
    _NavItem(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    _NavItem(
      label: 'Gallery',
      icon: Icons.collections_outlined,
      activeIcon: Icons.collections,
    ),
    _NavItem(
      label: 'Create',
      icon: Icons.add,
      activeIcon: Icons.add,
      isPrimary: true,
    ),
    _NavItem(
      label: 'Fortune',
      icon: Icons.local_cafe_outlined,
      activeIcon: Icons.local_cafe,
    ),
    _NavItem(
      label: 'Account',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _hydrate();
  }

  Future<void> _hydrate() async {
    final user = await AuthService.ensureSignedIn();
    await _profileSubscription?.cancel();
    _profileSubscription = FirestoreRepository.userProfileStream(user.uid)
        .listen((profile) {
          if (!mounted) return;
          setState(() {
            _profile = profile;
          });
        });
  }

  @override
  void dispose() {
    _profileSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.padding.bottom;
    final credits = _profile?.credits ?? 0;
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF040814), Color(0xFF060A18)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 72),
                child: IndexedStack(index: _currentIndex, children: _pages),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aemove',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.4,
                              ),
                        ),
                        Text(
                          'Create studio',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.white60),
                        ),
                      ],
                    ),
                    const Spacer(),
                    _GlobalCreditPill(
                      credits: credits,
                      onTap: () => setState(() => _currentIndex = 4),
                      compact: true,
                    ),
                  ],
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
    required this.label,
    required this.icon,
    required this.activeIcon,
    this.isPrimary = false,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool isPrimary;
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
    if (item.isPrimary) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(30),
                child: Ink(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5B8CFF), Color(0xFF7F66FF)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5B8CFF).withOpacity(0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 30),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    final iconColor = isActive ? Colors.white : Colors.white70;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: _duration,
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isActive ? item.activeIcon : item.icon, color: iconColor),
            const SizedBox(height: 6),
            Text(
              item.label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: iconColor,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: _duration,
              curve: Curves.easeOutCubic,
              height: 3,
              width: isActive ? 20 : 0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
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
    final glassStart = Colors.white.withOpacity(0.24);
    final glassEnd = Colors.white.withOpacity(0.10);
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [glassStart, glassEnd],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            borderRadius: BorderRadius.circular(24),
          ),
          child: SizedBox(
            height: 96,
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
  const _GlobalCreditPill({
    required this.credits,
    required this.onTap,
    this.compact = false,
  });

  final int credits;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 12 : 16,
            vertical: compact ? 8 : 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: const Color(0xFF4F8BFF),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(compact ? 5 : 6),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x334F8BFF),
                ),
                child: Icon(
                  Icons.bolt,
                  color: Colors.white,
                  size: compact ? 14 : 16,
                ),
              ),
              SizedBox(width: compact ? 6 : 8),
              Text(
                '$credits',
                style:
                    Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: compact ? 13 : null,
                    ) ??
                    TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: compact ? 13 : 15,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
