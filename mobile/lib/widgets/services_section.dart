import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Headline
          Text(
            AppStrings.servicesTitle,
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
            AppStrings.servicesSubtitle,
            style: const TextStyle(
              fontFamily: 'Hind',
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),

          // 6 Service Cards
          _buildServiceCard('🌾', AppStrings.service1Title, AppStrings.service1Desc),
          const SizedBox(height: 12),
          _buildServiceCard('🌱', AppStrings.service2Title, AppStrings.service2Desc),
          const SizedBox(height: 12),
          _buildServiceCard('👷', AppStrings.service3Title, AppStrings.service3Desc),
          const SizedBox(height: 12),
          _buildServiceCard('💧', AppStrings.service4Title, AppStrings.service4Desc),
          const SizedBox(height: 12),
          _buildServiceCard('🚜', AppStrings.service5Title, AppStrings.service5Desc),
          const SizedBox(height: 12),
          _buildServiceCard('📱', AppStrings.service6Title, AppStrings.service6Desc),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String emoji, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.navyCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.navyBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.navyBadge,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'BricolageGrotesque',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    fontFamily: 'Hind',
                    fontSize: 14,
                    height: 1.4,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
