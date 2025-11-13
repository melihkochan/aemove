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
  int _selectedSubscriptionIndex = 1;
  int _selectedCreditPackIndex = 0;
  final int _availableCredits = 24;

  static const _subscriptionPlans = [
    {'credits': 5, 'price': '₺449,99', 'label': 'Starter weekly pack'},
    {
      'credits': 20,
      'price': '₺1.299,99',
      'label': 'Growth monthly plan',
      'badge': 'Popular',
      'highlight': true,
    },
    {'credits': 240, 'price': '₺2.999,99', 'label': 'Studio annual plan'},
  ];

  static const _creditPackPlans = [
    {'credits': 5, 'price': '₺599,99', 'label': '5 credit add-on'},
    {'credits': 10, 'price': '₺999,99', 'label': '10 credit add-on'},
    {
      'credits': 20,
      'price': '₺2.299,99',
      'label': '20 credit add-on',
      'badge': 'Best value',
      'highlight': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = const Color(0xFF4F8BFF);
    final backgroundDark = const Color(0xFF040814);
    final backgroundDeep = const Color(0xFF071029);
    final plans = _selectedTab == 0 ? _subscriptionPlans : _creditPackPlans;
    final selectedPlanIndex =
        _selectedTab == 0 ? _selectedSubscriptionIndex : _selectedCreditPackIndex;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Account',
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
              const _PremiumInfoSection(),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: plans.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 18,
                  childAspectRatio: 0.62,
                ),
                itemBuilder: (context, index) {
                  final plan = plans[index];
                  final credits = plan['credits'] as int;
                  final price = plan['price'] as String;
                  final label = plan['label'] as String;
                  final badge = plan['badge'] as String?;
                  final highlight = plan['highlight'] == true;
                  final badgeLabel = badge != null
                      ? (highlight ? 'BEST' : badge!.toUpperCase())
                      : null;
          return _SelectablePlanCard(
            highlighted: highlight,
            accent: accent,
            badge: badgeLabel,
            isSelected: index == selectedPlanIndex,
            onTap: () {
              setState(() {
                if (_selectedTab == 0) {
                  _selectedSubscriptionIndex = index;
                } else {
                  _selectedCreditPackIndex = index;
                }
              });
            },
            child: _CreditPlanCard(
              width: 126,
              credits: credits,
              price: price,
              label: label,
              highlight: highlight,
              accent: accent,
            ),
          );
                },
              ),
              const SizedBox(height: 12),
              Text(
                _selectedTab == 0
                    ? 'Choose a subscription to refill credits automatically every month.'
                    : 'Credit packs are one-time top-ups you can use whenever you need.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.refresh_outlined,
                  color: accent,
                ),
                label: Text(
                  'Restore purchases',
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
              _PlanSummaryCard(accent: accent),
              const SizedBox(height: 32),
              _QuickActionTile(
                icon: Icons.star,
                title: 'Rate the app',
                subtitle: 'Leave a review to support updates.',
                onTap: () {},
                accent: accent,
              ),
              _QuickActionTile(
                icon: Icons.chat_bubble_outline,
                title: 'Feature requests',
                subtitle: 'Tell us what you want to see next.',
                onTap: () {},
                accent: accent,
              ),
              _ToggleTile(
                icon: Icons.calendar_today_outlined,
                title: 'Weekly reminders',
                subtitle: 'Receive tips and best practices.',
                value: _weeklyReminders,
                onChanged: (value) => setState(() => _weeklyReminders = value),
                accent: accent,
              ),
              _ToggleTile(
                icon: Icons.check_circle_outline,
                title: 'Video completed alerts',
                subtitle: 'Get notified when renders finish.',
                value: _videoCompleted,
                onChanged: (value) => setState(() => _videoCompleted = value),
                accent: accent,
              ),
              _QuickActionTile(
                icon: Icons.mail_outline,
                title: 'Contact support',
                subtitle: 'Reach out for technical help.',
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
          colors: [accent.withOpacity(0.22), accent.withOpacity(0.08)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.18),
                ),
                child: const Icon(Icons.bolt, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$credits',
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.6,
                    ),
                  ),
                  Text(
                    'credits available',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white54, size: 18),
              const SizedBox(width: 8),
              Text(
                'Video generation costs vary by model.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: const [
              _PlanPill(label: 'Plan: Free', active: true),
              _PlanPill(label: 'Upgrade to Pro', active: false),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlanPill extends StatelessWidget {
  const _PlanPill({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: active
            ? Colors.white.withOpacity(0.16)
            : Colors.white.withOpacity(0.06),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            ),
      ),
    );
  }
}

