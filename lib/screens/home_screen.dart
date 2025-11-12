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
  String _selectedLanguage = 'TR';
  final int _availableCredits = 24;

  static const Map<String, Map<String, String>> _strings = {
    'EN': {
      'headerSubtitle': 'Multi-model video studio',
      'usageLabel': 'Template runs',
      'creditsLabel': 'Credits',
      'languageLabel': 'Language',
      'modesTitle': 'Modes',
      'categoriesTitle': 'Categories',
      'templatesAllTitle': 'All Templates',
      'templatesSuffix': 'Templates',
      'templatesDescription':
          'Visual placeholders • Each template will connect to its AI model.',
      'quickActionsTitle': 'Quick Launch',
      'quickActionsDescription':
          'Prototype flows you can publish once media is ready.',
      'quickActionStatus': 'Preparing',
      'quickActionCTA': 'Preview',
      'quickActionToast': 'This flow is still being designed.',
      'modeToast': '{mode} mode will be fully configurable soon.',
      'trendsTitle': 'Model Trends',
      'trendsDescription':
          'Video examples are on the way. Stay tuned for launch footage.',
      'visualPlaceholder': 'Visual placeholder',
      'usageRuns': 'runs',
      'creditsSuffix': 'credits',
      'apply': 'Apply',
      'noTemplates':
          'No templates for this category yet. We are adding more presets very soon.',
    },
    'TR': {
      'headerSubtitle': 'Çoklu model video stüdyosu',
      'usageLabel': 'Şablon kullanımı',
      'creditsLabel': 'Krediler',
      'languageLabel': 'Dil',
      'modesTitle': 'Modlar',
      'categoriesTitle': 'Kategoriler',
      'templatesAllTitle': 'Hazır Şablonlar',
      'templatesSuffix': 'Şablonları',
      'templatesDescription':
          'Görseller yakında • Her şablon ilgili yapay zekâ modeline bağlanacak.',
      'quickActionsTitle': 'Hızlı Başlangıçlar',
      'quickActionsDescription':
          'Medya hazır olduğunda yayınlayabileceğin akışların taslağı.',
      'quickActionStatus': 'Hazırlanıyor',
      'quickActionCTA': 'Önizle',
      'quickActionToast': 'Bu akış henüz tasarım aşamasında.',
      'modeToast': '{mode} modu yakında tamamen özelleştirilebilir olacak.',
      'trendsTitle': 'Model Trendleri',
      'trendsDescription':
          'Video örnekleri yolda. Lansman görüntüleri için bizi takip et.',
      'visualPlaceholder': 'Görsel hazırlanacak',
      'usageRuns': 'kullanım',
      'creditsSuffix': 'kredi',
      'apply': 'Uygula',
      'noTemplates':
          'Bu kategoride henüz şablon yok. Çok yakında yeni presetler ekliyoruz.',
    },
  };

  static const Map<String, Map<String, String>> _categoryTitles = {
    'EN': {
      'all': 'All',
      'popular': 'Popular',
      'trend': 'Trending',
      'cinematic': 'Cinematic',
      'fantasy': 'Fantasy',
      'camera': 'Camera Moves',
      'polaroid': 'Polaroid',
      'vintage': 'Vintage',
      'futuristic': 'Futuristic',
      'artistic': 'Artistic',
    },
    'TR': {
      'all': 'Hepsi',
      'popular': 'Popüler',
      'trend': 'Trend',
      'cinematic': 'Sinematik',
      'fantasy': 'Fantastik',
      'camera': 'Kamera Hareketleri',
      'polaroid': 'Polaroid',
      'vintage': 'Vintage',
      'futuristic': 'Fütüristik',
      'artistic': 'Sanatsal',
    },
  };

  static const Map<String, Map<String, String>> _modeTitles = {
    'EN': {
      'custom': 'Custom',
      'effects': 'Effects',
      'camera': 'Camera',
      'restore': 'Restore',
      'swap': 'Character Swap',
    },
    'TR': {
      'custom': 'Özel',
      'effects': 'Efektler',
      'camera': 'Kamera',
      'restore': 'Restore',
      'swap': 'Karakter Değişimi',
    },
  };

  static const Map<String, Map<String, String>> _modeBadges = {
    'EN': {'new': 'New', 'beta': 'Beta'},
    'TR': {'new': 'Yeni', 'beta': 'Beta'},
  };

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

  String _modeTitleLabel(String id) =>
      _modeTitles[_selectedLanguage]?[id] ??
      homeModes.firstWhere((mode) => mode.id == id).title;

  String? _modeBadgeLabel(String? key) =>
      key == null ? null : _modeBadges[_selectedLanguage]?[key];

  void _showToast(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _handleQuickAction(HomeQuickAction action) {
    _showToast('${action.title} • ${_t('quickActionToast')}');
  }

  void _handleModeTap(HomeMode mode) {
    setState(() => _selectedModeId = mode.id);
    final label = _modeTitleLabel(mode.id);
    _showToast(_t('modeToast').replaceFirst('{mode}', label));
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

  String _t(String key) => _strings[_selectedLanguage]![key]!;

  String _categoryTitle(String id) =>
      _categoryTitles[_selectedLanguage]?[id] ?? id;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final capabilities = _filteredCapabilities;
    final totalUsage = capabilities.fold<int>(
      0,
      (sum, template) => sum + template.usageCount,
    );
    final categoryTitle = _categoryTitle(_selectedCategoryId);
    final templatesTitle = _selectedCategoryId == 'all'
        ? _t('templatesAllTitle')
        : '$categoryTitle ${_t('templatesSuffix')}';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF05060A), Color(0xFF0F172A)],
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
                        subtitle: _t('headerSubtitle'),
                        totalUsage: totalUsage,
                        credits: _availableCredits,
                        usageLabel: _t('usageLabel'),
                        creditsLabel: _t('creditsLabel'),
                        languageLabel: _t('languageLabel'),
                        selectedLanguage: _selectedLanguage,
                        onLanguageChanged: (value) {
                          setState(() => _selectedLanguage = value);
                        },
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _t('modesTitle'),
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
                        _t('categoriesTitle'),
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
                              label: _categoryTitle(category.id),
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
                        _t('templatesDescription'),
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
                            _t('noTemplates'),
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
                          final translatedCategory = _categoryTitle(
                            template.categoryId,
                          );
                          return _CapabilityCard(
                            template: template,
                            categoryLabel: translatedCategory,
                            placeholderLabel: _t('visualPlaceholder'),
                            usageLabel: _t('usageRuns'),
                            creditsLabel: _t('creditsSuffix'),
                            applyLabel: _t('apply'),
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
                        _t('quickActionsTitle'),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _t('quickActionsDescription'),
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
                              statusLabel: _t('quickActionStatus'),
                              actionLabel: _t('quickActionCTA'),
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
                        _t('trendsTitle'),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _t('trendsDescription'),
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
    required this.selectedLanguage,
    required this.onLanguageChanged,
  });

  final String subtitle;
  final int totalUsage;
  final int credits;
  final String usageLabel;
  final String creditsLabel;
  final String languageLabel;
  final String selectedLanguage;
  final ValueChanged<String> onLanguageChanged;

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
              child: PopupMenuButton<String>(
                onSelected: onLanguageChanged,
                color: theme.colorScheme.surface,
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'EN', child: Text('English')),
                  PopupMenuItem(value: 'TR', child: Text('Türkçe')),
                ],
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.language, size: 18, color: Colors.white70),
                    const SizedBox(width: 8),
                    Text(
                      '$languageLabel: $selectedLanguage',
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

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.icon,
    required this.label,
    required this.value,
    this.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pillColor =
        accent?.withValues(alpha: 0.2) ?? Colors.white.withValues(alpha: 0.08);
    final iconColor = accent ?? Colors.white70;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: pillColor,
        border: Border.all(
          color: accent?.withValues(alpha: 0.3) ?? Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 6),
          Text(
            '$value $label',
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        color: Colors.white.withValues(alpha: 0.02),
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
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _MetricPill(
                        icon: Icons.download_done_outlined,
                        label: usageLabel,
                        value: '${template.usageCount}',
                      ),
                      _MetricPill(
                        icon: Icons.token,
                        label: creditsLabel,
                        value: '+${template.creditCost}',
                        accent: accent,
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
