import 'package:flutter/material.dart';

import '../data/model_option.dart';

class GenerationScreen extends StatefulWidget {
  const GenerationScreen({super.key, required this.modelOption});

  final ModelOption modelOption;

  @override
  State<GenerationScreen> createState() => _GenerationScreenState();
}

class _GenerationScreenState extends State<GenerationScreen> {
  late final TextEditingController _promptController;
  String? _selectedImageName;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _promptController = TextEditingController();
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _handleGenerate() async {
    setState(() {
      _isGenerating = true;
    });

    await Future<void>.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() {
      _isGenerating = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Backend yönlendirme katmanı hazır olduğunda bu buton aktive olacak.',
        ),
      ),
    );
  }

  void _mockSelectImage() {
    setState(() {
      _selectedImageName = 'placeholder_frame.png';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Görsel yükleme tasarım aşamasında. Firebase Storage entegrasyonu eklenecek.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.modelOption;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(model.name),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: model.primaryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              model.subtitle,
              style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF05060A), Color(0xFF101624)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ModelHeroCard(model: model),
                const SizedBox(height: 32),
                if (model.supportsText) ...[
                  Text(
                    'Prompt',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _promptController,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      hintText:
                          'Örn. neon ışıklı bir şehirde yağmur altında yürüyen bir samuray',
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
                if (model.supportsImage) ...[
                  Text(
                    'Referans Görsel',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ImagePickerPlaceholder(
                    selectedImageName: _selectedImageName,
                    onTap: _mockSelectImage,
                  ),
                  const SizedBox(height: 28),
                ],
                Text(
                  'Model Hakkında',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(model.description, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isGenerating ? null : _handleGenerate,
                    child: _isGenerating
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.6,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text('Generate'),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Oluşturma tamamlandığında videonuz My Videos sekmesinde görüntülenecek.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModelHeroCard extends StatelessWidget {
  const _ModelHeroCard({required this.model});

  final ModelOption model;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          colors: [
            model.primaryColor.withValues(alpha: 0.22),
            model.secondaryColor.withValues(alpha: 0.18),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            model.subtitle,
            style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _ChipIcon(
                icon: Icons.text_fields,
                label: model.supportsText
                    ? 'Metin Prompt'
                    : 'Metin Desteklenmiyor',
                active: model.supportsText,
              ),
              _ChipIcon(
                icon: Icons.image_outlined,
                label: model.supportsImage
                    ? 'Görsel Referans'
                    : 'Görsel Desteklenmiyor',
                active: model.supportsImage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChipIcon extends StatelessWidget {
  const _ChipIcon({
    required this.icon,
    required this.label,
    required this.active,
  });

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: active
            ? Colors.white.withValues(alpha: 0.12)
            : Colors.white.withValues(alpha: 0.04),
        border: Border.all(
          color: Colors.white.withValues(alpha: active ? 0.22 : 0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.white70),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _ImagePickerPlaceholder extends StatelessWidget {
  const _ImagePickerPlaceholder({
    required this.selectedImageName,
    required this.onTap,
  });

  final String? selectedImageName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedImageName != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          color: Colors.white.withValues(alpha: 0.02),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasSelection
                  ? Icons.check_circle_outline
                  : Icons.cloud_upload_outlined,
              size: 42,
              color: Colors.white70,
            ),
            const SizedBox(height: 12),
            Text(
              hasSelection
                  ? selectedImageName!
                  : 'Görsel seç veya sürükle bırak',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'PNG, JPG • Maks 10 MB',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }
}
