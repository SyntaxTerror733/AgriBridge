import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';
import '../models/land_model.dart';
import '../models/worker_model.dart';
import '../services/api_service.dart';

class TrackStatusScreen extends StatefulWidget {
  const TrackStatusScreen({super.key});

  @override
  State<TrackStatusScreen> createState() => _TrackStatusScreenState();
}

class _TrackStatusScreenState extends State<TrackStatusScreen> {
  final TextEditingController _queryController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  LandModel? _landResult;
  WorkerModel? _workerResult;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _queryController.text.trim();
    if (query.isEmpty) {
      setState(() => _errorMessage = AppStrings.fillRequiredFields);
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _landResult = null;
      _workerResult = null;
    });

    try {
      if (query.toUpperCase().startsWith('WORK-')) {
        // Query worker endpoint
        final res = await ApiService.getWorkerStatus(query);
        setState(() {
          _workerResult = res;
          _isLoading = false;
        });
      } else if (query.toUpperCase().startsWith('LAND-')) {
        // Query land endpoint
        final res = await ApiService.getLandStatus(query);
        setState(() {
          _landResult = res;
          _isLoading = false;
        });
      } else {
        // Query is a phone number - try land first, then worker
        try {
          final landRes = await ApiService.getLandStatus(query);
          setState(() {
            _landResult = landRes;
            _isLoading = false;
          });
        } catch (_) {
          final workerRes = await ApiService.getWorkerStatus(query);
          setState(() {
            _workerResult = workerRes;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navyBackground,
      appBar: AppBar(
        backgroundColor: AppColors.navyBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppStrings.menuTrackStatus,
          style: const TextStyle(
            fontFamily: 'BricolageGrotesque',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.trackStatusTitle,
                style: const TextStyle(
                  fontFamily: 'BricolageGrotesque',
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.trackStatusSubtitle,
                style: const TextStyle(
                  fontFamily: 'Hind',
                  fontSize: 14,
                  height: 1.4,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Search Input Row
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _queryController,
                      style: const TextStyle(color: Colors.white, fontFamily: 'Hind'),
                      decoration: InputDecoration(
                        hintText: AppStrings.trackInputPlaceholder,
                        hintStyle: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
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
                      onSubmitted: (_) => _search(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _search,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.search, size: 22),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Error State
              if (_errorMessage != null) ...[
                _buildErrorBox(_errorMessage!),
                const SizedBox(height: 20),
              ],

              // Land Result
              if (_landResult != null) _buildLandCard(_landResult!),

              // Worker Result
              if (_workerResult != null) _buildWorkerCard(_workerResult!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLandCard(LandModel land) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.navyBadge,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.greenMint.withValues(alpha: 0.3)),
                ),
                child: Text(
                  land.referenceNo,
                  style: const TextStyle(
                    fontFamily: 'BricolageGrotesque',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.greenMint,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.greenPrimary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  land.status,
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
          const SizedBox(height: 14),
          Text(
            land.name,
            style: const TextStyle(
              fontFamily: 'BricolageGrotesque',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${land.village}, ${land.district}, ${land.state} • ${land.size} ${land.unit}',
            style: const TextStyle(
              fontFamily: 'Hind',
              fontSize: 13.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColors.navyBorder),
          const SizedBox(height: 16),

          // Stepper for Land
          _buildVerticalStepper(land.status),
        ],
      ),
    );
  }

  Widget _buildWorkerCard(WorkerModel worker) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1F170E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF382916)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF261D12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.workerAmber.withValues(alpha: 0.4)),
                ),
                child: Text(
                  worker.referenceNo,
                  style: const TextStyle(
                    fontFamily: 'BricolageGrotesque',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.workerAmber,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.workerAmber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  worker.status,
                  style: const TextStyle(
                    fontFamily: 'Hind',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.workerAmber,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            worker.name,
            style: const TextStyle(
              fontFamily: 'BricolageGrotesque',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.workerCreamText,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${worker.village} • ${worker.phone}',
            style: const TextStyle(
              fontFamily: 'Hind',
              fontSize: 13.5,
              color: Color(0xFFD4C8B8),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFF382916)),
          const SizedBox(height: 14),

          Text(
            'Registered Skills:',
            style: const TextStyle(
              fontFamily: 'BricolageGrotesque',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.workerAmber,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: worker.skills.map((s) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF261D12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF382916)),
                ),
                child: Text(
                  s,
                  style: const TextStyle(
                    fontFamily: 'Hind',
                    fontSize: 12,
                    color: AppColors.workerCreamText,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalStepper(String currentStatus) {
    final steps = [
      AppStrings.step1Submitted,
      AppStrings.step2Docs,
      AppStrings.step3Visit,
      AppStrings.step4Plan,
    ];

    int activeIdx = 0;
    if (currentStatus == "Documents verified") activeIdx = 1;
    if (currentStatus == "Site visit scheduled") activeIdx = 2;
    if (currentStatus == "Plan and quote shared") activeIdx = 3;

    return Column(
      children: List.generate(steps.length, (idx) {
        final isCompleted = idx <= activeIdx;
        final isLast = idx == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: isCompleted ? AppColors.greenPrimary : AppColors.navyBadge,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted ? AppColors.greenMint : AppColors.navyBorder,
                    ),
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : Text(
                            '${idx + 1}',
                            style: const TextStyle(
                              fontFamily: 'Hind',
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 30,
                    color: idx < activeIdx ? AppColors.greenPrimary : AppColors.navyBorder,
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  steps[idx],
                  style: TextStyle(
                    fontFamily: 'BricolageGrotesque',
                    fontSize: 14,
                    fontWeight: isCompleted ? FontWeight.w700 : FontWeight.w500,
                    color: isCompleted ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildErrorBox(String message) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2D1616),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.errorRed.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_off, color: AppColors.errorRed, size: 20),
          const SizedBox(width: 10),
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
    );
  }
}
