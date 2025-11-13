import 'package:flutter/material.dart';

import '../data/home_content.dart';
import '../data/model_option.dart';
import 'generation_screen.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _ModeOption {
  const _ModeOption({
    required this.id,
    required this.label,
    required this.icon,
    this.badge,
    this.subtitle,
    this.tabIndex,
  });

  final String id;
  final String label;
  final IconData icon;
  final String? badge;
  final String? subtitle;
  final int? tabIndex;
}

class _CreateScreenState extends State<CreateScreen> {
  static const List<_ModeOption> _modeOptions = [
    _ModeOption(
      id: 'custom',
      label: 'Custom',
      subtitle: 'Free-build with full control',
      icon: Icons.auto_awesome,
      tabIndex: 0,
      badge: 'LIVE',
    ),
    _ModeOption(
      id: 'effects',
      label: 'Effects',
      subtitle: 'Stylised presets and transitions',
      icon: Icons.bolt_outlined,
      tabIndex: 1,
    ),
    _ModeOption(
      id: 'camera',
      label: 'Camera Controls',
      subtitle: 'Cinema-grade moves',
      icon: Icons.videocam_outlined,
    ),
    _ModeOption(
      id: 'polaroid',
      label: 'Polaroid',
      subtitle: 'Instant retro treatment',
      icon: Icons.photo_camera_back_outlined,
      tabIndex: 2,
    ),
    _ModeOption(
      id: 'restore',
      label: 'Photo Restore',
      subtitle: 'Fix old captures fast',
      icon: Icons.auto_fix_high_outlined,
    ),
    _ModeOption(
      id: 'swap',
      label: 'Character Swap',
      subtitle: 'Face swap for scenes',
      icon: Icons.people_outline,
    ),
  ];

