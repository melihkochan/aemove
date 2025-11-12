import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _weeklyReminders = true;
  bool _videoCompleted = true;
  int _selectedTab = 0;
  final int _availableCredits = 24;
  Locale? _selectedLocale;
  bool _syncedDeviceLocale = false;

  static const _subscriptionPlans = [
    {'credits': 5, 'price': '₺449,99', 'labelKey': 'profile.planWeekly'},
    {
      'credits': 20,
      'price': '₺1.299,99',
      'labelKey': 'profile.planMonthly',
      'badgeKey': 'profile.badgeBest',
      'highlight': true,
    },
    {'credits': 240, 'price': '₺2.999,99', 'labelKey': 'profile.planYearly'},
  ];

  static const _creditPackPlans = [
    {'credits': 5, 'price': '₺599,99', 'labelKey': 'profile.planOnetime'},
    {'credits': 10, 'price': '₺999,99', 'labelKey': 'profile.planOnetime'},
    {
      'credits': 20,
      'price': '₺2.299,99',
      'labelKey': 'profile.planOnetime',
      'badgeKey': 'profile.badgeBest',
      'highlight': true,
    },
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localization = EasyLocalization.of(context);
    if (!_syncedDeviceLocale && localization != null) {
      final supported = localization.supportedLocales;
      final deviceLocale = localization.deviceLocale;
      final activeLocale = localization.currentLocale ?? context.locale;
      Locale target = activeLocale;
      for (final locale in supported) {
        if (locale.languageCode == deviceLocale.languageCode) {
          target = locale;
          break;
        }
      }
      if (activeLocale.languageCode != target.languageCode) {
        localization.setLocale(target);
      }
      _selectedLocale = target;
      _syncedDeviceLocale = true;
    } else {
      _selectedLocale ??= context.locale;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final plans = _selectedTab == 0 ? _subscriptionPlans : _creditPackPlans;
    final locale = _selectedLocale ?? context.locale;
    final locales = context.supportedLocales;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'profile.title'.tr(),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF04070f), Color(0xFF101b33)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
            children: [
              _ProfileHeader(credits: _availableCredits),
              const SizedBox(height: 24),
              _CreditsSummaryCard(availableCredits: _availableCredits),
              const SizedBox(height: 24),
              _LanguagePreferenceCard(
                title: 'profile.languageTitle'.tr(),
                description: 'profile.languageDescription'.tr(),
                locales: locales,
                selectedLocale: locale,
                onLocaleSelected: (selected) {
                  setState(() => _selectedLocale = selected);
                  context.setLocale(selected);
                },
              ),
              const SizedBox(height: 28),
              _PlanSegmentedControl(
                selectedIndex: _selectedTab,
                onChanged: (value) => setState(() => _selectedTab = value),
              ),
              const SizedBox(height: 24),
              _PremiumInfoSection(),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  final itemWidth =
                      maxWidth >= 420 ? (maxWidth - 16) / 2 : maxWidth;
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: plans.map((plan) {
                      final credits = plan['credits'] as int;
                      final price = plan['price'] as String;
                      final labelKey = plan['labelKey'] as String;
                      final badgeKey = plan['badgeKey'] as String?;
                      final highlight = plan['highlight'] == true;
                      return SizedBox(
                        width: itemWidth,
                        child: _CreditPlanCard(
                          credits: credits,
                          price: price,
                          label: tr(labelKey),
                          badge: badgeKey == null ? null : tr(badgeKey),
                          highlight: highlight,
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 28),
              OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.refresh_outlined,
                  color: theme.colorScheme.primary,
                ),
                label: Text(
                  'profile.restore'.tr(),
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: theme.colorScheme.primary.withValues(alpha: 0.6),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _QuickActionTile(
                icon: Icons.star,
                title: 'profile.rate'.tr(),
                subtitle: 'profile.rateSubtitle'.tr(),
                onTap: () {},
              ),
              _QuickActionTile(
                icon: Icons.chat_bubble_outline,
                title: 'profile.featureRequests'.tr(),
                subtitle: 'profile.featureSubtitle'.tr(),
                onTap: () {},
              ),
              _ToggleTile(
                icon: Icons.calendar_today_outlined,
                title: 'profile.weeklyReminders'.tr(),
                subtitle: 'profile.weeklySubtitle'.tr(),
                value: _weeklyReminders,
                onChanged: (value) => setState(() => _weeklyReminders = value),
              ),
              _ToggleTile(
                icon: Icons.check_circle_outline,
                title: 'profile.videoCompleted'.tr(),
                subtitle: 'profile.videoSubtitle'.tr(),
                value: _videoCompleted,
                onChanged: (value) => setState(() => _videoCompleted = value),
              ),
              _QuickActionTile(
                icon: Icons.mail_outline,
                title: 'profile.contactSupport'.tr(),
                subtitle: 'profile.contactSubtitle'.tr(),
                onTap: () {},
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text('common.privacyPolicy'.tr()),
                  ),
                  const Text('·'),
                  TextButton(
                    onPressed: () {},
                    child: Text('common.termsOfService'.tr()),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                label: Text(
                  'common.deleteAccount'.tr(),
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.credits});

  final int credits;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0f1a32), Color(0xFF0a1222)],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 22,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.25),
            child: const Icon(Icons.person_outline, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'profile.headerTitle'.tr(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'profile.headerSubtitle'.tr(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          _EnergyBadge(credits: credits),
        ],
      ),
    );
  }
}

