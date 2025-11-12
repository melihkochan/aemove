import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profilim',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF05060A), Color(0xFF0F172A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
            children: [
              Row(
                children: [
                  Container(
                    height: 72,
                    width: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withValues(alpha: 0.7),
                          theme.colorScheme.primary.withValues(alpha: 0.4),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Melih Koçhan',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Pro kullanıcı • Kasım 2025’ten beri',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Kredi',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.white60,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '24',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Hızlı İşlemler',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              _ProfileActionTile(
                icon: Icons.credit_card,
                title: 'Kredi Yönetimi',
                subtitle: 'Planını güncelle, geçmişi görüntüle',
                onTap: () {},
              ),
              _ProfileActionTile(
                icon: Icons.bolt_outlined,
                title: 'API Entegrasyonları',
                subtitle: 'Bağlı model anahtarlarını yönet',
                onTap: () {},
              ),
              _ProfileActionTile(
                icon: Icons.security_outlined,
                title: 'Güvenlik',
                subtitle: 'Çok faktörlü giriş, cihaz yönetimi',
                onTap: () {},
              ),
              _ProfileActionTile(
                icon: Icons.help_outline,
                title: 'Destek',
                subtitle: 'Sık sorulan sorular ve canlı destek',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  const _ProfileActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.03),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.18),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 18,
          color: Colors.white54,
        ),
      ),
    );
  }
}
