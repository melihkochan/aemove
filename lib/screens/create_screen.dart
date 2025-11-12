import 'package:flutter/material.dart';

import '../data/home_content.dart';
import '../data/model_option.dart';
import 'generation_screen.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  int _selectedTab = 0;
  String _selectedModelId = modelOptions.first.id;
  String _selectedQuality = 'Pro';
  String _selectedRatio = '16:9';
  bool _showSettings = false;
  final int _availableCredits = 24;
  final TextEditingController _promptController = TextEditingController();

  ModelOption? _findModel(String id) {
    for (final option in modelOptions) {
      if (option.id == id) {
        return option;
      }
    }
    return null;
  }

  static const Map<String, int> _creditMap = {
    'sora-2': 18,
    'veo-3-1': 16,
    'kling-2-5': 9,
    'fal-svd': 6,
  };

  static const List<String> _qualityOptions = ['Pro', 'High', 'Draft'];
  static const List<String> _ratios = ['16:9', '9:16', '1:1'];

  int get _selectedModelCredits => _creditMap[_selectedModelId] ?? 8;

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _pickImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image picker placeholder • integration coming soon.'),
      ),
    );
  }

  void _handleGenerate() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Generation request queued for model ${_selectedModelId.toUpperCase()}.\nAPI hooks will be connected soon.',
        ),
      ),
    );
  }

  List<CapabilityTemplate> _templatesForTab(int tab) {
    switch (tab) {
      case 1:
        return capabilityTemplates;
      case 2:
        return capabilityTemplates
            .where((template) => template.categoryId == 'polaroid')
            .toList();
      default:
        return const [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 0, label: Text('Custom Build')),
                    ButtonSegment(value: 1, label: Text('Effects Library')),
                    ButtonSegment(value: 2, label: Text('Polaroid Styles')),
                  ],
                  selected: {_selectedTab},
                  onSelectionChanged: (value) =>
                      setState(() => _selectedTab = value.first),
                ),
                const SizedBox(height: 32),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _selectedTab == 0
                      ? _buildCustomComposer(theme)
                      : _buildTemplateLibrary(
                          theme,
                          _templatesForTab(_selectedTab),
                          _selectedTab == 1
                              ? 'Effects library will expand every week.'
                              : 'Polaroid presets are uploading. Stay tuned.',
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomComposer(ThemeData theme) {
    return Column(
      key: const ValueKey('custom'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select AI model',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: modelOptions.map((option) {
            final isSelected = option.id == _selectedModelId;
            return ChoiceChip(
              label: Text(option.name),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedModelId = option.id),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Colors.white.withValues(alpha: 0.02),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                modelOptions
                    .firstWhere((element) => element.id == _selectedModelId)
                    .description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.token, size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    '$_selectedModelCredits credits',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.memory_outlined, size: 18, color: Colors.white54),
                  const SizedBox(width: 6),
                  Text(
                    _selectedQuality,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Reference image',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              color: Colors.white.withValues(alpha: 0.02),
            ),
            child: Column(
              children: [
                Icon(Icons.image_outlined, color: Colors.white60, size: 32),
                const SizedBox(height: 12),
                Text(
                  'Upload or drag an image',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Prompt',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _promptController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Describe your scene, actions and mood...',
          ),
        ),
        const SizedBox(height: 28),
        const SizedBox(height: 28),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Colors.white.withValues(alpha: 0.02),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => setState(() => _showSettings = !_showSettings),
                borderRadius: BorderRadius.circular(22),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.18,
                          ),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Video settings',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$_selectedRatio • $_selectedQuality',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 200),
                        turns: _showSettings ? 0.5 : 0,
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        'Aspect ratio',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton<String>(
                        segments: _ratios
                            .map(
                              (ratio) => ButtonSegment(
                                value: ratio,
                                label: Text(ratio),
                              ),
                            )
                            .toList(),
                        selected: {_selectedRatio},
                        onSelectionChanged: (value) =>
                            setState(() => _selectedRatio = value.first),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Render quality',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton<String>(
                        segments: _qualityOptions
                            .map(
                              (quality) => ButtonSegment(
                                value: quality,
                                label: Text(quality),
                              ),
                            )
                            .toList(),
                        selected: {_selectedQuality},
                        onSelectionChanged: (value) =>
                            setState(() => _selectedQuality = value.first),
                      ),
                    ],
                  ),
                ),
                crossFadeState: _showSettings
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 220),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _availableCredits >= _selectedModelCredits
                ? _handleGenerate
                : null,
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(
              _availableCredits >= _selectedModelCredits
                  ? 'Generate • $_selectedModelCredits credits'
                  : 'Need $_selectedModelCredits credits',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateLibrary(
    ThemeData theme,
    List<CapabilityTemplate> templates,
    String emptyCaption,
  ) {
    if (templates.isEmpty) {
      return Container(
        key: ValueKey('library-empty-$_selectedTab'),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Colors.white.withValues(alpha: 0.02),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Text(
          emptyCaption,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
      );
    }

    return GridView.builder(
      key: ValueKey('library-$_selectedTab'),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: templates.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) {
        final template = templates[index];
        return GestureDetector(
          onTap: () => _handleCapabilityTap(template),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (template.imageUrl != null)
                  Image.network(
                    template.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: Colors.white.withValues(alpha: 0.08)),
                  )
                else
                  Container(color: Colors.white.withValues(alpha: 0.06)),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.05),
                          Colors.black.withValues(alpha: 0.8),
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
                          color: Colors.white.withValues(alpha: 0.18),
                        ),
                        child: Text(
                          template.categoryId.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        template.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        template.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.token, size: 16, color: Colors.white60),
                          const SizedBox(width: 6),
                          Text(
                            '+${template.creditCost} credits',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
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
        );
      },
    );
  }

  void _handleCapabilityTap(CapabilityTemplate template) {
    final model = _findModel(template.modelId);
    if (model == null || model.isComingSoon) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${template.title} template will be unlocked once ${template.modelId.toUpperCase()} access opens.',
          ),
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => GenerationScreen(modelOption: model)),
    );
  }
}
