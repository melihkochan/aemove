import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../data/home_content.dart';
import '../data/model_option.dart';
import '../data/video_category.dart';
import '../widgets/category_chip.dart';
import 'generation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategoryId = videoCategories.first.id;
  String _selectedModeId = homeModes.first.id;
  final int _availableCredits = 24;

  static const Map<String, String> _localeFlags = {'en': '🇺🇸', 'tr': '🇹🇷'};

  String _homeTr(String key) => 'home.$key'.tr();

  List<CapabilityTemplate> get _filteredCapabilities {
    if (_selectedCategoryId == 'all') {
      return capabilityTemplates;
    }
    return capabilityTemplates
        .where((template) => template.categoryId == _selectedCategoryId)
        .toList();
  }

  ModelOption? _findModel(String modelId) {
    for (final option in modelOptions) {
      if (option.id == modelId) {
        return option;
      }
    }
    return null;
  }

  void _openGeneration(BuildContext context, ModelOption option) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => GenerationScreen(modelOption: option)),
    );
  }

  String _modeTitleLabel(String id) {
    final key = 'home.modes.$id';
    final translated = key.tr();
    if (translated != key) {
      return translated;
    }
    return homeModes.firstWhere((mode) => mode.id == id).title;
  }

  String? _modeBadgeLabel(String? key) {
    if (key == null) return null;
    final badgeKey = 'home.modeBadges.$key';
    final translated = badgeKey.tr();
    if (translated != badgeKey) {
      return translated;
    }
    return key.toUpperCase();
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _handleQuickAction(HomeQuickAction action) {
    _showToast('${action.title} • ${_homeTr('quickActionToast')}');
  }

  void _handleModeTap(HomeMode mode) {
    setState(() => _selectedModeId = mode.id);
    final label = _modeTitleLabel(mode.id);
    _showToast('home.modeToast'.tr(namedArgs: {'mode': label}));
  }

  void _handleTrend(HomeTrend trend) {
    final model = _findModel(trend.modelId);
    if (model == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Model access will open soon.')),
      );
      return;
    }
    if (model.isComingSoon) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${model.name} early access is on the way.')),
      );
      return;
    }
    _openGeneration(context, model);
  }

  void _handleCapabilityTap(CapabilityTemplate template) {
    final model = _findModel(template.modelId);
    if (model == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Model wiring for this template is still in progress.'),
        ),
      );
      return;
    }
    if (model.isComingSoon) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${model.name} will unlock soon.')),
      );
      return;
    }
    _openGeneration(context, model);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = context.locale;
    final capabilities = _filteredCapabilities;
    final totalUsage = capabilities.fold<int>(
      0,
      (sum, template) => sum + template.usageCount,
    );
    final selectedCategoryLabel = 'home.categories.$_selectedCategoryId'.tr();
    final templatesTitle = _selectedCategoryId == 'all'
        ? _homeTr('templatesAll')
        : '$selectedCategoryLabel ${_homeTr('templatesSuffix')}';
    final usageLabel = _homeTr('statsUsage');
    final creditsLabel = _homeTr('statsCredits');
    final quickActionStatus = _homeTr('quickActionsStatus');
    final quickActionCTA = _homeTr('quickActionsPreview');
    final languageLabel = 'common.language'.tr();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF060d1f), Color(0xFF0c1533)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeaderBar(
                        subtitle: _homeTr('subtitle'),
                        totalUsage: totalUsage,
                        credits: _availableCredits,
                        usageLabel: usageLabel,
                        creditsLabel: creditsLabel,
                        languageLabel: languageLabel,
                        selectedLocale: locale,
                        locales: context.supportedLocales,
                        localeFlags: _localeFlags,
                        onLanguageChanged: (newLocale) {
                          context.setLocale(newLocale);
                        },
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _homeTr('modesTitle'),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 70,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: homeModes.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final mode = homeModes[index];
                            final isActive = _selectedModeId == mode.id;
                            final modeLabel = _modeTitleLabel(mode.id);
                            final badgeLabel = _modeBadgeLabel(mode.badgeKey);
                            return _ModeChip(
                              icon: mode.icon,
                              label: modeLabel,
                              badge: badgeLabel,
                              active: isActive,
                              onTap: () => _handleModeTap(mode),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _homeTr('categoriesTitle'),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 52,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: videoCategories.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final category = videoCategories[index];
                            final isActive = _selectedCategoryId == category.id;
                            return CategoryChip(
                              label: 'home.categories.${category.id}'.tr(),
                              color: category.color,
                              active: isActive,
                              onTap: () => setState(
                                () => _selectedCategoryId = category.id,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        templatesTitle,
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _homeTr('templatesDescription'),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                sliver: capabilities.isEmpty
                    ? SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                            color: Colors.white.withValues(alpha: 0.02),
                          ),
                          child: Text(
                            _homeTr('noTemplates'),
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      )
                    : SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 18,
                              mainAxisSpacing: 18,
                              childAspectRatio: 0.68,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final template = capabilities[index];
                          final translatedCategory =
                              'home.categories.${template.categoryId}'.tr();
                          return _CapabilityCard(
                            template: template,
                            categoryLabel: translatedCategory,
                            placeholderLabel: _homeTr('visualPlaceholder'),
                            usageLabel: _homeTr('usageRuns'),
                            creditsLabel: _homeTr('creditsSuffix'),
                            applyLabel: 'common.apply'.tr(),
                            onTap: () => _handleCapabilityTap(template),
                          );
                        }, childCount: capabilities.length),
                      ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 48, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _homeTr('quickActionsTitle'),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _homeTr('quickActionsDescription'),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 196,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: homeQuickActions.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final action = homeQuickActions[index];
                            return _QuickActionCard(
                              action: action,
                              statusLabel: quickActionStatus,
                              actionLabel: quickActionCTA,
                              onTap: () => _handleQuickAction(action),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _homeTr('trendsTitle'),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _homeTr('trendsDescription'),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 220,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: homeTrends.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final trend = homeTrends[index];
                            return _TrendCard(
                              trend: trend,
                              onTap: () => _handleTrend(trend),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderBar extends StatelessWidget {
  const _HeaderBar({
    required this.subtitle,
    required this.totalUsage,
    required this.credits,
    required this.usageLabel,
    required this.creditsLabel,
    required this.languageLabel,
    required this.selectedLocale,
    required this.locales,
    required this.localeFlags,
    required this.onLanguageChanged,
  });

  final String subtitle;
  final int totalUsage;
  final int credits;
  final String usageLabel;
  final String creditsLabel;
  final String languageLabel;
  final Locale selectedLocale;
  final List<Locale> locales;
  final Map<String, String> localeFlags;
  final ValueChanged<Locale> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aemove',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withValues(alpha: 0.06),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: PopupMenuButton<Locale>(
                initialValue: selectedLocale,
                onSelected: onLanguageChanged,
                color: theme.colorScheme.surface,
                itemBuilder: (context) => locales
                    .map(
                      (locale) => PopupMenuItem<Locale>(
                        value: locale,
                        child: Row(
                          children: [
                            Text(
                              localeFlags[locale.languageCode] ?? '🌐',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'home.languageShort.${locale.languageCode}'.tr(),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      localeFlags[selectedLocale.languageCode] ?? '🌐',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$languageLabel: ${'home.languageShort.${selectedLocale.languageCode}'.tr()}',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white54,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _StatChip(
              icon: Icons.show_chart_outlined,
              label: usageLabel,
              value: '$totalUsage',
              background: Colors.white.withValues(alpha: 0.08),
            ),
            _StatChip(
              icon: Icons.token,
              label: creditsLabel,
              value: '$credits',
              highlight: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
    this.background,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool highlight;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: highlight
            ? LinearGradient(
                colors: [
                  accent.withValues(alpha: 0.88),
                  accent.withValues(alpha: 0.6),
                ],
              )
            : null,
        color: highlight
            ? null
            : background ?? Colors.white.withValues(alpha: 0.06),
        border: Border.all(
          color: highlight
              ? accent.withValues(alpha: 0.4)
              : Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: highlight ? Colors.white : Colors.white70,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: highlight
                      ? Colors.white.withValues(alpha: 0.85)
                      : Colors.white60,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.labelLarge?.copyWith(
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

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: active
              ? LinearGradient(
                  colors: [
                    accent.withValues(alpha: 0.75),
                    accent.withValues(alpha: 0.55),
                  ],
                )
              : null,
          color: active ? null : Colors.white.withValues(alpha: 0.06),
          border: Border.all(
            color: active
                ? accent.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: Colors.white.withValues(alpha: active ? 1 : 0.7),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  if (badge != null)
                    Text(
                      badge!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.action,
    required this.statusLabel,
    required this.actionLabel,
    required this.onTap,
  });

  final HomeQuickAction action;
  final String statusLabel;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 220,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  action.imageUrl,
                  fit: BoxFit.cover,
                  color: Colors.black.withValues(alpha: 0.15),
                  colorBlendMode: BlendMode.darken,
                  errorBuilder: (_, __, ___) =>
                      Container(color: action.color.withValues(alpha: 0.4)),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.05),
                        action.color.withValues(alpha: 0.85),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        action.badge,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      action.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      action.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Text(
                          statusLabel,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Text(
                              actionLabel,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.arrow_outward_rounded,
                              size: 18,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrendCard extends StatelessWidget {
  const _TrendCard({required this.trend, required this.onTap});

  final HomeTrend trend;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 260,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  trend.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: trend.color.withValues(alpha: 0.4)),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.08),
                        Colors.black.withValues(alpha: 0.75),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: trend.color.withValues(alpha: 0.35),
                      ),
                      child: Text(
                        trend.tagline,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      trend.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        trend.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.hub_outlined,
                          size: 16,
                          color: Colors.white54,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          trend.modelId.toUpperCase(),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CapabilityCard extends StatelessWidget {
  const _CapabilityCard({
    required this.template,
    required this.categoryLabel,
    required this.placeholderLabel,
    required this.usageLabel,
    required this.creditsLabel,
    required this.applyLabel,
    required this.onTap,
  });

  final CapabilityTemplate template;
  final String categoryLabel;
  final String placeholderLabel;
  final String usageLabel;
  final String creditsLabel;
  final String applyLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF121b33), Color(0xFF0b1226)],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 146,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (template.imageUrl != null)
                    Image.network(
                      template.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: accent.withValues(alpha: 0.2)),
                    )
                  else
                    Container(color: Colors.white.withValues(alpha: 0.04)),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.05),
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: accent.withValues(alpha: 0.3),
                        ),
                        child: Text(
                          placeholderLabel,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                    child: Text(
                      categoryLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    template.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    template.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(
                        Icons.download_done_outlined,
                        size: 16,
                        color: Colors.white54,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${template.usageCount} $usageLabel',
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white60,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              accent.withValues(alpha: 0.42),
                              accent.withValues(alpha: 0.24),
                            ],
                          ),
                          border: Border.all(
                            color: accent.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.token,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '+${template.creditCost} $creditsLabel',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onTap,
                      child: Text(applyLabel),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
