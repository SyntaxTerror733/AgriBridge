import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onRegisterLand;
  final VoidCallback onWorkerPortal;

  const HeroSection({
    super.key,
    required this.onRegisterLand,
    required this.onWorkerPortal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Farm from anywhere" Pill Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.greenPrimary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.greenMint.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.greenMint,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  AppStrings.farmFromAnywhere,
                  style: const TextStyle(
                    fontFamily: 'Hind',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.greenMint,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Main Headline
          Text(
            AppStrings.heroHeadline,
            style: const TextStyle(
              fontFamily: 'BricolageGrotesque',
              fontSize: 32,
              fontWeight: FontWeight.w800,
              height: 1.15,
              color: Colors.white,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 14),

          // Subtext
          Text(
            AppStrings.heroSubtext,
            style: const TextStyle(
              fontFamily: 'Hind',
              fontSize: 15,
              height: 1.5,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 24),

          // Buttons Row
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // "Register your land" Green Button with Soft Glow
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x661A8A5C),
                      blurRadius: 18,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: onRegisterLand,
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
                    AppStrings.registerYourLandBtn,
                    style: const TextStyle(
                      fontFamily: 'BricolageGrotesque',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // "I'm a farm worker" Outline Button
              OutlinedButton(
                onPressed: onWorkerPortal,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.workerAmber,
                  side: const BorderSide(color: AppColors.workerAmber, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('👷 ', style: TextStyle(fontSize: 16)),
                    Text(
                      AppStrings.imAFarmWorkerBtn,
                      style: const TextStyle(
                        fontFamily: 'BricolageGrotesque',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.workerAmber,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Three Value Cards
          _buildValueCard(
            title: AppStrings.heroCard1Title,
            desc: AppStrings.heroCard1Desc,
            icon: Icons.account_balance_wallet_outlined,
          ),
          const SizedBox(height: 12),
          _buildValueCard(
            title: AppStrings.heroCard2Title,
            desc: AppStrings.heroCard2Desc,
            icon: Icons.visibility_outlined,
          ),
          const SizedBox(height: 12),
          _buildValueCard(
            title: AppStrings.heroCard3Title,
            desc: AppStrings.heroCard3Desc,
            icon: Icons.groups_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildValueCard({
    required String title,
    required String desc,
    required IconData icon,
  }) {
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.navyBadge,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.greenMint, size: 22),
          ),
          const SizedBox(width: 14),
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
