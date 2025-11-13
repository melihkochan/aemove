import 'package:flutter/material.dart';

class MyVideosScreen extends StatelessWidget {
  const MyVideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = _dummyVideos;

    return Scaffold(
      appBar: AppBar(title: const Text('My Videos')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF05060A), Color(0xFF0F172A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: items.isEmpty
              ? _EmptyState(theme: theme)
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withValues(alpha: 0.02),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 64,
                            width: 64,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: [
                                  item.accent.withValues(alpha: 0.36),
                                  item.accent.withValues(alpha: 0.16),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 34,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.hub_outlined,
                                      size: 16,
                                      color: item.accent.withValues(alpha: 0.9),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      item.modelName,
                                      style: theme.textTheme.labelLarge
                                          ?.copyWith(color: Colors.white70),
                                    ),
                                    const Spacer(),
                                    Text(
                                      item.timeAgo,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(color: Colors.white54),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 18),
                  itemCount: items.length,
                ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
              child: const Icon(
                Icons.movie_creation_outlined,
                color: Colors.white60,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'You have no videos yet',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pick a model to start generating. Your finished videos will appear here.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DummyVideo {
  const _DummyVideo({
    required this.title,
    required this.description,
    required this.modelName,
    required this.timeAgo,
    required this.accent,
  });

  final String title;
  final String description;
  final String modelName;
  final String timeAgo;
  final Color accent;
}

const _dummyVideos = <_DummyVideo>[
  _DummyVideo(
    title: 'Neon City Chase',
    description: 'A cyberpunk chase sequence unfolding in a rain-soaked neon city.',
    modelName: 'fal.ai SVD',
    timeAgo: '2 days ago',
    accent: Color(0xFF00B4D8),
  ),
  _DummyVideo(
    title: 'Moonlit Forest',
    description: 'A cinematic reunion of spirits dancing beneath the moonlight.',
    modelName: 'fal.ai SVD',
    timeAgo: '5 days ago',
    accent: Color(0xFF6C63FF),
  ),
];
