import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';
import '../services/locale_service.dart';

class TopNavBar extends StatelessWidget {
  final VoidCallback onRegisterLand;
  final VoidCallback onOpenMenu;
  final VoidCallback onTrackStatus;

  const TopNavBar({
    super.key,
    required this.onRegisterLand,
    required this.onOpenMenu,
    required this.onTrackStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.navyBackground.withValues(alpha: 0.95),
        border: const Border(
          bottom: BorderSide(color: AppColors.navyBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Logo & Name
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.greenPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.remove,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  AppStrings.appName,
                  style: const TextStyle(
                    fontFamily: 'BricolageGrotesque',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),

          // Language Toggle Pill
          ValueListenableBuilder<bool>(
            valueListenable: LocaleService.isHindiNotifier,
            builder: (context, isHindi, _) {
              return Container(
                height: 32,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: AppColors.navyCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.navyBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (isHindi) LocaleService.setLanguage(false);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: !isHindi ? AppColors.greenPrimary : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            'EN',
                            style: TextStyle(
                              fontFamily: 'Hind',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: !isHindi ? Colors.white : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (!isHindi) LocaleService.setLanguage(true);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: isHindi ? AppColors.greenPrimary : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            'हिन्दी',
                            style: TextStyle(
                              fontFamily: 'Hind',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isHindi ? Colors.white : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 8),

          // Menu Hamburger Button
          IconButton(
            onPressed: onOpenMenu,
            icon: const Icon(
              Icons.menu_rounded,
              color: Colors.white,
              size: 26,
            ),
            tooltip: 'Menu',
          ),
        ],
      ),
    );
  }
}
