import 'dart:async';
import 'dart:math';
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
    final theme = Theme.of(context);
    final quickActionStatus = _homeTr('quickActionsStatus');
    final quickActionCTA = _homeTr('quickActionsPreview');
    final bool isAll = _selectedCategoryId == 'all';
    final feedItems = _currentFeedItems;
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF131313), Color(0xFF0C0D11)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          const Positioned.fill(child: _GrainOverlay()),
          Positioned.fill(
            child: SafeArea(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _HomePinnedHeaderDelegate(
                      subtitle: _homeTr('subtitle'),
                      categories: videoCategories,
                      selectedId: _selectedCategoryId,
                      onSelected: _handleCategorySelect,
                    ),
                  ),
                  if (isAll)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            Text(
                              'Platform genelinde öne çıkan içerikler',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
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
                  if (isAll)
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
                    )
                  else
                    SliverToBoxAdapter(
                      key: _categorySectionKey,
                      child: const SizedBox(height: 20),
                    ),
                  if (!isAll)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                              child: Text(
                                _categoryTitle(_selectedCategoryId),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Seçilen kategori için önerilen içerikler',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (feedItems.isNotEmpty && !isAll)
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
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
                    child: SizedBox(height: 110 + mediaQuery.padding.bottom),
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

class _HomeHero extends StatelessWidget {
  const _HomeHero({
    required this.subtitle,
  });

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aemove',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white70,
          ),
        ),
      ],
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
          height: 32,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            padding: const EdgeInsets.only(left: 0, right: 16),
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isActive = category.id == selectedId;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onSelected(category.id),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isActive
                                ? Colors.white
                                : Colors.white.withOpacity(0.62),
                            letterSpacing: 0.2,
                          ) ??
                          TextStyle(
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isActive
                                ? Colors.white
                                : Colors.white.withOpacity(0.62),
                            fontSize: 13,
                          ),
                      child: Text(category.title),
                    ),
                    const SizedBox(height: 2),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      height: 3,
                      width: isActive ? 28 : 0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: isActive
                            ? const LinearGradient(
                                colors: [
                                  Color(0xFF4D9FFF),
                                  Color(0xFF2B6BFF)
                                ],
                              )
                            : null,
                        color: isActive ? null : Colors.transparent,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
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
              const SizedBox(height: 12),
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
        PageView.builder(
          controller: controller,
          itemCount: actions.length,
          onPageChanged: (_) => onInteraction(),
          itemBuilder: (context, index) {
            final action = actions[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: _QuickActionCard(
                action: action,
                statusLabel: statusLabel,
                actionLabel: actionLabel,
                onTap: () => onTap(action),
              ),
            );
          },
        ),
        Positioned(
          top: 12,
          left: 16,
          child: _QuickActionIndicator(
            controller: controller,
            itemCount: actions.length,
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
      padding: const EdgeInsets.only(left: 0, top: 2),
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
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.only(right: 8),
                width: isActive ? 12 : 7,
                height: 7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
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
        borderRadius: BorderRadius.circular(26),
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
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    action.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
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

class _HomePinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _HomePinnedHeaderDelegate({
    required this.subtitle,
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  final String subtitle;
  final List<VideoCategory> categories;
  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  double get minExtent => 128;

  @override
  double get maxExtent => 132;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final showShadow = overlapsContent || shrinkOffset > 1;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF161616), Color(0xFF131313)],
        ),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.28),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HomeHero(subtitle: subtitle),
            const SizedBox(height: 20),
            _CategoryTabStrip(
              categories: categories,
              selectedId: selectedId,
              onSelected: onSelected,
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _HomePinnedHeaderDelegate oldDelegate) {
    return oldDelegate.subtitle != subtitle ||
        oldDelegate.selectedId != selectedId ||
        oldDelegate.categories != categories;
  }
}

class _GrainOverlay extends StatelessWidget {
  const _GrainOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _GrainPainter(),
      ),
    );
  }
}

class _GrainPainter extends CustomPainter {
  _GrainPainter()
      : _points = List.generate(
          2000,
          (index) {
            final random = Random(index * 73 + 11);
            return Offset(random.nextDouble(), random.nextDouble());
          },
        );

  final List<Offset> _points;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < _points.length; i++) {
      final point = Offset(
        _points[i].dx * size.width,
        _points[i].dy * size.height,
      );
      final intensity = ((point.dx + point.dy) % 150) / 150;
      paint
        ..color = Colors.white.withOpacity(0.012 + intensity * 0.025)
        ..strokeWidth = 0.8 + intensity * 0.6;
      canvas.drawCircle(point, paint.strokeWidth * 0.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
