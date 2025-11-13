import 'package:flutter/material.dart';

enum GenerationMode { textToVideo, imageToVideo, textAndImage }

class ModelOption {
  const ModelOption({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.description,
    required this.mode,
    required this.primaryColor,
    required this.secondaryColor,
    required this.thumbnailUrl,
    this.categoryTags = const [],
    this.isComingSoon = false,
    this.badge,
  });

  final String id;
  final String name;
  final String subtitle;
  final String description;
  final GenerationMode mode;
  final Color primaryColor;
  final Color secondaryColor;
  final String thumbnailUrl;
  final List<String> categoryTags;
  final bool isComingSoon;
  final String? badge;

  bool get supportsText =>
      mode == GenerationMode.textToVideo || mode == GenerationMode.textAndImage;

  bool get supportsImage =>
      mode == GenerationMode.imageToVideo ||
      mode == GenerationMode.textAndImage;
}

List<ModelOption> get modelOptions => const [
  ModelOption(
    id: 'sora-2',
    name: 'Sora 2',
    subtitle: 'OpenAI',
    description:
        'Cinema-grade text-to-video with realistic motion, physics and scene consistency.',
    mode: GenerationMode.textToVideo,
    primaryColor: Color(0xFF6C63FF),
    secondaryColor: Color(0xFF4337FF),
    thumbnailUrl:
        'https://images.unsplash.com/photo-1534447677768-be436bb09401?auto=format&fit=crop&w=800&q=80',
    categoryTags: ['Popular', 'Cinematic', 'Futuristic'],
    isComingSoon: true,
    badge: 'Coming Soon',
  ),
  ModelOption(
    id: 'veo-3-1',
    name: 'Veo 3.1',
    subtitle: 'Google DeepMind',
    description:
        'Production-level 4K output, 60 fps and advanced camera control.',
    mode: GenerationMode.textToVideo,
    primaryColor: Color(0xFF3DDC84),
    secondaryColor: Color(0xFF28A96B),
    thumbnailUrl:
        'https://images.unsplash.com/photo-1525182008055-f88b95ff7980?auto=format&fit=crop&w=800&q=80',
    categoryTags: ['Popular', 'Cinematic', 'Camera'],
    isComingSoon: true,
    badge: 'Coming Soon',
  ),
  ModelOption(
    id: 'kling-2-5',
    name: 'Kling 2.5',
    subtitle: 'Kuaishou',
    description: 'Fast generation built for social-first short-form video.',
    mode: GenerationMode.textToVideo,
    primaryColor: Color(0xFFFF6B6B),
    secondaryColor: Color(0xFFEF476F),
    thumbnailUrl:
        'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80',
    categoryTags: ['Trend', 'Vintage', 'Polaroid'],
    isComingSoon: true,
    badge: 'Beta Access',
  ),
  ModelOption(
    id: 'fal-svd',
    name: 'fal.ai SVD',
    subtitle: 'fal.ai',
    description:
        'Stable Video Diffusion powered image-to-video conversions. Ideal for getting started quickly.',
    mode: GenerationMode.textAndImage,
    primaryColor: Color(0xFF00B4D8),
    secondaryColor: Color(0xFF0077B6),
    thumbnailUrl:
        'https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?auto=format&fit=crop&w=800&q=80',
    categoryTags: ['Fantasy', 'Artistic', 'Camera'],
    badge: 'Live',
  ),
];
