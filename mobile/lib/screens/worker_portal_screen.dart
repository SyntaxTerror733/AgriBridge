import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';
import '../models/worker_model.dart';
import '../services/api_service.dart';

class WorkerPortalScreen extends StatefulWidget {
  const WorkerPortalScreen({super.key});

  @override
  State<WorkerPortalScreen> createState() => _WorkerPortalScreenState();
}

class _WorkerPortalScreenState extends State<WorkerPortalScreen> {
  int _currentStep = 1;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();

  final List<String> _selectedSkills = [];

  final List<Map<String, String>> _availableSkills = [
    {'name': 'Ploughing', 'emoji': '🚜'},
    {'name': 'Sowing', 'emoji': '🌱'},
    {'name': 'Irrigation', 'emoji': '💧'},
    {'name': 'Harvesting', 'emoji': '🌾'},
    {'name': 'Tractor driving', 'emoji': '🚛'},
    {'name': 'Spraying', 'emoji': '🧴'},
  ];

  bool _isSubmitting = false;
  String? _step1Error;
  String? _step2Error;
  WorkerModel? _registeredWorker;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _villageController.dispose();
    super.dispose();
  }

  void _validateStep1() {
    setState(() => _step1Error = null);

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final village = _villageController.text.trim();

    if (name.length < 2 || village.length < 2) {
      setState(() => _step1Error = AppStrings.fillRequiredFields);
      return;
    }

    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 10) {
      setState(() => _step1Error = AppStrings.enterValidPhone);
      return;
    }

    setState(() => _currentStep = 2);
  }

  Future<void> _submitWorker() async {
    if (_selectedSkills.isEmpty) {
      setState(() => _step2Error = AppStrings.selectAtLeastOneSkill);
      return;
    }

    setState(() {
      _isSubmitting = true;
      _step2Error = null;
    });

    try {
      final payload = {
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'village': _villageController.text.trim(),
        'skills': _selectedSkills,
      };

      final result = await ApiService.registerWorker(payload);
      setState(() {
        _registeredWorker = result;
        _currentStep = 3;
        _isSubmitting = false;
      });
    } catch (e) {
      setState(() {
        _step2Error = e.toString();
        _isSubmitting = false;
      });
    }
  }

  void _toggleSkill(String skill) {
    setState(() {
      if (_selectedSkills.contains(skill)) {
        _selectedSkills.remove(skill);
      } else {
        _selectedSkills.add(skill);
      }
      _step2Error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.workerBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header Bar with "Worker portal" pill & Close X
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.workerAmber,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('👷 ', style: TextStyle(fontSize: 14)),
                        Text(
                          AppStrings.workerPortalPill,
                          style: const TextStyle(
                            fontFamily: 'Hind',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFF261D12),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.close, color: Colors.white70, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Amber Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _currentStep == 1
                      ? 0.33
                      : _currentStep == 2
                          ? 0.66
                          : 1.0,
                  backgroundColor: const Color(0xFF2E2215),
                  color: AppColors.workerAmber,
                  minHeight: 6,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Step Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: _currentStep == 1
                    ? _buildStep1()
                    : _currentStep == 2
                        ? _buildStep2()
                        : _buildStep3(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Step 1: Tell us about you (Screenshot 4)
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          AppStrings.step1Title,
          style: const TextStyle(
            fontFamily: 'BricolageGrotesque',
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppColors.workerCreamText,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 24),

        if (_step1Error != null) ...[
          _buildErrorBox(_step1Error!),
          const SizedBox(height: 16),
        ],

        // Your Name
        _buildWorkerInput(
          controller: _nameController,
          label: AppStrings.yourName,
          placeholder: AppStrings.workerNamePlaceholder,
        ),
        const SizedBox(height: 20),

        // Mobile Number
        _buildWorkerInput(
          controller: _phoneController,
          label: AppStrings.mobileNumber,
          placeholder: AppStrings.mobilePlaceholder,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 20),

        // Village or Tehsil
        _buildWorkerInput(
          controller: _villageController,
          label: AppStrings.villageOrTown,
          placeholder: AppStrings.villagePlaceholder,
        ),
        const SizedBox(height: 36),

        // Next Button (Amber)
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _validateStep1,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.workerAmber,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Text(
              AppStrings.nextBtn,
              style: const TextStyle(
                fontFamily: 'BricolageGrotesque',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Step 2: 2x3 Multi-select Skill Tiles (Screenshot 3)
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          AppStrings.step2Title,
          style: const TextStyle(
            fontFamily: 'BricolageGrotesque',
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppColors.workerCreamText,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 24),

        if (_step2Error != null) ...[
          _buildErrorBox(_step2Error!),
          const SizedBox(height: 16),
        ],

        // 2x3 Grid of Tiles
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _availableSkills.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.25,
          ),
          itemBuilder: (context, index) {
            final skill = _availableSkills[index];
            final skillName = skill['name']!;
            final isSelected = _selectedSkills.contains(skillName);

            return InkWell(
              onTap: () => _toggleSkill(skillName),
              borderRadius: BorderRadius.circular(18),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF382914) : const Color(0xFF1F170E),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? AppColors.workerAmber : const Color(0xFF382916),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.workerAmber.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      skill['emoji']!,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _localizeSkill(skillName),
                      style: TextStyle(
                        fontFamily: 'BricolageGrotesque',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? AppColors.workerAmber : AppColors.workerCreamText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 32),

        // Row of Buttons: Back & Register as a worker
        Row(
          children: [
            Expanded(
              flex: 2,
              child: OutlinedButton(
                onPressed: () => setState(() => _currentStep = 1),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.workerCreamText,
                  side: const BorderSide(color: Color(0xFF382916), width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  AppStrings.backBtn,
                  style: const TextStyle(
                    fontFamily: 'BricolageGrotesque',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 4,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitWorker,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.workerAmber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black87,
                        ),
                      )
                    : Text(
                        AppStrings.registerAsWorkerBtn,
                        style: const TextStyle(
                          fontFamily: 'BricolageGrotesque',
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Step 3: You're registered (Screenshot 2)
  Widget _buildStep3() {
    final worker = _registeredWorker;
    final skillsDisplay = worker?.skills.join(', ') ?? _selectedSkills.join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          AppStrings.youAreRegistered,
          style: const TextStyle(
            fontFamily: 'BricolageGrotesque',
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: AppColors.workerCreamText,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          AppStrings.workerCoordinatorCall,
          style: const TextStyle(
            fontFamily: 'Hind',
            fontSize: 15,
            height: 1.45,
            color: Color(0xFFD4C8B8),
          ),
        ),
        const SizedBox(height: 32),

        // Reference Chip: WORK-XXXXX (Screenshot 2)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1F170E),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF3D2E1C), width: 1.5),
          ),
          child: Text(
            worker?.referenceNo ?? 'WORK-XXXXX',
            style: const TextStyle(
              fontFamily: 'BricolageGrotesque',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.workerAmber,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Line: name • village (skills) (Screenshot 2)
        Text(
          '${_nameController.text.trim()} • ${_villageController.text.trim()} ($skillsDisplay)',
          style: const TextStyle(
            fontFamily: 'Hind',
            fontSize: 14.5,
            color: Color(0xFFE2D6C6),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 44),

        // Close Button (Amber full-width)
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.workerAmber,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Text(
              AppStrings.closeBtn,
              style: const TextStyle(
                fontFamily: 'BricolageGrotesque',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkerInput({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    TextInputType keyboardType = TextInputType.text,
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
            color: Color(0xFFD4C8B8),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white, fontFamily: 'Hind'),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: Color(0xFF6B5843), fontSize: 13),
            filled: true,
            fillColor: const Color(0xFF1F170E),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF382916)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF382916)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.workerAmber),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorBox(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF381515),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.errorRed.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.errorRed, size: 18),
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
    );
  }

  String _localizeSkill(String skill) {
    switch (skill) {
      case 'Ploughing':
        return AppStrings.skillPloughing;
      case 'Sowing':
        return AppStrings.skillSowing;
      case 'Irrigation':
        return AppStrings.skillIrrigation;
      case 'Harvesting':
        return AppStrings.skillHarvesting;
      case 'Tractor driving':
        return AppStrings.skillTractorDriving;
      case 'Spraying':
        return AppStrings.skillSpraying;
      default:
        return skill;
    }
  }
}
