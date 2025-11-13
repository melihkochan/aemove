import 'dart:async';
import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../data/home_content.dart';
import '../data/model_option.dart';
import '../data/video_category.dart';
import 'generation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategoryId = videoCategories.first.id;
  final int _availableCredits = 24;
  late final PageController _quickActionController;
  Timer? _quickActionTimer;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _categorySectionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _quickActionController = PageController(viewportFraction: 1.0);
    _startQuickActionTicker();
  }

  void _startQuickActionTicker() {
    _quickActionTimer?.cancel();
    if (homeQuickActions.length <= 1) return;
    _quickActionTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_quickActionController.hasClients) return;
      final currentPage =
          _quickActionController.page?.round() ?? _quickActionController.initialPage;
      final nextPage = (currentPage + 1) % homeQuickActions.length;
      _quickActionController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _quickActionTimer?.cancel();
    _quickActionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _homeTr(String key) => 'home.$key'.tr();

  List<CategoryFeedItem> get _currentFeedItems {
    final items = categoryFeedItems[_selectedCategoryId];
    if (items != null && items.isNotEmpty) {
      return items;
    }
    return categoryFeedItems['all'] ?? const [];
  }

  void _handleTemplateTap(CapabilityTemplate template) {
    final model = _findModel(template.modelId);
    if (model == null) {
      _showToast('Model bağlantısı hazırlanıyor.');
      return;
    }
    if (model.isComingSoon) {
      _showToast('${model.name} yakında kullanılabilir olacak.');
      return;
    }
    _openGeneration(context, model);
  }

  void _handleCategorySelect(String id) {
    if (_selectedCategoryId == id) return;
    setState(() => _selectedCategoryId = id);
    if (_quickActionController.hasClients) {
      _quickActionTimer?.cancel();
      _quickActionController.animateToPage(
        0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
      _startQuickActionTicker();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    });
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

  void _showToast(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _handleQuickAction(HomeQuickAction action) {
    _showToast('${action.title} • ${_homeTr('quickActionToast')}');
  }

  void _handleFeedTap(CategoryFeedItem item) {
    _showToast('${item.title} • yakında yayınlama akışına bağlanacak.');
  }

  String _categoryTitle(String id) {
    final matched = videoCategories.firstWhere(
      (category) => category.id == id,
      orElse: () => videoCategories.first,
    );
    return matched.title;
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

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final quickActionStatus = _homeTr('quickActionsStatus');
    final quickActionCTA = _homeTr('quickActionsPreview');
    final bool isAll = _selectedCategoryId == 'all';
    final feedItems = _currentFeedItems;
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
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HomeHero(
                        subtitle: _homeTr('subtitle'),
                        credits: _availableCredits,
                      ),
                      const SizedBox(height: 20),
                      _CategoryTabStrip(
                        categories: videoCategories,
                        selectedId: _selectedCategoryId,
                        onSelected: _handleCategorySelect,
                      ),
                    ],
                  ),
                ),
              ),
              if (isAll)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionHeader(
                          title: 'Hızlı başlangıçlar',
                          subtitle: 'Dakikalar içinde hazır senaryoları deneyin',
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 240,
                          child: _QuickActionCarousel(
                            controller: _quickActionController,
                            actions: homeQuickActions,
                            statusLabel: quickActionStatus,
                            actionLabel: quickActionCTA,
                            onTap: _handleQuickAction,
                            onInteraction: _startQuickActionTicker,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _SectionHeader(
                          title: 'Trend keşifleri',
                          subtitle: 'Sık denenen sahne ve modeller',
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 210,
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
              SliverToBoxAdapter(
                key: _categorySectionKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 28),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _SectionHeader(
                        title: 'Hızlı kategoriler',
                        subtitle:
                            'Favori tarzını seç, üstteki akış anında yenilensin',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: _CategoryShowcaseGrid(
                        categories: videoCategories
                            .where((category) => category.id != 'all')
                            .toList(),
                        selectedId: _selectedCategoryId,
                        onSelected: _handleCategorySelect,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isAll)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: _SectionHeader(
                      title: _categoryTitle(_selectedCategoryId),
                      subtitle: 'Seçili kategori için önerilen içerikler',
                    ),
                  ),
                ),
              if (feedItems.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 18,
                      crossAxisSpacing: 18,
                      childAspectRatio: 0.72,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = feedItems[index];
                        return _FeedCard(
                          item: item,
                          onTap: () => _handleFeedTap(item),
                        );
                      },
                      childCount: feedItems.length,
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: SizedBox(height: 140 + mediaQuery.padding.bottom),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero({
    required this.subtitle,
    required this.credits,
  });

  final String subtitle;
  final int credits;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aemove',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _EnergyPill(credits: credits),
      ],
    );
  }
}

