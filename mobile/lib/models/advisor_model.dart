class CropRecommendationModel {
  final String name;
  final String nameHi;
  final String variety;
  final String category;
  final String categoryHi;
  final String seasonWindow;
  final String suitability;
  final String duration;
  final String estYield;
  final String estProfit;
  final String keyAdvice;
  final String keyAdviceHi;
  final bool isTopPick;

  CropRecommendationModel({
    required this.name,
    required this.nameHi,
    required this.variety,
    required this.category,
    required this.categoryHi,
    required this.seasonWindow,
    required this.suitability,
    required this.duration,
    required this.estYield,
    required this.estProfit,
    required this.keyAdvice,
    required this.keyAdviceHi,
    required this.isTopPick,
  });

  factory CropRecommendationModel.fromJson(Map<String, dynamic> json) {
    return CropRecommendationModel(
      name: json['name'] ?? '',
      nameHi: json['name_hi'] ?? '',
      variety: json['variety'] ?? '',
      category: json['category'] ?? '',
      categoryHi: json['category_hi'] ?? '',
      seasonWindow: json['season_window'] ?? '',
      suitability: json['suitability'] ?? '✓ High Suitability',
      duration: json['duration'] ?? '',
      estYield: json['est_yield'] ?? '',
      estProfit: json['est_profit'] ?? '',
      keyAdvice: json['key_advice'] ?? '',
      keyAdviceHi: json['key_advice_hi'] ?? '',
      isTopPick: json['is_top_pick'] ?? false,
    );
  }
}

class AdvisorResponseModel {
  final String summary;
  final String summaryHi;
  final List<CropRecommendationModel> crops;
  final List<String> bestPractices;
  final List<String> bestPracticesHi;

  AdvisorResponseModel({
    required this.summary,
    required this.summaryHi,
    required this.crops,
    required this.bestPractices,
    required this.bestPracticesHi,
  });

  factory AdvisorResponseModel.fromJson(Map<String, dynamic> json) {
    return AdvisorResponseModel(
      summary: json['summary'] ?? '',
      summaryHi: json['summary_hi'] ?? '',
      crops: (json['crops'] as List<dynamic>?)
              ?.map((c) => CropRecommendationModel.fromJson(c))
              .toList() ??
          [],
      bestPractices: (json['best_practices'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      bestPracticesHi: (json['best_practices_hi'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class AdvisorQueryResponseModel {
  final String title;
  final String verifiedLabel;
  final String answer;
  final String answerHi;
  final List<String> tags;

  AdvisorQueryResponseModel({
    required this.title,
    required this.verifiedLabel,
    required this.answer,
    required this.answerHi,
    required this.tags,
  });

  factory AdvisorQueryResponseModel.fromJson(Map<String, dynamic> json) {
    return AdvisorQueryResponseModel(
      title: json['title'] ?? 'Agronomy Engine Advisory',
      verifiedLabel: json['verified_label'] ?? 'Verified guidance',
      answer: json['answer'] ?? '',
      answerHi: json['answer_hi'] ?? '',
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
