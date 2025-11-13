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
    final accent = const Color(0xFF4F8BFF);
    final backgroundDark = const Color(0xFF040814);
    final backgroundDeep = const Color(0xFF071029);
    final plans = _selectedTab == 0 ? _subscriptionPlans : _creditPackPlans;
    final locale = _selectedLocale ?? context.locale;
    final locales = context.supportedLocales;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'profile.title'.tr(),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [backgroundDark, backgroundDeep],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 140),
            children: [
              _ProfileHeader(credits: _availableCredits, accent: accent),
              const SizedBox(height: 20),
              _PlanSegmentedControl(
                selectedIndex: _selectedTab,
                onChanged: (value) => setState(() => _selectedTab = value),
                accent: accent,
              ),
              const SizedBox(height: 16),
              _PremiumInfoSection(accent: accent),
              const SizedBox(height: 16),
              SizedBox(
                height: 232,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(right: 4),
                  itemCount: plans.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 18),
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    final credits = plan['credits'] as int;
                    final price = plan['price'] as String;
                    final labelKey = plan['labelKey'] as String;
                    final badgeKey = plan['badgeKey'] as String?;
                    final highlight = plan['highlight'] == true;
                    final cardWidth = highlight ? 240.0 : 220.0;
                    return SizedBox(
                      width: cardWidth,
                      child: _CreditPlanCard(
                        credits: credits,
                        price: price,
                        label: tr(labelKey),
                        badge: badgeKey == null ? null : tr(badgeKey),
                        highlight: highlight,
                        accent: accent,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.refresh_outlined,
                  color: accent,
                ),
                label: Text(
                  'profile.restore'.tr(),
                  style: TextStyle(color: accent),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: accent.withValues(alpha: 0.6)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              _LanguagePreferenceCard(
                title: 'profile.languageTitle'.tr(),
                description: 'profile.languageDescription'.tr(),
                locales: locales,
                selectedLocale: locale,
                onLocaleSelected: (selected) {
                  setState(() => _selectedLocale = selected);
                  context.setLocale(selected);
                },
                accent: accent,
              ),
              const SizedBox(height: 32),
              _QuickActionTile(
                icon: Icons.star,
                title: 'profile.rate'.tr(),
                subtitle: 'profile.rateSubtitle'.tr(),
                onTap: () {},
                accent: accent,
              ),
              _QuickActionTile(
                icon: Icons.chat_bubble_outline,
                title: 'profile.featureRequests'.tr(),
                subtitle: 'profile.featureSubtitle'.tr(),
                onTap: () {},
                accent: accent,
              ),
              _ToggleTile(
                icon: Icons.calendar_today_outlined,
                title: 'profile.weeklyReminders'.tr(),
                subtitle: 'profile.weeklySubtitle'.tr(),
                value: _weeklyReminders,
                onChanged: (value) => setState(() => _weeklyReminders = value),
                accent: accent,
              ),
              _ToggleTile(
                icon: Icons.check_circle_outline,
                title: 'profile.videoCompleted'.tr(),
                subtitle: 'profile.videoSubtitle'.tr(),
                value: _videoCompleted,
                onChanged: (value) => setState(() => _videoCompleted = value),
                accent: accent,
              ),
              _QuickActionTile(
                icon: Icons.mail_outline,
                title: 'profile.contactSupport'.tr(),
                subtitle: 'profile.contactSubtitle'.tr(),
                onTap: () {},
                accent: accent,
              ),
              const SizedBox(height: 24),
              _FooterLinks(accent: accent),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.credits, required this.accent});

  final int credits;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            accent.withValues(alpha: 0.25),
            accent.withValues(alpha: 0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sahip olduğun krediler',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Kredi bakiyen',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.12),
                ),
                child: Icon(Icons.bolt, color: accent, size: 26),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$credits',
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Kullanabileceğin toplam kredi',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Kredi yükle'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: accent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black.withOpacity(0.12),
            ),
            child: Row(
              children: [
                Icon(Icons.schedule, color: Colors.white54, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bir sonraki yenileme',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '10 Aralık 2025',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: accent,
                  ),
                  child: const Text('Detay'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumInfoSection extends StatelessWidget {
  const _PremiumInfoSection({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white.withValues(alpha: 0.02),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
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
          _BenefitRow(
            icon: Icons.refresh,
            text: 'profile.premium.line1'.tr(),
            accent: accent,
          ),
          _BenefitRow(
            icon: Icons.flash_on_outlined,
            text: 'profile.premium.line2'.tr(),
            accent: accent,
          ),
          _BenefitRow(
            icon: Icons.workspace_premium_outlined,
            text: 'profile.premium.line3'.tr(),
            accent: accent,
          ),
        ],
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({required this.icon, required this.text, required this.accent});

  final IconData icon;
  final String text;
  final Color accent;

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
              color: accent.withValues(alpha: 0.15),
            ),
            child: Icon(icon, color: accent),
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
    required this.accent,
  });

  final int credits;
  final String price;
  final String label;
  final String? badge;
  final bool highlight;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradient = highlight
        ? LinearGradient(
            colors: [accent.withValues(alpha: 0.85), accent.withValues(alpha: 0.5)],
          )
        : const LinearGradient(
            colors: [Color(0xFF0C1425), Color(0xFF0A0F1D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: gradient,
        border: Border.all(
          color: highlight
              ? accent.withValues(alpha: 0.65)
              : Colors.white.withValues(alpha: 0.05),
        ),
        boxShadow: highlight
            ? [
                BoxShadow(
                  color: accent.withValues(alpha: 0.32),
                  blurRadius: 20,
                  offset: const Offset(0, 12),
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.black.withOpacity(0.12),
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
            '$credits kredi',
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
          const SizedBox(height: 12),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.92),
            ),
          ),
        ],
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
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.025),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: accent.withValues(alpha: 0.18),
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
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white60),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 18,
          color: Colors.white.withValues(alpha: 0.5),
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
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.025),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.white,
        activeTrackColor: accent,
        secondary: CircleAvatar(
          radius: 24,
          backgroundColor: accent.withValues(alpha: 0.18),
          child: Icon(icon, color: accent),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white60),
        ),
      ),
    );
  }
}

