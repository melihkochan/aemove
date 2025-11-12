import 'package:flutter/material.dart';

class HomeQuickAction {
  const HomeQuickAction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.color,
    required this.imageUrl,
  });

  final String id;
  final String title;
  final String subtitle;
  final String badge;
  final Color color;
  final String imageUrl;
}

class HomeMode {
  const HomeMode({
    required this.id,
    required this.title,
    required this.icon,
    this.badgeKey,
  });

  final String id;
  final String title;
  final IconData icon;
  final String? badgeKey;
}

class HomeTrend {
  const HomeTrend({
    required this.id,
    required this.title,
    required this.description,
    required this.modelId,
    required this.tagline,
    required this.color,
    required this.imageUrl,
  });

  final String id;
  final String title;
  final String description;
  final String modelId;
  final String tagline;
  final Color color;
  final String imageUrl;
}

class CapabilityTemplate {
  const CapabilityTemplate({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.categoryId,
    required this.modelId,
    required this.usageCount,
    required this.creditCost,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String subtitle;
  final String categoryId;
  final String modelId;
  final int usageCount;
  final int creditCost;
  final String? imageUrl;
}

const homeQuickActions = [
  HomeQuickAction(
    id: 'restore',
    title: 'Photo Restore',
    subtitle: 'Give old photos a crisp HD finish in seconds.',
    badge: 'Visual placeholder',
    color: Color(0xFF1D4ED8),
    imageUrl:
        'https://images.unsplash.com/photo-1589923188900-85dae523342b?auto=format&fit=crop&w=1200&q=80',
  ),
  HomeQuickAction(
    id: 'character-swap',
    title: 'Character Swap',
    subtitle: 'Morph the subject of any photo with one tap.',
    badge: 'Visual placeholder',
    color: Color(0xFF7C3AED),
    imageUrl:
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1200&q=80',
  ),
  HomeQuickAction(
    id: 'style-pack',
    title: 'Style Pack',
    subtitle: 'Cinematic grading and lighting presets on demand.',
    badge: 'Preset incoming',
    color: Color(0xFF2563EB),
    imageUrl:
        'https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=1200&q=80',
  ),
  HomeQuickAction(
    id: 'storyboard',
    title: 'Storyboard Builder',
    subtitle: 'Transform text ideas into shot-by-shot plans.',
    badge: 'Workflow incoming',
    color: Color(0xFF0EA5E9),
    imageUrl:
        'https://images.unsplash.com/photo-1526481280695-3c469928b67b?auto=format&fit=crop&w=1200&q=80',
  ),
];

const homeModes = [
  HomeMode(
    id: 'custom',
    title: 'Custom',
    icon: Icons.auto_awesome,
    badgeKey: 'new',
  ),
  HomeMode(
    id: 'effects',
    title: 'Effects',
    icon: Icons.auto_fix_high,
  ),
  HomeMode(
    id: 'camera',
    title: 'Camera',
    icon: Icons.videocam_outlined,
  ),
  HomeMode(
    id: 'restore',
    title: 'Restore',
    icon: Icons.photo_library_outlined,
    badgeKey: 'beta',
  ),
  HomeMode(
    id: 'swap',
    title: 'Swap',
    icon: Icons.switch_account_outlined,
  ),
];

const homeTrends = [
  HomeTrend(
    id: 'veo-trend',
    title: 'Veo 3.1 Visual Guide',
    description: 'Video coming soon • 4K camera moves and light control.',
    modelId: 'veo-3-1',
    tagline: 'Pro studio quality',
    color: Color(0xFF10B981),
    imageUrl:
        'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1400&q=80',
  ),
  HomeTrend(
    id: 'sora-trend',
    title: 'Sora 2 Real-Time',
    description: 'Video coming soon • Physics aware scene coherence.',
    modelId: 'sora-2',
    tagline: 'Realistic animation',
    color: Color(0xFF6366F1),
    imageUrl:
        'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?auto=format&fit=crop&w=1400&q=80',
  ),
  HomeTrend(
    id: 'fal-trend',
    title: 'fal.ai Image-to-Video',
    description: 'Video coming soon • Stable Video Diffusion workflow.',
    modelId: 'fal-svd',
    tagline: 'Fast production',
    color: Color(0xFF0EA5E9),
    imageUrl:
        'https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=1400&q=80',
  ),
];

const capabilityTemplates = [
  CapabilityTemplate(
    id: 'baby-face',
    title: 'Baby Face',
    subtitle: 'Soften skin, balance light and deliver social-ready loops.',
    categoryId: 'popular',
    modelId: 'fal-svd',
    usageCount: 248,
    creditCost: 6,
    imageUrl:
        'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=1000&q=80',
  ),
  CapabilityTemplate(
    id: 'neon-runner',
    title: 'Neon Runner',
    subtitle: 'Cyberpunk chase sequences with neon light animations.',
    categoryId: 'trend',
    modelId: 'sora-2',
    usageCount: 182,
    creditCost: 12,
    imageUrl:
        'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1000&q=80',
  ),
  CapabilityTemplate(
    id: 'fantasy-forest',
    title: 'Fantasy Forest',
    subtitle: 'Foggy woodland creatures and dramatic spell lighting.',
    categoryId: 'fantasy',
    modelId: 'fal-svd',
    usageCount: 96,
    creditCost: 8,
    imageUrl:
        'https://images.unsplash.com/photo-1476611409377-611b54f68947?auto=format&fit=crop&w=1000&q=80',
  ),
  CapabilityTemplate(
    id: 'cinematic-pan',
    title: 'Cinematic Pan',
    subtitle: 'Seamless 4K camera pans powered by Veo 3.1.',
    categoryId: 'cinematic',
    modelId: 'veo-3-1',
    usageCount: 74,
    creditCost: 15,
    imageUrl:
        'https://images.unsplash.com/photo-1489515217757-5fd1be406fef?auto=format&fit=crop&w=1000&q=80',
  ),
  CapabilityTemplate(
    id: 'polaroid-loop',
    title: 'Polaroid Loop',
    subtitle: 'Retro polaroid transitions for nostalgic shorts.',
    categoryId: 'polaroid',
    modelId: 'kling-2-5',
    usageCount: 58,
    creditCost: 5,
    imageUrl:
        'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1000&q=80',
  ),
  CapabilityTemplate(
    id: 'orbit-shot',
    title: 'Orbit Camera Move',
    subtitle: 'High-energy orbit shots for action storyboards.',
    categoryId: 'camera',
    modelId: 'veo-3-1',
    usageCount: 121,
    creditCost: 10,
    imageUrl:
        'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&w=1000&q=80',
  ),
  CapabilityTemplate(
    id: 'retro-wave',
    title: 'Retro Wave',
    subtitle: '80s synthwave glow with bold neon graphics.',
    categoryId: 'vintage',
    modelId: 'kling-2-5',
    usageCount: 67,
    creditCost: 7,
    imageUrl:
        'https://images.unsplash.com/photo-1526481280695-3c469928b67b?auto=format&fit=crop&w=1000&q=80',
  ),
  CapabilityTemplate(
    id: 'future-lab',
    title: 'Future Lab',
    subtitle: 'Sci-fi laboratory sets and animated light rigs.',
    categoryId: 'futuristic',
    modelId: 'sora-2',
    usageCount: 88,
    creditCost: 11,
    imageUrl:
        'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1000&q=80',
  ),
  CapabilityTemplate(
    id: 'artsy-portrait',
    title: 'Artistic Portrait',
    subtitle: 'Illustration-inspired portrait transformations.',
    categoryId: 'artistic',
    modelId: 'fal-svd',
    usageCount: 132,
    creditCost: 6,
    imageUrl:
        'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?auto=format&fit=crop&w=1000&q=80',
  ),
];
