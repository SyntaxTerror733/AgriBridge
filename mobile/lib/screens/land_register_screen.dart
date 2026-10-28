import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';
import '../models/land_model.dart';
import '../services/api_service.dart';

class LandRegisterScreen extends StatefulWidget {
  const LandRegisterScreen({super.key});

  @override
  State<LandRegisterScreen> createState() => _LandRegisterScreenState();
}

class _LandRegisterScreenState extends State<LandRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController(text: 'Uttar Pradesh');
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _selectedUnit = 'Acre';
  String _selectedWaterSource = 'Borewell';

  final List<String> _units = ['Acre', 'Bigha', 'Guntha', 'Hectare'];
  final List<String> _waterSources = ['Borewell', 'Canal', 'Rainfed', 'Tubewell', 'Pond/River'];

  bool _isSubmitting = false;
  String? _errorMessage;
  LandModel? _successLand;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    _villageController.dispose();
    _sizeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final payload = {
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'city': _cityController.text.trim(),
        'state': _stateController.text.trim(),
        'district': _districtController.text.trim(),
        'village': _villageController.text.trim(),
        'size': double.parse(_sizeController.text.trim()),
        'unit': _selectedUnit,
        'water_source': _selectedWaterSource,
        'notes': _notesController.text.trim(),
      };

      final result = await ApiService.registerLand(payload);
      setState(() {
        _successLand = result;
        _isSubmitting = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isSubmitting = false;
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
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppStrings.regLandTitle,
          style: const TextStyle(
            fontFamily: 'BricolageGrotesque',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: _successLand != null
            ? _buildSuccessView(_successLand!)
            : _buildFormView(),
      ),
    );
  }

  Widget _buildFormView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Subtitle
            Text(
              AppStrings.regLandTitle,
              style: const TextStyle(
                fontFamily: 'BricolageGrotesque',
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              AppStrings.regLandSubtitle,
              style: const TextStyle(
                fontFamily: 'Hind',
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            if (_errorMessage != null) ...[
              _buildErrorBanner(_errorMessage!),
              const SizedBox(height: 18),
            ],

            // Your Name
            _buildTextField(
              controller: _nameController,
              label: AppStrings.yourName,
              validator: (v) =>
                  v == null || v.trim().length < 2 ? AppStrings.fillRequiredFields : null,
            ),
            const SizedBox(height: 16),

            // Mobile Number
            _buildTextField(
              controller: _phoneController,
              label: AppStrings.mobileNumber,
              placeholder: AppStrings.mobilePlaceholder,
              keyboardType: TextInputType.phone,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return AppStrings.fillRequiredFields;
                final cleaned = v.replaceAll(RegExp(r'\D'), '');
                if (cleaned.length != 10) return AppStrings.enterValidPhone;
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Your City
            _buildTextField(
              controller: _cityController,
              label: AppStrings.yourCity,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? AppStrings.fillRequiredFields : null,
            ),
            const SizedBox(height: 16),

            // State (where land is)
            _buildTextField(
              controller: _stateController,
              label: AppStrings.stateWhereLandIs,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? AppStrings.fillRequiredFields : null,
            ),
            const SizedBox(height: 16),

            // District
            _buildTextField(
              controller: _districtController,
              label: AppStrings.district,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? AppStrings.fillRequiredFields : null,
            ),
            const SizedBox(height: 16),

            // Village or nearest town
            _buildTextField(
              controller: _villageController,
              label: AppStrings.villageOrTown,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? AppStrings.fillRequiredFields : null,
            ),
            const SizedBox(height: 16),

            // Land Size + Unit Dropdown
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildTextField(
                    controller: _sizeController,
                    label: AppStrings.landSize,
                    placeholder: "e.g. 5",
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return AppStrings.fillRequiredFields;
                      final n = double.tryParse(v.trim());
                      if (n == null || n <= 0) return "Invalid size";
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.unit,
                        style: const TextStyle(
                          fontFamily: 'Hind',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.navyInput,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.navyBorder),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedUnit,
                            isExpanded: true,
                            dropdownColor: AppColors.navyCard,
                            style: const TextStyle(
                              fontFamily: 'Hind',
                              fontSize: 14,
                              color: Colors.white,
                            ),
                            items: _units.map((u) {
                              return DropdownMenuItem<String>(
                                value: u,
                                child: Text(u),
                              );
                            }).toList(),
                            onChanged: (v) {
                              if (v != null) setState(() => _selectedUnit = v);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Water Source Dropdown
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.waterSource,
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
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.navyBorder),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedWaterSource,
                      isExpanded: true,
                      dropdownColor: AppColors.navyCard,
                      icon: const Icon(Icons.arrow_drop_down, color: AppColors.greenMint),
                      style: const TextStyle(
                        fontFamily: 'Hind',
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      items: _waterSources.map((ws) {
                        return DropdownMenuItem<String>(
                          value: ws,
                          child: Text(ws),
                        );
                      }).toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _selectedWaterSource = v);
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Optional Notes (Textarea as in Screenshot 5)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.optionalNotes,
                  style: const TextStyle(
                    fontFamily: 'Hind',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _notesController,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white, fontFamily: 'Hind'),
                  decoration: InputDecoration(
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
                    contentPadding: const EdgeInsets.all(14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Submit Button (Screenshot 5: Green button "Send my land details")
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greenPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        AppStrings.sendLandDetailsBtn,
                        style: const TextStyle(
                          fontFamily: 'BricolageGrotesque',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? placeholder,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
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
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white, fontFamily: 'Hind'),
          validator: validator,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorBanner(String error) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2D1616),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.errorRed.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.errorRed, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              error,
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

  Widget _buildSuccessView(LandModel land) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.greenPrimary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle, color: AppColors.greenMint, size: 36),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.requestReceived,
            style: const TextStyle(
              fontFamily: 'BricolageGrotesque',
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppStrings.keepRefNumber,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Hind',
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),

          // Reference Chip (LAND-XXXXX)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.navyBadge,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.greenMint.withValues(alpha: 0.4)),
            ),
            child: Text(
              land.referenceNo,
              style: const TextStyle(
                fontFamily: 'BricolageGrotesque',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.greenMint,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Summary Line: name • village, district (size unit)
          Text(
            '${land.name} • ${land.village}, ${land.district} (${land.size} ${land.unit})',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Hind',
              fontSize: 14,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),

          // 4-Step Vertical Stepper
          _buildVerticalStepper(land.status),
          const SizedBox(height: 36),

          // Green Close Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenPrimary,
                foregroundColor: Colors.white,
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
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
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

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.navyCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.navyBorder),
      ),
      child: Column(
        children: List.generate(steps.length, (idx) {
          final isCompleted = idx <= activeIdx;
          final isLast = idx == steps.length - 1;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isCompleted ? AppColors.greenPrimary : AppColors.navyBadge,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted ? AppColors.greenMint : AppColors.navyBorder,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                          : Text(
                              '${idx + 1}',
                              style: const TextStyle(
                                fontFamily: 'Hind',
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 36,
                      color: idx < activeIdx ? AppColors.greenPrimary : AppColors.navyBorder,
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    steps[idx],
                    style: TextStyle(
                      fontFamily: 'BricolageGrotesque',
                      fontSize: 15,
                      fontWeight: isCompleted ? FontWeight.w700 : FontWeight.w500,
                      color: isCompleted ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