class _PlanSummaryCard extends StatelessWidget {
  const _PlanSummaryCard({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.white.withOpacity(0.02),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              _PlanOptionTile(
                title: 'Free',
                subtitle: '8 credits per week',
                highlighted: true,
              ),
              SizedBox(width: 12),
              _PlanOptionTile(
                title: 'Premium',
                subtitle: '100 credits per month',
                highlighted: false,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  accent.withOpacity(0.24),
                  accent.withOpacity(0.08),
                ],
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.schedule, color: Colors.white.withOpacity(0.9)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next reload',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        'December 10, 2025',
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
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('See history'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanOptionTile extends StatelessWidget {
  const _PlanOptionTile({
    required this.title,
    required this.subtitle,
    required this.highlighted,
  });

  final String title;
  final String subtitle;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: highlighted
              ? Colors.white.withOpacity(0.12)
              : Colors.white.withOpacity(0.04),
          border: Border.all(
            color: highlighted
                ? Colors.white.withOpacity(0.25)
                : Colors.white.withOpacity(0.06),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumInfoSection extends StatelessWidget {
  const _PremiumInfoSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white.withOpacity(0.02),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Why upgrade?',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          const _BenefitRow(
            icon: Icons.refresh,
            text: 'Faster queue and priority renders',
          ),
          const _BenefitRow(
            icon: Icons.flash_on_outlined,
            text: 'Higher resolution and longer clips',
          ),
          const _BenefitRow(
            icon: Icons.workspace_premium_outlined,
            text: 'Access to premium model library',
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
              color: Colors.white.withOpacity(0.08),
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

class _SelectablePlanCard extends StatelessWidget {
  const _SelectablePlanCard({
    required this.child,
    required this.accent,
    this.highlighted = false,
    this.badge,
    required this.isSelected,
    required this.onTap,
  });

  final Widget child;
  final Color accent;
  final bool highlighted;
  final String? badge;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? accent.withOpacity(0.85)
        : highlighted
            ? accent.withOpacity(0.6)
            : Colors.white.withOpacity(0.07);
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: badge != null ? const EdgeInsets.only(top: 16) : EdgeInsets.zero,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: borderColor, width: isSelected ? 2.4 : 1.4),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: accent.withOpacity(0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ]
                  : [],
            ),
            child: child,
          ),
          if (badge != null)
            Positioned(
              top: -12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: highlighted ? Colors.white : Colors.black.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color:
                        highlighted ? accent.withOpacity(0.75) : Colors.transparent,
                  ),
                ),
                child: Text(
                  badge!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: highlighted ? accent : Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
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
    required this.width,
    required this.credits,
    required this.price,
    required this.label,
    this.highlight = false,
    required this.accent,
  });

  final double width;
  final int credits;
  final String price;
  final String label;
  final bool highlight;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: highlight
            ? Colors.white.withOpacity(0.1)
            : Colors.white.withOpacity(0.05),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: highlight
                  ? Colors.white.withOpacity(0.18)
                  : Colors.white.withOpacity(0.12),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$credits',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'credits',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white70,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            price,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.white.withOpacity(0.85),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
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
    final entries = const [
      {'index': 0, 'label': 'Subscriptions'},
      {'index': 1, 'label': 'Credit packs'},
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
                'Privacy policy',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
            ),
            const Text('·', style: TextStyle(color: Colors.white54)),
            TextButton(
              onPressed: () {},
              child: Text(
                'Terms of service',
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
            'Delete account',
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      ],
    );
  }
}
