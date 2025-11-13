import 'dart:async';

import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/firestore_repository.dart';

class CoffeeFortuneScreen extends StatefulWidget {
  const CoffeeFortuneScreen({super.key});

  @override
  State<CoffeeFortuneScreen> createState() => _CoffeeFortuneScreenState();
}

class _CoffeeFortuneScreenState extends State<CoffeeFortuneScreen> {
  static const int _fortuneCostCredits = 5;
  static const double _fortuneCostCash = 0.5;

  StreamSubscription<UserProfile>? _profileSub;
  UserProfile? _profile;
  String? _selectedImagePath;
  final TextEditingController _promptController = TextEditingController();

  @override
  void dispose() {
    _profileSub?.cancel();
    _promptController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _listenProfile();
  }

  Future<void> _listenProfile() async {
    final user = await AuthService.ensureSignedIn();
    await _profileSub?.cancel();
    _profileSub = FirestoreRepository.userProfileStream(user.uid).listen((
      profile,
    ) {
      if (!mounted) return;
      setState(() => _profile = profile);
    });
  }

  int get _availableCredits => _profile?.credits ?? 0;
  bool get _canUseCredits => _availableCredits >= _fortuneCostCredits;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0717), Color(0xFF120C27)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(
                        0xFF4F8BFF,
                      ).withValues(alpha: 0.15),
                      child: const Icon(
                        Icons.local_cafe_rounded,
                        color: Color(0xFF4F8BFF),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Coffee Fortune',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Upload your cup and let AI read the symbols.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _CupUploader(
                  imagePath: _selectedImagePath,
                  onTap: () {
                    // Placeholder: integrate image picker later.
                    setState(() {
                      _selectedImagePath = 'mock';
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Image picker integration coming soon. Using placeholder image.',
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                _CostSummary(
                  credits: _availableCredits,
                  creditCost: _fortuneCostCredits,
                  cashCost: _fortuneCostCash,
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: const Color(0xFF101226),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.04),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lightbulb_outline,
                        color: Color(0xFF4F8BFF),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'No prompt? No problem. We will interpret the cup freely if you leave it empty.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                _ActionButtons(
                  enabled: _selectedImagePath != null,
                  canUseCredits: _canUseCredits,
                  onUseCredits: _canUseCredits
                      ? () => _showPendingSheet(context, theme)
                      : null,
                  onBuySingle: _selectedImagePath == null
                      ? null
                      : () => _showCheckoutSheet(context, theme),
                  creditCost: _fortuneCostCredits,
                  cashCost: _fortuneCostCash,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPendingSheet(BuildContext context, ThemeData theme) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.black.withValues(alpha: 0.85),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Text(
                  'Reading in progress…',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'We will send you a notification once the reading is ready.',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCheckoutSheet(BuildContext context, ThemeData theme) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.black.withValues(alpha: 0.85),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Single reading',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'We’ll charge you ${_fortuneCostCash.toStringAsFixed(2)} USD for this fortune.',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF4F8BFF),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Proceed to payment'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CupUploader extends StatelessWidget {
  const _CupUploader({required this.imagePath, required this.onTap});

  final String? imagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          gradient: const LinearGradient(
            colors: [Color(0xFF151B3A), Color(0xFF0C0F24)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: imagePath == null ? 0 : 1,
                child: imagePath == null
                    ? const SizedBox.shrink()
                    : Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF1E2030), Color(0xFF141725)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(
                    alpha: imagePath == null ? 0.15 : 0.35,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 54,
                    width: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.1),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: const Icon(
                      Icons.upload_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    imagePath == null
                        ? 'Tap to upload your cup photo'
                        : 'Tap to change the photo',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Use a clear shot of the inner cup for better interpretation.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CostSummary extends StatelessWidget {
  const _CostSummary({
    required this.credits,
    required this.creditCost,
    required this.cashCost,
  });

  final int credits;
  final int creditCost;
  final double cashCost;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canAfford = credits >= creditCost;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withValues(alpha: 0.03),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.currency_exchange,
            color: canAfford ? Colors.white : Colors.white70,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cost: $creditCost credits',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Credits you have: $credits',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: canAfford ? Colors.white70 : Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white.withValues(alpha: 0.08),
            ),
            child: Text(
              '${cashCost.toStringAsFixed(2)} USD',
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.enabled,
    required this.canUseCredits,
    required this.onUseCredits,
    required this.onBuySingle,
    required this.creditCost,
    required this.cashCost,
  });

  final bool enabled;
  final bool canUseCredits;
  final VoidCallback? onUseCredits;
  final VoidCallback? onBuySingle;
  final int creditCost;
  final double cashCost;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: enabled && canUseCredits ? onUseCredits : null,
          icon: const Icon(Icons.auto_awesome),
          label: Text('Use $creditCost credits'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
            backgroundColor: const Color(0xFF4F8BFF),
            disabledBackgroundColor: const Color(
              0xFF4F8BFF,
            ).withValues(alpha: 0.35),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: enabled ? onBuySingle : null,
          icon: const Icon(Icons.credit_card),
          label: Text(
            'Buy single reading (${cashCost.toStringAsFixed(2)} USD)',
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.35)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            foregroundColor: Colors.white,
            textStyle: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (!canUseCredits && enabled)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'You need $creditCost credits. Buy once or refill from the account tab.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.redAccent,
              ),
            ),
          ),
      ],
    );
  }
}