  int _selectedTab = 0;
  late _ModeOption _activeMode;
  String _selectedModelId = modelOptions.first.id;
  String _selectedQuality = 'Pro';
  String _selectedRatio = '16:9';
  bool _aiAssist = true;
  final int _availableCredits = 24;
  final TextEditingController _promptController = TextEditingController();

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
  void initState() {
    super.initState();
    _activeMode = _modeOptions.first;
  }

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
          'Generation request queued for ${_selectedModelId.toUpperCase()} • API hooks coming soon.',
        ),
      ),
    );
  }

  void _handleModeSelected(_ModeOption option) {
    setState(() {
      _activeMode = option;
      if (option.tabIndex != null) {
        _selectedTab = option.tabIndex!;
      } else {
        _selectedTab = 0;
      }
    });

    if (option.tabIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${option.label} mode is launching soon.'),
        ),
      );
    }
  }

  ModelOption? _findModel(String id) {
    for (final option in modelOptions) {
      if (option.id == id) {
        return option;
      }
    }
    return null;
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
    final accent = const Color(0xFF4F8BFF);
    final bool comingSoon = _activeMode.tabIndex == null;
    final int activeTabIndex = _activeMode.tabIndex ?? 0;

    Widget content;
    if (activeTabIndex == 0) {
      content = _buildCustomComposer(theme, accent);
    } else {
      final templates = _templatesForTab(activeTabIndex);
      final info = activeTabIndex == 1
          ? 'Effects library grows weekly with new presets.'
          : 'Polaroid presets are uploading. Stay tuned.';
      content = _buildTemplateLibrary(theme, templates, info, accent);
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
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
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CreateHeader(
                  accent: accent,
                  credits: _availableCredits,
                  selectedMode: _activeMode,
                  onModeSelected: _handleModeSelected,
                ),
                const SizedBox(height: 24),
                if (comingSoon)
                  _ComingSoonBanner(accent: accent, mode: _activeMode),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  child: content,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomComposer(ThemeData theme, Color accent) {
    final selectedModel = _findModel(_selectedModelId) ?? modelOptions.first;

    return Column(
      key: const ValueKey('custom'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI provider',
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white70,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: modelOptions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final option = modelOptions[index];
            final isSelected = option.id == _selectedModelId;
              return _ModelCard(
                option: option,
                isSelected: isSelected,
                accent: accent,
                onTap: () => setState(() => _selectedModelId = option.id),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        _ModelDescriptionCard(
          option: selectedModel,
          credits: _selectedModelCredits,
          accent: accent,
        ),
        const SizedBox(height: 28),
        _UploadPanel(accent: accent, onTap: _pickImage),
        const SizedBox(height: 24),
        _PromptComposer(
          controller: _promptController,
          accent: accent,
          aiAssist: _aiAssist,
          onToggle: (value) => setState(() => _aiAssist = value),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _openSettingsSheet,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withOpacity(0.12)),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.tune_rounded, size: 20),
                label: const Text('Video settings'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _availableCredits >= _selectedModelCredits
                    ? _handleGenerate
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.white,
                  elevation: 8,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.play_arrow_rounded, size: 22),
                label: Text(
                  _availableCredits >= _selectedModelCredits
                      ? 'Generate • $_selectedModelCredits credits'
                      : 'Need $_selectedModelCredits credits',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTemplateLibrary(
    ThemeData theme,
    List<CapabilityTemplate> templates,
    String message,
    Color accent,
  ) {
    return Column(
      key: ValueKey('tab-$_selectedTab'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Colors.white.withOpacity(0.04),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: accent, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (templates.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: Colors.white.withOpacity(0.03),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Text(
              'Library is loading in the background. Check back shortly.',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white60),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 18,
              crossAxisSpacing: 18,
              childAspectRatio: 0.78,
            ),
            itemCount: templates.length,
            itemBuilder: (context, index) {
              final template = templates[index];
              return _TemplateCard(template: template, accent: accent);
            },
          ),
      ],
    );
  }

  void _openSettingsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0C1324),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.tune_rounded, color: Colors.white70),
                  const SizedBox(width: 12),
                  Text(
                    'Video settings',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Aspect ratio',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white60,
                    ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                children: _ratios
                    .map(
                      (ratio) => ChoiceChip(
                        label: Text(ratio),
                        selected: _selectedRatio == ratio,
                        onSelected: (selected) {
                          if (!selected) return;
                          setState(() => _selectedRatio = ratio);
                        },
                        selectedColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Colors.white.withOpacity(0.06),
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),
              Text(
                'Render quality',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white60,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                children: _qualityOptions
                    .map(
                      (quality) => ChoiceChip(
                        label: Text(quality),
                        selected: _selectedQuality == quality,
                        onSelected: (selected) {
                          if (!selected) return;
                          setState(() => _selectedQuality = quality);
                        },
                        selectedColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Colors.white.withOpacity(0.06),
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CreateHeader extends StatelessWidget {
  const _CreateHeader({
    required this.accent,
    required this.credits,
    required this.selectedMode,
    required this.onModeSelected,
  });

  final Color accent;
  final int credits;
  final _ModeOption selectedMode;
  final ValueChanged<_ModeOption> onModeSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ModeSelector(
          accent: accent,
          selected: selectedMode,
          onSelected: onModeSelected,
        ),
      ],
    );
  }
}

class _ModeSelector extends StatelessWidget {
  const _ModeSelector({
    required this.accent,
    required this.selected,
    required this.onSelected,
  });

  final Color accent;
  final _ModeOption selected;
  final ValueChanged<_ModeOption> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_ModeOption>(
      onSelected: onSelected,
      color: const Color(0xFF101522),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      itemBuilder: (context) {
        return _CreateScreenState._modeOptions
            .map(
              (option) => PopupMenuItem<_ModeOption>(
                value: option,
                child: Row(
                  children: [
                    Icon(option.icon, color: Colors.white70, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                option.label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (option.badge != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: accent.withOpacity(0.16),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    option.badge!,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: accent,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (option.subtitle != null)
                            Text(
                              option.subtitle!,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.04),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(selected.icon, color: accent, size: 20),
            const SizedBox(width: 12),
            Text(
              selected.label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}

class _ComingSoonBanner extends StatelessWidget {
  const _ComingSoonBanner({required this.accent, required this.mode});

  final Color accent;
  final _ModeOption mode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white.withOpacity(0.03),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Icon(Icons.construction_rounded, color: accent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${mode.label} mode is under construction. Explore Custom or Effects while we finish it.',
              style: const TextStyle(color: Colors.white70, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModelCard extends StatelessWidget {
  const _ModelCard({
    required this.option,
    required this.isSelected,
    required this.accent,
    required this.onTap,
  });

  final ModelOption option;
  final bool isSelected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: Colors.white.withOpacity(0.04),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.35),
                  ),
                  child: Icon(Icons.bubble_chart,
                      color: Colors.white.withOpacity(0.9), size: 20),
                ),
                const Spacer(),
                if (option.badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? accent : Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      option.badge!,
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              option.name,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              option.subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModelDescriptionCard extends StatelessWidget {
  const _ModelDescriptionCard({
    required this.option,
    required this.credits,
    required this.accent,
  });

  final ModelOption option;
  final int credits;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withOpacity(0.03),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            option.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
              Row(
                children: [
              Icon(Icons.token_outlined, size: 18, color: accent),
                  const SizedBox(width: 8),
                  Text(
                '$credits credits',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
              Icon(Icons.collections_bookmark_outlined,
                  size: 18, color: Colors.white54),
                  const SizedBox(width: 6),
                  Text(
                option.mode == GenerationMode.textAndImage ? 'Hybrid' : 'Text',
                style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
  }
}

class _UploadPanel extends StatelessWidget {
  const _UploadPanel({required this.accent, required this.onTap});

  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
            decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white.withOpacity(0.03),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Column(
              children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withOpacity(0.18),
              ),
              child: Icon(Icons.image_outlined, color: accent, size: 28),
            ),
            const SizedBox(height: 14),
            Text(
              'Upload an image',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
                Text(
              'Optional reference to steer the look',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

class _PromptComposer extends StatelessWidget {
  const _PromptComposer({
    required this.controller,
    required this.accent,
    required this.aiAssist,
    required this.onToggle,
  });

  final TextEditingController controller;
  final Color accent;
  final bool aiAssist;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withOpacity(0.03),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
        Text(
          'Prompt',
          style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                'AI',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(width: 6),
              Switch(
                value: aiAssist,
                activeColor: Colors.black,
                activeTrackColor: accent,
                onChanged: onToggle,
              ),
            ],
        ),
        const SizedBox(height: 12),
        TextField(
            controller: controller,
          maxLines: 5,
            style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
              hintText: 'Describe the action, environment and mood…',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white38,
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.02),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: accent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({required this.template, required this.accent});

  final CapabilityTemplate template;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.03),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
            height: 110,
                        decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withOpacity(0.06),
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1534447677768-be436bb09401?auto=format&fit=crop&w=600&q=60'),
                fit: BoxFit.cover,
                          ),
                        ),
                      ),
          const SizedBox(height: 12),
                      Text(
                        template.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
              fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        template.subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white60,
              height: 1.3,
                  ),
                ),
              ],
            ),
    );
  }
}