class _EnergyBadge extends StatelessWidget {
  const _EnergyBadge({required this.credits});

  final int credits;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.9),
            theme.colorScheme.primary.withValues(alpha: 0.6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.32),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.18),
            ),
            child: const Icon(Icons.bolt, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'common.credits'.tr(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white70,
                  letterSpacing: 0.3,
                ),
              ),
              Text(
                '$credits',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LanguagePreferenceCard extends StatelessWidget {
  const _LanguagePreferenceCard({
    required this.title,
    required this.description,
    required this.locales,
    required this.selectedLocale,
    required this.onLocaleSelected,
  });

  final String title;
  final String description;
  final List<Locale> locales;
  final Locale selectedLocale;
  final ValueChanged<Locale> onLocaleSelected;

  static const Map<String, String> _flags = {'en': '🇺🇸', 'tr': '🇹🇷'};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withValues(alpha: 0.02),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: locales.map((locale) {
              final code = locale.languageCode;
              final selected = selectedLocale.languageCode == code;
              final flag = _flags[code] ?? '🌐';
              return GestureDetector(
                onTap: () => onLocaleSelected(locale),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: selected
                        ? LinearGradient(
                            colors: [
                              theme.colorScheme.primary.withValues(alpha: 0.8),
                              theme.colorScheme.primary.withValues(alpha: 0.55),
                            ],
                          )
                        : null,
                    color: selected
                        ? null
                        : Colors.white.withValues(alpha: 0.04),
                    border: Border.all(
                      color: selected
                          ? theme.colorScheme.primary.withValues(alpha: 0.65)
                          : Colors.white.withValues(alpha: 0.08),
                    ),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.32),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        flag,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'profile.languageOption.$code'.tr(),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _PlanSegmentedControl extends StatelessWidget {
  const _PlanSegmentedControl({
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entries = [
      {'index': 0, 'label': 'profile.tabs.subscriptions'.tr()},
      {'index': 1, 'label': 'profile.tabs.packs'.tr()},
    ];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white.withValues(alpha: 0.04),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: entries.map((entry) {
          final index = entry['index'] as int;
          final label = entry['label'] as String;
          final selected = selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: selected
                      ? LinearGradient(
                          colors: [
                            theme.colorScheme.primary.withValues(alpha: 0.78),
                            theme.colorScheme.primary.withValues(alpha: 0.52),
                          ],
                        )
                      : null,
                  color: selected ? null : Colors.transparent,
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CreditsSummaryCard extends StatelessWidget {
  const _CreditsSummaryCard({required this.availableCredits});

  final int availableCredits;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.9),
            theme.colorScheme.primary.withValues(alpha: 0.6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.32),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.18),
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(Icons.bolt, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'profile.creditsTitle'.tr(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    'profile.creditsLabel'.tr(
                      namedArgs: {'credits': '$availableCredits'},
                    ),
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.info_outline, color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'profile.nextRefresh'.tr(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Dec 10, 2025',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_rounded),
                label: Text('profile.addCredits'.tr()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PremiumInfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withValues(alpha: 0.02),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'profile.premium.title'.tr(),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          _BenefitRow(icon: Icons.refresh, text: 'profile.premium.line1'.tr()),
          _BenefitRow(
            icon: Icons.flash_on_outlined,
            text: 'profile.premium.line2'.tr(),
          ),
          _BenefitRow(
            icon: Icons.workspace_premium_outlined,
            text: 'profile.premium.line3'.tr(),
          ),
        ],
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary.withValues(alpha: 0.18),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreditPlanCard extends StatelessWidget {
  const _CreditPlanCard({
    required this.credits,
    required this.price,
    required this.label,
    this.badge,
    this.highlight = false,
  });

  final int credits;
  final String price;
  final String label;
  final String? badge;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    return SizedBox(
      width: 160,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: highlight
              ? LinearGradient(
                  colors: [
                    accent.withValues(alpha: 0.85),
                    accent.withValues(alpha: 0.55),
                  ],
                )
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF121b33), Color(0xFF0b1226)],
                ),
          color: null,
          border: Border.all(
            color: highlight
                ? accent.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white.withValues(alpha: 0.18),
                ),
                child: Text(
                  badge!.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Text(
              'profile.creditsLabel'.tr(namedArgs: {'credits': '$credits'}),
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.03),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.18),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 18,
          color: Colors.white54,
        ),
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.03),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: theme.colorScheme.primary,
        secondary: CircleAvatar(
          radius: 24,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.18),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
        ),
      ),
    );
  }
}