class _PlanSegmentedControl extends StatelessWidget {
  const _PlanSegmentedControl({
    required this.selectedIndex,
    required this.onChanged,
    required this.accent,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entries = [
      {'index': 0, 'label': 'profile.tabs.subscriptions'.tr()},
      {'index': 1, 'label': 'profile.tabs.packs'.tr()},
    ];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withValues(alpha: 0.02),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
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
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: selected
                      ? LinearGradient(
                          colors: [accent, accent.withValues(alpha: 0.6)],
                        )
                      : null,
                  color: selected ? null : Colors.transparent,
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: selected ? Colors.white : Colors.white70,
                    fontWeight: FontWeight.w700,
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

class _LanguagePreferenceCard extends StatelessWidget {
  const _LanguagePreferenceCard({
    required this.title,
    required this.description,
    required this.locales,
    required this.selectedLocale,
    required this.onLocaleSelected,
    required this.accent,
  });

  final String title;
  final String description;
  final List<Locale> locales;
  final Locale selectedLocale;
  final ValueChanged<Locale> onLocaleSelected;
  final Color accent;

  static const Map<String, String> _flags = {'en': '🇺🇸', 'tr': '🇹🇷'};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withValues(alpha: 0.02),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withOpacity(0.15),
                ),
                child: Icon(Icons.language, color: accent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: locales.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final locale = locales[index];
                final code = locale.languageCode;
                final selected = selectedLocale.languageCode == code;
                final flag = _flags[code] ?? '🌐';
                return ChoiceChip(
                  selected: selected,
                  onSelected: (_) => onLocaleSelected(locale),
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(flag, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text('profile.languageOption.$code'.tr()),
                    ],
                  ),
                  labelStyle: theme.textTheme.labelLarge?.copyWith(
                        color: selected ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.w600,
                      ) ??
                      TextStyle(
                        color: selected ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                  selectedColor: accent,
                  backgroundColor: Colors.white.withOpacity(0.06),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(
                      color: selected
                          ? Colors.white.withOpacity(0.4)
                          : Colors.white.withOpacity(0.1),
                    ),
                  ),
                  showCheckmark: false,
                  labelPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterLinks extends StatelessWidget {
  const _FooterLinks({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {},
              child: Text(
                'common.privacyPolicy'.tr(),
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
            ),
            const Text('·', style: TextStyle(color: Colors.white54)),
            TextButton(
              onPressed: () {},
              child: Text(
                'common.termsOfService'.tr(),
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          label: Text(
            'common.deleteAccount'.tr(),
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      ],
    );
  }
}
