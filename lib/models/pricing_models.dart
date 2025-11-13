import 'package:cloud_firestore/cloud_firestore.dart';

class PricingPlan {
  final String id;
  final int credits;
  final String price;
  final String label;
  final String? frequency;
  final String? badge;
  final bool highlight;

  const PricingPlan({
    required this.id,
    required this.credits,
    required this.price,
    required this.label,
    this.frequency,
    this.badge,
    this.highlight = false,
  });

  factory PricingPlan.fromMap(Map<String, dynamic> data) {
    return PricingPlan(
      id: data['id'] as String? ?? data['productId'] as String? ?? '',
      credits: (data['credits'] is int)
          ? data['credits'] as int
          : (data['credits'] as num?)?.toInt() ?? 0,
      price:
          data['price'] as String? ??
          data['priceText'] as String? ??
          data['displayPrice'] as String? ??
          '',
      label: data['label'] as String? ?? data['title'] as String? ?? '',
      frequency: data['frequency'] as String?,
      badge: data['badge'] as String?,
      highlight: data['highlight'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'credits': credits,
      'price': price,
      'label': label,
      if (frequency != null) 'frequency': frequency,
      if (badge != null) 'badge': badge,
      if (highlight) 'highlight': highlight,
    };
  }
}

class PricingConfig {
  final List<PricingPlan> subscriptions;
  final List<PricingPlan> creditPacks;

  const PricingConfig({required this.subscriptions, required this.creditPacks});

  factory PricingConfig.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final subscriptionData =
        (data['subscriptionPlans'] as List<dynamic>? ?? <dynamic>[])
            .map(
              (item) =>
                  PricingPlan.fromMap(Map<String, dynamic>.from(item as Map)),
            )
            .where((plan) => plan.id.isNotEmpty)
            .toList();
    final creditPackData =
        (data['creditPackPlans'] as List<dynamic>? ?? <dynamic>[])
            .map(
              (item) =>
                  PricingPlan.fromMap(Map<String, dynamic>.from(item as Map)),
            )
            .where((plan) => plan.id.isNotEmpty)
            .toList();

    return PricingConfig(
      subscriptions: subscriptionData.isNotEmpty
          ? subscriptionData
          : PricingConfig.defaults().subscriptions,
      creditPacks: creditPackData.isNotEmpty
          ? creditPackData
          : PricingConfig.defaults().creditPacks,
    );
  }

  factory PricingConfig.defaults() {
    return const PricingConfig(
      subscriptions: [
        PricingPlan(
          id: 'starter_weekly',
          credits: 5,
          price: '₺449,99',
          label: 'Starter weekly pack',
          frequency: 'Weekly',
        ),
        PricingPlan(
          id: 'growth_monthly',
          credits: 20,
          price: '₺1.299,99',
          label: 'Growth monthly plan',
          badge: 'Popular',
          highlight: true,
          frequency: 'Monthly',
        ),
        PricingPlan(
          id: 'studio_annual',
          credits: 240,
          price: '₺2.999,99',
          label: 'Studio annual plan',
          frequency: 'Annual',
        ),
      ],
      creditPacks: [
        PricingPlan(
          id: 'credits_5',
          credits: 5,
          price: '₺599,99',
          label: '5 credit add-on',
          frequency: 'One-time',
        ),
        PricingPlan(
          id: 'credits_10',
          credits: 10,
          price: '₺999,99',
          label: '10 credit add-on',
          frequency: 'One-time',
        ),
        PricingPlan(
          id: 'credits_20',
          credits: 20,
          price: '₺2.299,99',
          label: '20 credit add-on',
          badge: 'Best value',
          highlight: true,
          frequency: 'One-time',
        ),
      ],
    );
  }
}
