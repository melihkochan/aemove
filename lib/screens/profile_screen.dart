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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final plans = _selectedTab == 0 ? _subscriptionPlans : _creditPackPlans;

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
            colors: [Color(0xFF061024), Color(0xFF0c1533)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
            children: [
              _CreditsSummaryCard(availableCredits: 24),
              const SizedBox(height: 28),
              SegmentedButton<int>(
                segments: [
                  ButtonSegment(
                    value: 0,
                    label: Text('profile.tabs.subscriptions'.tr()),
                  ),
                  ButtonSegment(
                    value: 1,
                    label: Text('profile.tabs.packs'.tr()),
                  ),
                ],
                selected: {_selectedTab},
                onSelectionChanged: (value) =>
                    setState(() => _selectedTab = value.first),
              ),
              const SizedBox(height: 24),
              _PremiumInfoSection(),
              const SizedBox(height: 20),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: plans.map((plan) {
                  final credits = plan['credits'] as int;
                  final price = plan['price'] as String;
                  final labelKey = plan['labelKey'] as String;
                  final badgeKey = plan['badgeKey'] as String?;
                  final highlight = plan['highlight'] == true;
                  return _CreditPlanCard(
                    credits: credits,
                    price: price,
                    label: tr(labelKey),
                    badge: badgeKey == null ? null : tr(badgeKey),
                    highlight: highlight,
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.refresh_outlined),
                label: Text('profile.restore'.tr()),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
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
              const SizedBox(height: 28),
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
