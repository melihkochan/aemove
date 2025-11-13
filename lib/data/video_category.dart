import 'package:flutter/material.dart';

class VideoCategory {
  const VideoCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.imageUrl,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String imageUrl;
}

const videoCategories = [
  VideoCategory(
    id: 'all',
    title: 'Hepsi',
    subtitle: 'Genel akış',
    icon: Icons.auto_awesome,
    color: Color(0xFF2563EB),
    imageUrl:
        'https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=1200&q=80',
  ),
  VideoCategory(
    id: 'popular',
    title: 'Popüler',
    subtitle: 'En çok kullanılanlar',
    icon: Icons.local_fire_department_outlined,
    color: Color(0xFF34D399),
    imageUrl:
        'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?auto=format&fit=crop&w=1200&q=80',
  ),
  VideoCategory(
    id: 'trend',
    title: 'Trend',
    subtitle: 'Şu an yükselişte',
    icon: Icons.trending_up,
    color: Color(0xFFFB923C),
    imageUrl:
        'https://images.unsplash.com/photo-1526481280695-3c469928b67b?auto=format&fit=crop&w=1200&q=80',
  ),
  VideoCategory(
    id: 'cinematic',
    title: 'Cinematic',
    subtitle: 'Film atmosferi',
    icon: Icons.movie_filter_outlined,
    color: Color(0xFF8B5CF6),
    imageUrl:
        'https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=1200&q=80',
  ),
  VideoCategory(
    id: 'fantasy',
    title: 'Fantasy',
    subtitle: 'Hayal gücü',
    icon: Icons.auto_fix_high_outlined,
    color: Color(0xFFE879F9),
    imageUrl:
        'https://images.unsplash.com/photo-1476611409377-611b54f68947?auto=format&fit=crop&w=1200&q=80',
  ),
  VideoCategory(
    id: 'nature',
    title: 'Nature',
    subtitle: 'Doğal sahneler',
    icon: Icons.park_outlined,
    color: Color(0xFF4ADE80),
    imageUrl:
        'https://images.unsplash.com/photo-1521293281845-9e0a24a49816?auto=format&fit=crop&w=1200&q=80',
  ),
  VideoCategory(
    id: 'lifestyle',
    title: 'Lifestyle',
    subtitle: 'Günlük hikâyeler',
    icon: Icons.self_improvement_outlined,
    color: Color(0xFFFB7185),
    imageUrl:
        'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=1200&q=80',
  ),
  VideoCategory(
    id: 'fashion',
    title: 'Fashion',
    subtitle: 'Moda çekimleri',
    icon: Icons.checkroom_outlined,
    color: Color(0xFFD946EF),
    imageUrl:
        'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?auto=format&fit=crop&w=1200&q=80',
  ),
  VideoCategory(
    id: 'camera',
    title: 'Camera Moves',
    subtitle: 'Hareket koreografisi',
    icon: Icons.video_camera_front_outlined,
    color: Color(0xFF38BDF8),
    imageUrl:
        'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&w=1200&q=80',
  ),
  VideoCategory(
    id: 'sport',
    title: 'Sport',
    subtitle: 'Atletik aksiyon',
    icon: Icons.directions_run_outlined,
    color: Color(0xFF22D3EE),
    imageUrl:
        'https://images.unsplash.com/photo-1502810190503-8303352d0dd0?auto=format&fit=crop&w=1200&q=80',
  ),
  VideoCategory(
    id: 'product',
    title: 'Product',
    subtitle: 'Ürün tanıtımı',
    icon: Icons.shopping_bag_outlined,
    color: Color(0xFFFBBF24),
    imageUrl:
        'https://images.unsplash.com/photo-1556740749-887f6717d7e4?auto=format&fit=crop&w=1200&q=80',
  ),
  VideoCategory(
    id: 'polaroid',
    title: 'Polaroid',
    subtitle: 'Retro kadrajlar',
    icon: Icons.photo_camera_back_outlined,
    color: Color(0xFFFACC15),
    imageUrl:
        'https://images.unsplash.com/photo-1526481280695-3c469928b67b?auto=format&fit=crop&w=1200&q=80',
  ),
  VideoCategory(
    id: 'vintage',
    title: 'Vintage',
    subtitle: 'Analog dokunuş',
    icon: Icons.camera_roll_outlined,
    color: Color(0xFFF472B6),
    imageUrl:
        'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',
  ),
  VideoCategory(
    id: 'futuristic',
    title: 'Futuristic',
    subtitle: 'Bilim kurgu',
    icon: Icons.satellite_alt_outlined,
    color: Color(0xFF22D3EE),
    imageUrl:
        'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=1200&q=80',
  ),
  VideoCategory(
    id: 'travel',
    title: 'Travel',
    subtitle: 'Seyahat rotaları',
    icon: Icons.flight_takeoff_outlined,
    color: Color(0xFF60A5FA),
    imageUrl:
        'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1200&q=80',
  ),
  VideoCategory(
    id: 'artistic',
    title: 'Artistic',
    subtitle: 'Sanatsal yorum',
    icon: Icons.brush_outlined,
    color: Color(0xFF14B8A6),
    imageUrl:
        'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?auto=format&fit=crop&w=1200&q=80',
  ),
];
