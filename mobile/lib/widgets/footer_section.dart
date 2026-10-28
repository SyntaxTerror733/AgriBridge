import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: const BoxDecoration(
        color: Color(0xFF070D1A),
        border: Border(
          top: BorderSide(color: AppColors.navyBorder, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.greenPrimary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child: Icon(Icons.remove, color: Colors.white, size: 18),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                AppStrings.appName,
                style: const TextStyle(
                  fontFamily: 'BricolageGrotesque',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            AppStrings.footerTitle,
            style: const TextStyle(
              fontFamily: 'BricolageGrotesque',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.greenMint,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppStrings.footerDesc,
            style: const TextStyle(
              fontFamily: 'Hind',
              fontSize: 13.5,
              height: 1.45,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 28),
          const Divider(color: AppColors.navyBorder, height: 1),
          const SizedBox(height: 16),
          const Text(
            '© 2026 Agribridge (खेतसेतु). All rights reserved.',
            style: TextStyle(
              fontFamily: 'Hind',
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
