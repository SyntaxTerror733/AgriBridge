import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';
import '../models/advisor_model.dart';
import '../services/api_service.dart';

class CropAdvisorSection extends StatefulWidget {
  const CropAdvisorSection({super.key});

  @override
  State<CropAdvisorSection> createState() => _CropAdvisorSectionState();
}

class _CropAdvisorSectionState extends State<CropAdvisorSection> {
  // Plot configuration defaults
  String _selectedState = 'Uttar Pradesh';
  String _selectedSeason = 'Rabi (Winter: Nov - Apr)';
  String _selectedSoil = 'Alluvial Soil (जलोढ़ मिट्टी)';
  String _selectedWater = 'Canal / Borewell (Assured High)';

  // Options
  final List<String> _states = [
    'Uttar Pradesh',
    'Punjab',
    'Haryana',
    'Madhya Pradesh',
    'Maharashtra',
    'Rajasthan',
    'Bihar',
    'Gujarat',
  ];

  final List<String> _seasons = [
    'Rabi (Winter: Nov - Apr)',
    'Kharif (Monsoon: Jun - Oct)',
    'Zaid (Summer: Mar - Jun)',
  ];

  final List<String> _soils = [
    'Alluvial Soil (जलोढ़ मिट्टी)',
    'Black Soil (काली मिट्टी)',
    'Red / Yellow Soil (लाल / पीली मिट्टी)',
    'Sandy Loam (बलुई दोमट)',
    'Clay (चिकनी मिट्टी)',
  ];

  final List<String> _waterLevels = [
    'Canal / Borewell (Assured High)',
    'Medium / Tubewell',
    'Low / Rainfed',
  ];

  // States for Recommendations
  bool _isLoadingRecs = false;
  String? _recError;
  AdvisorResponseModel? _advisorResponse;

  // States for Q&A
  final TextEditingController _questionController = TextEditingController();
  bool _isLoadingQA = false;
  String? _qaError;
  AdvisorQueryResponseModel? _qaResponse;

  final List<String> _sampleQuestions = [
    "Best crop to plant after mustard?",
    "When should I do the first irrigation for wheat?",
    "Most profitable crop with low water requirement?",
  ];

