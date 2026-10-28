import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';

class ProcessSection extends StatelessWidget {
  const ProcessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            AppStrings.processTitle,
            style: const TextStyle(
              fontFamily: 'BricolageGrotesque',
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 20),

          // 4 Numbered Process Cards
          _buildStepCard(
            stepNumber: '1',
            title: AppStrings.process1Title,
            desc: AppStrings.process1Desc,
          ),
          const SizedBox(height: 14),
          _buildStepCard(
            stepNumber: '2',
            title: AppStrings.process2Title,
            desc: AppStrings.process2Desc,
          ),
          const SizedBox(height: 14),
          _buildStepCard(
            stepNumber: '3',
            title: AppStrings.process3Title,
            desc: AppStrings.process3Desc,
          ),
          const SizedBox(height: 14),
          _buildStepCard(
            stepNumber: '4',
            title: AppStrings.process4Title,
            desc: AppStrings.process4Desc,
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required String stepNumber,
    required String title,
    required String desc,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.navyCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.navyBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number Pill Badge
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.navyBadge,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                stepNumber,
                style: const TextStyle(
                  fontFamily: 'BricolageGrotesque',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.greenMint,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'BricolageGrotesque',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: const TextStyle(
              fontFamily: 'Hind',
              fontSize: 14,
              height: 1.45,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
