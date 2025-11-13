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
  int _selectedWorkflow = 0;
  late String _selectedModelId;

  @override
  void initState() {
    super.initState();
    _promptController = TextEditingController();
    _selectedModelId = widget.modelOption.id;
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
    final models = modelOptions;
    final selectedModel = models.firstWhere((m) => m.id == _selectedModelId,
        orElse: () => widget.modelOption);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Create'),
        actions: const [
          _CreateCreditPill(credits: 24),
          SizedBox(width: 16),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF121318), Color(0xFF090A0D)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: _CreateContent(
            models: models,
            selectedModel: selectedModel,
            selectedWorkflow: _selectedWorkflow,
            promptController: _promptController,
            selectedImageName: _selectedImageName,
            isGenerating: _isGenerating,
            onWorkflowChanged: (index) {
              setState(() => _selectedWorkflow = index);
            },
            onModelChanged: (modelId) {
              setState(() => _selectedModelId = modelId);
            },
            onSelectImage: _mockSelectImage,
            onGenerate: _handleGenerate,
          ),
        ),
      ),
    );
  }
}

class _CreateContent extends StatelessWidget {
  const _CreateContent({
    required this.models,
    required this.selectedModel,
    required this.selectedWorkflow,
    required this.promptController,
    required this.selectedImageName,
    required this.isGenerating,
    required this.onWorkflowChanged,
    required this.onModelChanged,
    required this.onSelectImage,
    required this.onGenerate,
  });

  final List<ModelOption> models;
  final ModelOption selectedModel;
  final int selectedWorkflow;
  final TextEditingController promptController;
  final String? selectedImageName;
  final bool isGenerating;
  final ValueChanged<int> onWorkflowChanged;
  final ValueChanged<String> onModelChanged;
  final VoidCallback onSelectImage;
  final VoidCallback onGenerate;

  static const _workflows = ['Custom Build', 'Effects Library', 'Polaroid Styles'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Workflow',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(color: Colors.white70)),
                const SizedBox(height: 12),
                _SegmentedTabs(
                  items: _workflows,
                  selectedIndex: selectedWorkflow,
                  onChanged: onWorkflowChanged,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Select AI model',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: models.map((model) {
              final isSelected = model.id == selectedModel.id;
              return _ModelChip(
                model: model,
                selected: isSelected,
                onTap: () => onModelChanged(model.id),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          _ModelDetailCard(model: selectedModel),
          const SizedBox(height: 28),
          if (selectedModel.supportsImage) ...[
            Text(
              'Reference image',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _ImagePickerCard(
              selectedImageName: selectedImageName,
              onTap: onSelectImage,
            ),
            const SizedBox(height: 28),
          ],
          if (selectedModel.supportsText) ...[
            Text(
              'Prompt',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _PromptInput(controller: promptController),
            const SizedBox(height: 28),
          ],
          _GenerateButton(
            isGenerating: isGenerating,
            onTap: onGenerate,
          ),
          const SizedBox(height: 16),
          Text(
            'Oluşturma tamamlandığında videonuz My Videos sekmesinde görüntülenecek.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.03),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final isSelected = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFF2C4CFF), Color(0xFF5C7CFF)],
                        )
                      : null,
                ),
                child: Text(
                  items[index],
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _ModelChip extends StatelessWidget {
  const _ModelChip({
    required this.model,
    required this.selected,
    required this.onTap,
  });

  final ModelOption model;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: selected
              ? Colors.white.withOpacity(0.12)
              : Colors.white.withOpacity(0.04),
          border: Border.all(
            color: selected
                ? Colors.white.withOpacity(0.25)
                : Colors.white.withOpacity(0.08),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 18,
              color: Colors.white.withOpacity(selected ? 0.95 : 0.55),
            ),
            const SizedBox(width: 10),
            Text(
              model.name,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModelDetailCard extends StatelessWidget {
  const _ModelDetailCard({required this.model});

  final ModelOption model;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            model.primaryColor.withOpacity(0.22),
            model.secondaryColor.withOpacity(0.16),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.auto_awesome,
                    color: Colors.white.withOpacity(0.9)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      model.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_fix_high,
                      size: 18, color: Colors.white.withOpacity(0.8)),
                  const SizedBox(width: 6),
                  Text('18 credits',
                      style: theme.textTheme.labelLarge
                          ?.copyWith(color: Colors.white)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            model.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagePickerCard extends StatelessWidget {
  const _ImagePickerCard({required this.selectedImageName, required this.onTap});

  final String? selectedImageName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedImageName != null;
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white.withOpacity(0.03),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasSelection
                  ? Icons.check_circle
                  : Icons.broken_image_outlined,
              size: 38,
              color: Colors.white.withOpacity(0.75),
            ),
            const SizedBox(height: 12),
            Text(
              hasSelection
                  ? selectedImageName!
                  : 'Upload or drag an image',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.85),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'PNG, JPG • Max 10 MB',
              style:
                  theme.textTheme.bodySmall?.copyWith(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromptInput extends StatelessWidget {
  const _PromptInput({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withOpacity(0.03),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: TextField(
        controller: controller,
        maxLines: 6,
        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          border: InputBorder.none,
          hintText: 'Describe your scene, actions and mood...',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withOpacity(0.4),
          ),
        ),
      ),
    );
  }
}

class _GenerateButton extends StatelessWidget {
  const _GenerateButton({required this.isGenerating, required this.onTap});

  final bool isGenerating;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          backgroundColor: const Color(0xFF2C4CFF),
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        onPressed: isGenerating ? null : onTap,
        child: isGenerating
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text('Generate video'),
      ),
    );
  }
}

class _CreateCreditPill extends StatelessWidget {
  const _CreateCreditPill({required this.credits});

  final int credits;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: const Color(0xFF2957FF),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0x332857FF),
            ),
            child: const Icon(Icons.bolt, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          Text(
            '$credits',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ) ??
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
          ),
        ],
      ),
    );
  }
}
