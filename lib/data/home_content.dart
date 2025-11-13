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

class CategoryFeedItem {
  const CategoryFeedItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
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

const categoryEffects = {
  'popular': [
    'Photo Restore',
    'Character Swap',
    'Style Pack',
    'Storyboard Builder',
    'Baby Face',
    'Gun Shooting',
    'Mona Lisa',
    'Polaroid Hug',
  ],
  'fantasy': [
    'Squish Effect',
    'Muscle Up',
    'Inflate',
    'Deflate',
    'Cakeify Magic',
    'Hulk Transform',
    'Baby Face',
    'Puppy Face',
    'Snow White',
    'Disney Princess',
    'Pirate Captain',
    'Royal Princess',
    'Samurai Warrior',
    'Epic Warrior',
    'Shadow Assassin',
    'Fus Ro Dah',
    'Super Saiyan',
    'Younger Self Selfie',
  ],
  'cinematic': [
    'Gun Shooting',
  ],
  'artistic': [
    'Mona Lisa',
    'Oil Painting',
    'Cartoon Jaw Drop',
    'Anime Style',
  ],
  'camera': [
    'General',
    'Static',
    'Dolly In',
    'Dolly Out',
    'Handheld',
    'Car Grip',
    'Bullet Time',
    'Eyes In',
    'Through Object In',
    'Through Object Out',
    'Mouth In',
    'Pan Left',
    'Pan Right',
    'Dolly Left',
    'Dolly Right',
  ],
  'polaroid': [
    'Polaroid Hug',
    'Polaroid Kiss',
    'Polaroid Smile',
    'Polaroid Handshake',
    'Polaroid High Five',
    'Polaroid Cheek Kiss',
    'Polaroid Laugh',
    'Polaroid Peace Sign',
    'Polaroid Back-to-Back',
    'Polaroid Thumbs Up',
  ],
  'vintage': [
    'Bride Elegance',
    'Classy Look',
    'VIP Style',
    'Hug Jesus',
  ],
  'futuristic': [
    'Zoom Call',
    'DOOM FPS',
    'Robot Face Reveal',
    'Energy Blast',
  ],
  'nature': [
    'Jungle Adventure',
    'Zen Master',
    'Tsunami Wave',
  ],
  'abstract': [
    'Crush Impact',
    'Spin Rotate',
    'Time Lapse',
    'Fire Blaze',
    'Jumpscare',
    'Laughing',
    'Crying',
    'Kissing',
    'Angry Face',
  ],
};

const categoryFeedItems = {
  'all': [
    CategoryFeedItem(
      id: 'all-character-swap',
      title: 'Character Swap',
      subtitle: 'Replace characters in any clip in seconds.',
      imageUrl:
          'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?auto=format&fit=crop&w=1200&q=80',
    ),
    CategoryFeedItem(
      id: 'all-baby-face',
      title: 'Baby Face & Animate',
      subtitle: 'Give portraits a dreamy cinematic finish.',
      imageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=1200&q=80',
    ),
    CategoryFeedItem(
      id: 'all-veo',
      title: 'Veo Visual Guide',
      subtitle: 'Cinematic motion blocks crafted for story beats.',
      imageUrl:
          'https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=1200&q=80',
    ),
    CategoryFeedItem(
      id: 'all-fantasy',
      title: 'Fantasy Forest',
      subtitle: 'Spellbinding woodland dream sequences.',
      imageUrl:
          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',
    ),
  ],
  'popular': [
    CategoryFeedItem(
      id: 'popular-photo-restore',
      title: 'Photo Restore & Animate',
      subtitle: 'Fix lighting, remove scratches and bring to life.',
      imageUrl:
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=1200&q=80',
    ),
    CategoryFeedItem(
      id: 'popular-baby-face',
      title: 'Baby Face',
      subtitle: 'Soft portraits tuned for social-ready loops.',
      imageUrl:
          'https://images.unsplash.com/photo-1548943487-a2e4e43b4853?auto=format&fit=crop&w=1200&q=80',
    ),
    CategoryFeedItem(
      id: 'popular-portrait',
      title: 'Dream Portrait',
      subtitle: 'Use cinematic glow grading for characters.',
      imageUrl:
          'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?auto=format&fit=crop&w=1200&q=80',
    ),
    CategoryFeedItem(
      id: 'popular-morph',
      title: 'Face Morph',
      subtitle: 'Swap identities with smooth interpolation.',
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1200&q=80',
    ),
    CategoryFeedItem(
      id: 'popular-storyboard',
      title: 'Storyboard Builder',
      subtitle: 'Generate a 6-shot preview for each scene.',
      imageUrl:
          'https://images.unsplash.com/photo-1526481280695-3c469928b67b?auto=format&fit=crop&w=1200&q=80',
    ),
  ],
  'cinematic': [
    CategoryFeedItem(
      id: 'cinematic-gun',
      title: 'Gun Shooting',
      subtitle: 'Blockbuster muzzle flash and depth-of-field burst.',
      imageUrl:
          'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1200&q=80',
    ),
    CategoryFeedItem(
      id: 'cinematic-pan',
      title: 'Cinematic Pan',
      subtitle: '4K smooth camera pan presets for hero shots.',
      imageUrl:
          'https://images.unsplash.com/photo-1489515217757-5fd1be406fef?auto=format&fit=crop&w=1200&q=80',
    ),
    CategoryFeedItem(
      id: 'cinematic-orbit',
      title: 'Orbit Motion',
      subtitle: 'Create dramatic reveal moves in seconds.',
      imageUrl:
          'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&w=1200&q=80',
    ),
  ],
  'fantasy': [
    CategoryFeedItem(
      id: 'fantasy-snow',
      title: 'Snow White',
      subtitle: 'Fairytale grading and enchanted lighting.',
      imageUrl:
          'https://images.unsplash.com/photo-1523419409543-0c1df022bdd7?auto=format&fit=crop&w=1200&q=80',
    ),
    CategoryFeedItem(
      id: 'fantasy-epic',
      title: 'Epic Warrior',
      subtitle: 'Turn actors into legendary warriors instantly.',
      imageUrl:
          'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=1200&q=80',
    ),
    CategoryFeedItem(
      id: 'fantasy-dragon',
      title: 'Dragon Call',
      subtitle: 'Add roaring drakes flying past the scene.',
      imageUrl:
          'https://images.unsplash.com/photo-1517816428104-797678c7cf0d?auto=format&fit=crop&w=1200&q=80',
    ),
  ],
  'artistic': [
    CategoryFeedItem(
      id: 'artistic-mona',
      title: 'Mona Lisa Mode',
      subtitle: 'Classic painting filter for portraits.',
      imageUrl:
          'https://images.unsplash.com/photo-1526481280695-3c469928b67b?auto=format&fit=crop&w=1200&q=80',
    ),
    CategoryFeedItem(
      id: 'artistic-anime',
      title: 'Anime Style',
      subtitle: 'Frame-by-frame cel shading with neon palettes.',
      imageUrl:
          'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?auto=format&fit=crop&w=1200&q=80',
    ),
    CategoryFeedItem(
      id: 'artistic-oil',
      title: 'Oil Painting',
      subtitle: 'Impressionist brush strokes in one tap.',
      imageUrl:
          'https://images.unsplash.com/photo-1545239351-1141bd82e8a6?auto=format&fit=crop&w=1200&q=80',
    ),
  ],
  'camera': [
    CategoryFeedItem(
      id: 'camera-dolly',
      title: 'Dolly In',
      subtitle: 'Smooth push-in for establishing shots.',
      imageUrl:
          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',
    ),
    CategoryFeedItem(
      id: 'camera-bullet',
      title: 'Bullet Time',
      subtitle: 'Matrix-inspired freeze spins for action beats.',
      imageUrl:
          'https://images.unsplash.com/photo-1516642898673-edd1ced028bd?auto=format&fit=crop&w=1200&q=80',
    ),
  ],
  'polaroid': [
    CategoryFeedItem(
      id: 'polaroid-smile',
      title: 'Polaroid Smile',
      subtitle: 'Retro instant frame for cheerful scenes.',
      imageUrl:
          'https://images.unsplash.com/photo-1504595403659-9088ce801e29?auto=format&fit=crop&w=1200&q=80',
    ),
    CategoryFeedItem(
      id: 'polaroid-laugh',
      title: 'Polaroid Laugh',
      subtitle: 'Animated flipbook polaroid transitions.',
      imageUrl:
          'https://images.unsplash.com/photo-1478720568477-152d9b164e26?auto=format&fit=crop&w=1200&q=80',
    ),
  ],
  'vintage': [
    CategoryFeedItem(
      id: 'vintage-bride',
      title: 'Bride Elegance',
      subtitle: 'Soft pastel wedding looks with film grain.',
      imageUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=1200&q=80',
    ),
    CategoryFeedItem(
      id: 'vintage-classy',
      title: 'Classy Look',
      subtitle: 'Golden hour glamour for lifestyle footage.',
      imageUrl:
          'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?auto=format&fit=crop&w=1200&q=80',
    ),
  ],
  'futuristic': [
    CategoryFeedItem(
      id: 'futuristic-zoom',
      title: 'Zoom Call Studio',
      subtitle: 'Lightweight virtual studios with glass UI.',
      imageUrl:
          'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1200&q=80',
    ),
    CategoryFeedItem(
      id: 'futuristic-robot',
      title: 'Robot Face Reveal',
      subtitle: 'Switch faces to robotic textures instantly.',
      imageUrl:
          'https://images.unsplash.com/photo-1545239351-1141bd82e8a6?auto=format&fit=crop&w=1200&q=80',
    ),
  ],
  'nature': [
    CategoryFeedItem(
      id: 'nature-jungle',
      title: 'Jungle Adventure',
      subtitle: 'Dense foliage and volumetric light setups.',
      imageUrl:
          'https://images.unsplash.com/photo-1500534260348-0b3fadec0d66?auto=format&fit=crop&w=1200&q=80',
    ),
    CategoryFeedItem(
      id: 'nature-zen',
      title: 'Zen Master',
      subtitle: 'Slow meditation cuts with mist overlays.',
      imageUrl:
          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',
    ),
  ],
  'abstract': [
    CategoryFeedItem(
      id: 'abstract-spin',
      title: 'Spin Rotate',
      subtitle: 'High-energy rotations for motion graphics.',
      imageUrl:
          'https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=1200&q=80',
    ),
    CategoryFeedItem(
      id: 'abstract-time',
      title: 'Time Lapse',
      subtitle: 'Compress long sequences into dynamic loops.',
      imageUrl:
          'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1200&q=80',
    ),
  ],
};

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
    id: 'nature-lapse',
    title: 'Nature Lapse',
    subtitle: 'Dynamic landscape loops with weather-aware motion.',
    categoryId: 'nature',
    modelId: 'kling-2-5',
    usageCount: 84,
    creditCost: 9,
    imageUrl:
        'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1000&q=80',
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
  CapabilityTemplate(
    id: 'street-vibes',
    title: 'Street Vibes',
    subtitle: 'Fashion-driven short-form scenes with neon set design.',
    categoryId: 'fashion',
    modelId: 'kling-2-5',
    usageCount: 101,
    creditCost: 9,
    imageUrl:
        'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?auto=format&fit=crop&w=1000&q=80',
  ),
  CapabilityTemplate(
    id: 'daily-flow',
    title: 'Daily Flow',
    subtitle: 'Lifestyle vlog sequences with natural lighting.',
    categoryId: 'lifestyle',
    modelId: 'fal-svd',
    usageCount: 143,
    creditCost: 7,
    imageUrl:
        'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=1000&q=80',
  ),
  CapabilityTemplate(
    id: 'sport-crush',
    title: 'Sport Crush',
    subtitle: 'High-energy sports footage with motion tracking.',
    categoryId: 'sport',
    modelId: 'veo-3-1',
    usageCount: 164,
    creditCost: 12,
    imageUrl:
        'https://images.unsplash.com/photo-1502810190503-8303352d0dd0?auto=format&fit=crop&w=1000&q=80',
  ),
  CapabilityTemplate(
    id: 'product-orbit',
    title: 'Product Orbit',
    subtitle: '360° product showcases with dynamic lighting transitions.',
    categoryId: 'product',
    modelId: 'kling-2-5',
    usageCount: 118,
    creditCost: 8,
    imageUrl:
        'https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=1000&q=80',
  ),
  CapabilityTemplate(
    id: 'world-ride',
    title: 'World Ride',
    subtitle: 'Panoramic drone sequences tailor-made for travel vlogs.',
    categoryId: 'travel',
    modelId: 'sora-2',
    usageCount: 97,
    creditCost: 10,
    imageUrl:
        'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1000&q=80',
  ),
];
