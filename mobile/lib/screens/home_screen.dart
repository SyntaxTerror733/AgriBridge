import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';
import '../services/locale_service.dart';
import '../widgets/top_nav_bar.dart';
import '../widgets/hero_section.dart';
import '../widgets/process_section.dart';
import '../widgets/services_section.dart';
import '../widgets/crop_advisor_section.dart';
import '../widgets/worker_section.dart';
import '../widgets/footer_section.dart';
import 'land_register_screen.dart';
import 'worker_portal_screen.dart';
import 'track_status_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey _processKey = GlobalKey();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _advisorKey = GlobalKey();
  final GlobalKey _workerKey = GlobalKey();

  void _scrollToKey(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _openLandRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LandRegisterScreen()),
    );
  }

  void _openWorkerPortal() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const WorkerPortalScreen()),
    );
  }

  void _openTrackStatus() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const TrackStatusScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: LocaleService.isHindiNotifier,
      builder: (context, isHindi, _) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.navyBackground,
          // Drawer for Menu items
          endDrawer: _buildDrawer(),
          body: SafeArea(
            child: Column(
              children: [
                // Top App Bar
                TopNavBar(
                  onRegisterLand: _openLandRegister,
                  onOpenMenu: () => _scaffoldKey.currentState?.openEndDrawer(),
                  onTrackStatus: _openTrackStatus,
                ),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 1. Hero Section
                        HeroSection(
                          onRegisterLand: _openLandRegister,
                          onWorkerPortal: _openWorkerPortal,
                        ),

                        // 2. "From your first call to your first harvest"
                        Container(
                          key: _processKey,
                          child: const ProcessSection(),
                        ),

                        // 3. "Everything the land needs, handled"
                        Container(
                          key: _servicesKey,
                          child: const ServicesSection(),
                        ),

                        // 4. Smart Crop Advisor
                        Container(
                          key: _advisorKey,
                          child: const CropAdvisorSection(),
                        ),

                        // 5. Worker Section
                        Container(
                          key: _workerKey,
                          child: WorkerSection(
                            onOpenWorkerPortal: _openWorkerPortal,
                          ),
                        ),

                        // 6. Footer
                        const FooterSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.navyCard,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
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
                      child: Icon(Icons.remove, color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    AppStrings.appName,
                    style: const TextStyle(
                      fontFamily: 'BricolageGrotesque',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.navyBorder),
            _buildDrawerItem(
              icon: Icons.alt_route,
              title: AppStrings.menuHowItWorks,
              onTap: () {
                Navigator.of(context).pop();
                _scrollToKey(_processKey);
              },
            ),
            _buildDrawerItem(
              icon: Icons.agriculture_outlined,
              title: AppStrings.menuServices,
              onTap: () {
                Navigator.of(context).pop();
                _scrollToKey(_servicesKey);
              },
            ),
            _buildDrawerItem(
              icon: Icons.psychology_outlined,
              title: AppStrings.menuCropAdvisor,
              onTap: () {
                Navigator.of(context).pop();
                _scrollToKey(_advisorKey);
              },
            ),
            _buildDrawerItem(
              icon: Icons.engineering_outlined,
              title: AppStrings.menuForWorkers,
              onTap: () {
                Navigator.of(context).pop();
                _openWorkerPortal();
              },
            ),
            _buildDrawerItem(
              icon: Icons.manage_search_outlined,
              title: AppStrings.menuTrackStatus,
              onTap: () {
                Navigator.of(context).pop();
                _openTrackStatus();
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _openLandRegister();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    AppStrings.registerLandBtn,
                    style: const TextStyle(
                      fontFamily: 'BricolageGrotesque',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.greenMint, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Hind',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      onTap: onTap,
    );
  }
}
