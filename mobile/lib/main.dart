import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants/colors.dart';
import 'services/locale_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleService.init();

  // Dark navigation and status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.navyBackground,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const AgribridgeApp());
}

class AgribridgeApp extends StatelessWidget {
  const AgribridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agribridge (खेतसेतु)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.navyBackground,
        primaryColor: AppColors.greenPrimary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.greenPrimary,
          secondary: AppColors.greenMint,
          surface: AppColors.navyCard,
        ),
        fontFamily: 'Hind',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'BricolageGrotesque', fontWeight: FontWeight.w800),
          displayMedium: TextStyle(fontFamily: 'BricolageGrotesque', fontWeight: FontWeight.w800),
          displaySmall: TextStyle(fontFamily: 'BricolageGrotesque', fontWeight: FontWeight.w700),
          headlineLarge: TextStyle(fontFamily: 'BricolageGrotesque', fontWeight: FontWeight.w700),
          headlineMedium: TextStyle(fontFamily: 'BricolageGrotesque', fontWeight: FontWeight.w700),
          headlineSmall: TextStyle(fontFamily: 'BricolageGrotesque', fontWeight: FontWeight.w700),
          titleLarge: TextStyle(fontFamily: 'BricolageGrotesque', fontWeight: FontWeight.w700),
          bodyLarge: TextStyle(fontFamily: 'Hind', color: AppColors.textPrimary),
          bodyMedium: TextStyle(fontFamily: 'Hind', color: AppColors.textSecondary),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
