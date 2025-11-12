import 'package:flutter/material.dart';

class VideoCategory {
  const VideoCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

const videoCategories = [
  VideoCategory(
    id: 'all',
    title: 'Hepsi',
    subtitle: 'Genel akış',
    icon: Icons.auto_awesome,
    color: Color(0xFF2563EB),
  ),
  VideoCategory(
    id: 'popular',
    title: 'Popüler',
    subtitle: 'En çok kullanılanlar',
    icon: Icons.local_fire_department_outlined,
    color: Color(0xFF34D399),
  ),
  VideoCategory(
    id: 'trend',
    title: 'Trend',
    subtitle: 'Şu an yükselişte',
    icon: Icons.trending_up,
    color: Color(0xFFFB923C),
  ),
  VideoCategory(
    id: 'cinematic',
    title: 'Cinematic',
    subtitle: 'Film atmosferi',
    icon: Icons.movie_filter_outlined,
    color: Color(0xFF8B5CF6),
  ),
  VideoCategory(
    id: 'fantasy',
    title: 'Fantasy',
    subtitle: 'Hayal gücü',
    icon: Icons.auto_fix_high_outlined,
    color: Color(0xFFE879F9),
  ),
  VideoCategory(
    id: 'camera',
    title: 'Camera Moves',
    subtitle: 'Hareket koreografisi',
    icon: Icons.video_camera_front_outlined,
    color: Color(0xFF38BDF8),
  ),
  VideoCategory(
    id: 'polaroid',
    title: 'Polaroid',
    subtitle: 'Retro kadrajlar',
    icon: Icons.photo_camera_back_outlined,
    color: Color(0xFFFACC15),
  ),
  VideoCategory(
    id: 'vintage',
    title: 'Vintage',
    subtitle: 'Analog dokunuş',
    icon: Icons.camera_roll_outlined,
    color: Color(0xFFF472B6),
  ),
  VideoCategory(
    id: 'futuristic',
    title: 'Futuristic',
    subtitle: 'Bilim kurgu',
    icon: Icons.satellite_alt_outlined,
    color: Color(0xFF22D3EE),
  ),
  VideoCategory(
    id: 'artistic',
    title: 'Artistic',
    subtitle: 'Sanatsal yorum',
    icon: Icons.brush_outlined,
    color: Color(0xFF14B8A6),
  ),
];
