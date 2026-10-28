import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';

class WorkerSection extends StatelessWidget {
  final VoidCallback onOpenWorkerPortal;

  const WorkerSection({
    super.key,
    required this.onOpenWorkerPortal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            AppStrings.workerSectionTitle,
            style: const TextStyle(
              fontFamily: 'BricolageGrotesque',
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 20),

          // Three Small Cards
          _buildWorkerCard(
            title: AppStrings.workerCard1Title,
            desc: AppStrings.workerCard1Desc,
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 12),
          _buildWorkerCard(
            title: AppStrings.workerCard2Title,
            desc: AppStrings.workerCard2Desc,
            icon: Icons.payments_outlined,
          ),
          const SizedBox(height: 12),
          _buildWorkerCard(
            title: AppStrings.workerCard3Title,
            desc: AppStrings.workerCard3Desc,
            icon: Icons.handyman_outlined,
          ),
          const SizedBox(height: 24),

          // Amber Gradient Card with 🚜🌾💧 and Register Button
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFB45309), // Warm amber dark
                  Color(0xFFD97706), // Bright amber
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD97706).withValues(alpha: 0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🚜 🌾 💧',
                  style: TextStyle(fontSize: 28),
                ),
                const SizedBox(height: 14),
                Text(
                  AppStrings.workerSectionTitle,
                  style: const TextStyle(
                    fontFamily: 'BricolageGrotesque',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppStrings.workerCoordinatorCall,
                  style: const TextStyle(
                    fontFamily: 'Hind',
                    fontSize: 14,
                    height: 1.4,
                    color: Color(0xFFFEF3C7),
                  ),
                ),
                const SizedBox(height: 20),

                // White "Register as a worker" Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onOpenWorkerPortal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF92400E),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      AppStrings.registerAsWorkerBtn,
                      style: const TextStyle(
                        fontFamily: 'BricolageGrotesque',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF92400E),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkerCard({
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
              color: AppColors.workerCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.workerCardBorder),
            ),
            child: Icon(icon, color: AppColors.workerAmber, size: 22),
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
