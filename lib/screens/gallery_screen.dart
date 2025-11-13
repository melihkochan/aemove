import 'dart:async';

import 'package:flutter/material.dart';

import '../models/video_entry.dart';
import '../services/auth_service.dart';
import '../services/firestore_repository.dart';

enum GalleryFilter { all, processing, completed, failed }

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  StreamSubscription<List<VideoEntry>>? _subscription;
  List<VideoEntry> _videos = const [];
  bool _loading = true;
  bool _hasError = false;
  GalleryFilter _filter = GalleryFilter.all;

  @override
  void initState() {
    super.initState();
    _listenVideos();
  }

  Future<void> _listenVideos() async {
    try {
      final user = await AuthService.ensureSignedIn();
      await _subscription?.cancel();
      _subscription = FirestoreRepository.videosStream(user.uid).listen(
        (videos) {
          if (!mounted) return;
          setState(() {
            _videos = videos;
            _loading = false;
          });
        },
        onError: (_) {
          if (!mounted) return;
          setState(() {
            _hasError = true;
            _loading = false;
          });
        },
      );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  List<VideoEntry> get _filteredVideos {
    switch (_filter) {
      case GalleryFilter.processing:
        return _videos
            .where((v) => v.status == VideoStatus.processing)
            .toList();
      case GalleryFilter.completed:
        return _videos.where((v) => v.status == VideoStatus.completed).toList();
      case GalleryFilter.failed:
        return _videos.where((v) => v.status == VideoStatus.failed).toList();
      case GalleryFilter.all:
        return _videos;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF05060A), Color(0xFF0F172A)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );

    Widget body;
    if (_loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_hasError) {
      body = _ErrorState(
        onRetry: () {
          setState(() {
            _loading = true;
            _hasError = false;
          });
          _listenVideos();
        },
      );
    } else if (_filteredVideos.isEmpty) {
      body = _EmptyState(theme: theme, filter: _filter);
    } else {
      body = _VideosGrid(videos: _filteredVideos);
    }

    return Scaffold(
      body: DecoratedBox(
        decoration: background,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _GalleryHeader(
                  filter: _filter,
                  onChanged: (value) => setState(() => _filter = value),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }
}

class _GalleryHeader extends StatelessWidget {
  const _GalleryHeader({required this.filter, required this.onChanged});

  final GalleryFilter filter;
  final ValueChanged<GalleryFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = const Color(0xFF4F8BFF);
    const entries = <GalleryFilter, String>{
      GalleryFilter.all: 'All',
      GalleryFilter.processing: 'Processing',
      GalleryFilter.completed: 'Completed',
      GalleryFilter.failed: 'Failed',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gallery',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Browse every project you generated. Filter by status anytime.',
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white60),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Colors.white.withValues(alpha: 0.03),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: entries.entries.map((entry) {
              final selected = entry.key == filter;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(entry.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: selected
                          ? LinearGradient(
                              colors: [accent, accent.withValues(alpha: 0.55)],
                            )
                          : null,
                    ),
                    child: Text(
                      entry.value,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: selected ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _VideosGrid extends StatelessWidget {
  const _VideosGrid({required this.videos});

  final List<VideoEntry> videos;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 18,
        crossAxisSpacing: 18,
        childAspectRatio: 0.85,
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Colors.white.withValues(alpha: 0.02),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: video.thumbnailUrl != null
                            ? Image.network(
                                video.thumbnailUrl!,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF1E293B),
                                      Color(0xFF0F172A),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.play_circle_outline,
                                  color: Colors.white70,
                                  size: 40,
                                ),
                              ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: _StatusChip(status: video.status),
                      ),
                      if (video.duration != null)
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: _DurationPill(duration: video.duration!),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (video.modelName != null)
                        Row(
                          children: [
                            Icon(
                              Icons.auto_fix_high_outlined,
                              size: 15,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                video.modelName!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white60,
                                ),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 6),
                      Text(
                        _relativeTime(video.createdAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final VideoStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = switch (status) {
      VideoStatus.completed => (
        background: const Color(0xFF0EA5E9),
        text: Colors.white,
      ),
      VideoStatus.failed => (
        background: const Color(0xFFE11D48),
        text: Colors.white,
      ),
      VideoStatus.processing => (
        background: const Color(0xFFF97316),
        text: Colors.white,
      ),
    };
    final label = switch (status) {
      VideoStatus.completed => 'Completed',
      VideoStatus.failed => 'Failed',
      VideoStatus.processing => 'Processing',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colors.background.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colors.text,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DurationPill extends StatelessWidget {
  const _DurationPill({required this.duration});

  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$minutes:$seconds',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.theme, required this.filter});

  final ThemeData theme;
  final GalleryFilter filter;

  @override
  Widget build(BuildContext context) {
    final message = switch (filter) {
      GalleryFilter.processing =>
        'No projects are processing at the moment. Start a new render to see it here.',
      GalleryFilter.completed =>
        'Once generation is finished your videos will gather in this tab.',
      GalleryFilter.failed =>
        'Looks like everything is running smoothly—no failed renders!',
      GalleryFilter.all =>
        'Generate your first clip and it will instantly appear in the gallery.',
    };

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
                color: Colors.white.withValues(alpha: 0.05),
              ),
              child: const Icon(
                Icons.movie_creation_outlined,
                color: Colors.white70,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Nothing here yet',
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cloud_off,
            color: Colors.white.withValues(alpha: 0.7),
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Gallery couldn’t load',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check your connection and try again.',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: onRetry,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF4F8BFF),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

String _relativeTime(DateTime? time) {
  if (time == null) return 'Unknown date';
  final now = DateTime.now();
  final difference = now.difference(time);
  if (difference.inMinutes < 1) return 'Just now';
  if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
  if (difference.inHours < 24) return '${difference.inHours}h ago';
  if (difference.inDays < 7) return '${difference.inDays}d ago';
  final weeks = (difference.inDays / 7).floor();
  if (weeks < 5) return '${weeks}w ago';
  final months = (difference.inDays / 30).floor();
  if (months < 12) return '${months}mo ago';
  final years = (difference.inDays / 365).floor();
  return '${years}y ago';
}