  @override
  void initState() {
    super.initState();
    // Auto load initial recommendation
    _fetchRecommendations();
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _fetchRecommendations() async {
    setState(() {
      _isLoadingRecs = true;
      _recError = null;
    });

    try {
      final res = await ApiService.getRecommendations(
        state: _selectedState,
        season: _selectedSeason,
        soil: _selectedSoil,
        water: _selectedWater,
      );
      setState(() {
        _advisorResponse = res;
        _isLoadingRecs = false;
      });
    } catch (e) {
      setState(() {
        _recError = e.toString();
        _isLoadingRecs = false;
      });
    }
  }

  Future<void> _askQuestion([String? preset]) async {
    final q = preset ?? _questionController.text.trim();
    if (q.isEmpty) return;

    if (preset != null) {
      _questionController.text = preset;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoadingQA = true;
      _qaError = null;
    });

    try {
      final res = await ApiService.queryAdvisor(q);
      setState(() {
        _qaResponse = res;
        _isLoadingQA = false;
      });
    } catch (e) {
      setState(() {
        _qaError = e.toString();
        _isLoadingQA = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            AppStrings.advisorTitle,
            style: const TextStyle(
              fontFamily: 'BricolageGrotesque',
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.advisorSubtitle,
            style: const TextStyle(
              fontFamily: 'Hind',
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),

          // Configure Your Plot Card
          _buildConfigCard(),
          const SizedBox(height: 24),

          // Recommendations Output Area
          if (_isLoadingRecs)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: CircularProgressIndicator(color: AppColors.greenMint),
              ),
            )
          else if (_recError != null)
            _buildErrorBox(_recError!, _fetchRecommendations)
          else if (_advisorResponse != null)
            _buildRecommendationsView(_advisorResponse!),

          const SizedBox(height: 36),

          // "Ask the Agro Advisor" Area
          _buildAskAdvisorCard(),
        ],
      ),
    );
  }

  Widget _buildConfigCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.navyCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.navyBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tune, color: AppColors.greenMint, size: 20),
              const SizedBox(width: 8),
              Text(
                AppStrings.configurePlot,
                style: const TextStyle(
                  fontFamily: 'BricolageGrotesque',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // State Dropdown
          _buildDropdownField(
            label: AppStrings.stateRegion,
            value: _selectedState,
            items: _states,
            onChanged: (v) {
              if (v != null) setState(() => _selectedState = v);
            },
          ),
          const SizedBox(height: 14),

          // Season Dropdown
          _buildDropdownField(
            label: AppStrings.cultivationSeason,
            value: _selectedSeason,
            items: _seasons,
            onChanged: (v) {
              if (v != null) setState(() => _selectedSeason = v);
            },
          ),
          const SizedBox(height: 14),

          // Soil Dropdown
          _buildDropdownField(
            label: AppStrings.soilTexture,
            value: _selectedSoil,
            items: _soils,
            onChanged: (v) {
              if (v != null) setState(() => _selectedSoil = v);
            },
          ),
          const SizedBox(height: 14),

          // Water Dropdown
          _buildDropdownField(
            label: AppStrings.waterAvailability,
            value: _selectedWater,
            items: _waterLevels,
            onChanged: (v) {
              if (v != null) setState(() => _selectedWater = v);
            },
          ),
          const SizedBox(height: 20),

          // Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoadingRecs ? null : _fetchRecommendations,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Text(
                AppStrings.getRecommendationsBtn,
                style: const TextStyle(
                  fontFamily: 'BricolageGrotesque',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Hind',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.navyInput,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.navyBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: AppColors.navyCard,
              icon: const Icon(Icons.arrow_drop_down, color: AppColors.greenMint),
              style: const TextStyle(
                fontFamily: 'Hind',
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationsView(AdvisorResponseModel data) {
    final isHi = AppStrings.isHindi;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Advisor Summary Card (Lightbulb)
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.navyCard,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.greenMint.withValues(alpha: 0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('💡', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.advisorSummary,
                      style: const TextStyle(
                        fontFamily: 'BricolageGrotesque',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.greenMint,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isHi ? data.summaryHi : data.summary,
                      style: const TextStyle(
                        fontFamily: 'Hind',
                        fontSize: 14,
                        height: 1.45,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Crop Cards
        ...data.crops.map((crop) => _buildCropCard(crop)),

        const SizedBox(height: 24),

        // Recommended Best Practices for this Plot
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.navyCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.navyBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.bestPracticesTitle,
                style: const TextStyle(
                  fontFamily: 'BricolageGrotesque',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 14),
              ...(isHi ? data.bestPracticesHi : data.bestPractices).map(
                (bp) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🌱 ', style: TextStyle(fontSize: 14)),
                      Expanded(
                        child: Text(
                          bp,
                          style: const TextStyle(
                            fontFamily: 'Hind',
                            fontSize: 14,
                            height: 1.4,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCropCard(CropRecommendationModel crop) {
    final isHi = AppStrings.isHindi;
    final isTop = crop.isTopPick;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.navyCard,
        borderRadius: BorderRadius.circular(20),
        // Top card has prominent green border
        border: Border.all(
          color: isTop ? AppColors.greenPrimary : AppColors.navyBorder,
          width: isTop ? 2.0 : 1.0,
        ),
        boxShadow: isTop
            ? [
                BoxShadow(
                  color: AppColors.greenPrimary.withValues(alpha: 0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Crop Name & Suitability Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isHi ? crop.nameHi : crop.name,
                      style: const TextStyle(
                        fontFamily: 'BricolageGrotesque',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${isHi ? crop.categoryHi : crop.category} • ${crop.seasonWindow}',
                      style: const TextStyle(
                        fontFamily: 'Hind',
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.greenMint.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.greenMint.withValues(alpha: 0.3)),
                ),
                child: Text(
                  AppStrings.highSuitability,
                  style: const TextStyle(
                    fontFamily: 'Hind',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.greenMint,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Stats Row: Duration, Est. Yield, Est. Net Profit
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.navyBadge,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(AppStrings.duration, crop.duration),
                Container(width: 1, height: 32, color: AppColors.navyBorder),
                _buildStatItem(AppStrings.estYield, crop.estYield),
                Container(width: 1, height: 32, color: AppColors.navyBorder),
                _buildStatItem(
                  AppStrings.estProfit,
                  crop.estProfit,
                  isGreen: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Key Agricultural Advice
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontFamily: 'Hind',
                fontSize: 13.5,
                height: 1.45,
                color: AppColors.textSecondary,
              ),
              children: [
                TextSpan(
                  text: '${AppStrings.keyAdviceLabel} ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: isHi ? crop.keyAdviceHi : crop.keyAdvice,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, {bool isGreen = false}) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Hind',
            fontSize: 11,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'BricolageGrotesque',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isGreen ? AppColors.greenMint : Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAskAdvisorCard() {
    final isHi = AppStrings.isHindi;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.navyCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.navyBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('💬', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                AppStrings.askAdvisorTitle,
                style: const TextStyle(
                  fontFamily: 'BricolageGrotesque',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Suggestion Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _sampleQuestions.map((q) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(
                      q,
                      style: const TextStyle(
                        fontFamily: 'Hind',
                        fontSize: 12,
                        color: AppColors.greenMint,
                      ),
                    ),
                    backgroundColor: AppColors.navyBadge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: AppColors.navyBorder),
                    ),
                    onPressed: () => _askQuestion(q),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),

          // Text Field
          TextField(
            controller: _questionController,
            style: const TextStyle(color: Colors.white, fontFamily: 'Hind'),
            decoration: InputDecoration(
              hintText: AppStrings.askAdvisorHint,
              hintStyle: const TextStyle(
                color: AppColors.textMuted,
                fontFamily: 'Hind',
                fontSize: 14,
              ),
              filled: true,
              fillColor: AppColors.navyInput,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.navyBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.navyBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.greenMint),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            onSubmitted: (_) => _askQuestion(),
          ),
          const SizedBox(height: 12),

          // Ask Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoadingQA ? null : () => _askQuestion(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: _isLoadingQA
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      AppStrings.askQuestionBtn,
                      style: const TextStyle(
                        fontFamily: 'BricolageGrotesque',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),

          if (_qaError != null) ...[
            const SizedBox(height: 16),
            _buildErrorBox(_qaError!, () => _askQuestion()),
          ],

          // Answer Card
          if (_qaResponse != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.navyBadge,
                borderRadius: BorderRadius.circular(16),
                border: const Border(
                  left: BorderSide(color: AppColors.greenMint, width: 4),
                  top: BorderSide(color: AppColors.navyBorder),
                  right: BorderSide(color: AppColors.navyBorder),
                  bottom: BorderSide(color: AppColors.navyBorder),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _qaResponse!.title,
                        style: const TextStyle(
                          fontFamily: 'BricolageGrotesque',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.greenMint,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.greenPrimary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _qaResponse!.verifiedLabel,
                          style: const TextStyle(
                            fontFamily: 'Hind',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.greenMint,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isHi ? _qaResponse!.answerHi : _qaResponse!.answer,
                    style: const TextStyle(
                      fontFamily: 'Hind',
                      fontSize: 14,
                      height: 1.45,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: _qaResponse!.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.navyInput,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.navyBorder),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            fontFamily: 'Hind',
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorBox(String message, VoidCallback onRetry) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D1616),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.errorRed.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.cloud_off, color: AppColors.errorRed, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontFamily: 'Hind',
                    fontSize: 13,
                    color: Color(0xFFFECACA),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 16, color: Colors.white),
              label: Text(
                AppStrings.retryBtn,
                style: const TextStyle(
                  fontFamily: 'BricolageGrotesque',
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.greenPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