class _EnergyPill extends StatelessWidget {
  const _EnergyPill({required this.credits});

  final int credits;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2857FF).withValues(alpha: 0.85),
            const Color(0xFF4F46E5).withValues(alpha: 0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2857FF).withValues(alpha: 0.24),
            blurRadius: 16,
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
              color: Colors.white.withValues(alpha: 0.18),
            ),
            child: const Icon(
              Icons.bolt,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'common.credits'.tr(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              Text(
                '$credits',
                style: theme.textTheme.titleSmall?.copyWith(
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

class _CategoryTabStrip extends StatelessWidget {
  const _CategoryTabStrip({
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  final List<VideoCategory> categories;
  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isActive = category.id == selectedId;
              return GestureDetector(
                onTap: () => onSelected(category.id),
                child: Text(
                  category.title,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.65),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Divider(
          color: Colors.white.withValues(alpha: 0.08),
          thickness: 1,
          height: 1,
        ),
      ],
    );
  }
}

class _CategoryShowcaseGrid extends StatelessWidget {
  const _CategoryShowcaseGrid({
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  final List<VideoCategory> categories;
  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final crossAxisCount = width < 420 ? 2 : 3;
    final childAspectRatio = width < 420 ? 0.92 : 1.1;
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _CategoryShowcaseCard(
          category: category,
          isActive: false,
          onTap: () => onSelected(category.id),
        );
      },
    );
  }
}

class _CategoryShowcaseCard extends StatelessWidget {
  const _CategoryShowcaseCard({
    required this.category,
    required this.isActive,
    required this.onTap,
  });

  final VideoCategory category;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = category.color;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.14),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  category.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: baseColor.withValues(alpha: 0.35)),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        baseColor.withValues(alpha: 0.35),
                        Colors.black.withValues(alpha: 0.45),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      child: Icon(
                        category.icon,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      category.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
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

class _FeedCard extends StatelessWidget {
  const _FeedCard({
    required this.item,
    required this.onTap,
  });

  final CategoryFeedItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: Colors.black.withValues(alpha: 0.3)),
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
                      Colors.black.withValues(alpha: 0.72),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                    child: Text(
                      item.id.toUpperCase().replaceAll('-', ' '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: trailing!,
          ),
      ],
    );
  }
}

class _QuickActionCarousel extends StatelessWidget {
  const _QuickActionCarousel({
    required this.controller,
    required this.actions,
    required this.statusLabel,
    required this.actionLabel,
    required this.onTap,
    required this.onInteraction,
  });

  final PageController controller;
  final List<HomeQuickAction> actions;
  final String statusLabel;
  final String actionLabel;
  final ValueChanged<HomeQuickAction> onTap;
  final VoidCallback onInteraction;

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: _QuickActionIndicator(
            controller: controller,
            itemCount: actions.length,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: PageView.builder(
            controller: controller,
            itemCount: actions.length,
            onPageChanged: (_) => onInteraction(),
            itemBuilder: (context, index) {
              final action = actions[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: _QuickActionCard(
                  action: action,
                  statusLabel: statusLabel,
                  actionLabel: actionLabel,
                  onTap: () => onTap(action),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _QuickActionIndicator extends StatelessWidget {
  const _QuickActionIndicator({
    required this.controller,
    required this.itemCount,
  });

  final PageController controller;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, top: 4),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          double page =
              controller.hasClients && controller.position.haveDimensions
                  ? controller.page ?? controller.initialPage.toDouble()
                  : controller.initialPage.toDouble();
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(itemCount, (index) {
              final isActive = (page - index).abs() < 0.5;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 6),
                width: isActive ? 10 : 6,
                height: isActive ? 10 : 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.35),
                ),
              );
            }),
          );
        },
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
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    action.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 16),
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
