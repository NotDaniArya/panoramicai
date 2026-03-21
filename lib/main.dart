import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:panoramicai/features/deteksi/bindings/deteksi_binding.dart';
import 'package:panoramicai/features/deteksi/presentations/screens/pilih_deteksi_screen.dart';
import 'package:panoramicai/features/onboarding/onboarding_screen.dart';
import 'package:panoramicai/features/profile/presentations/screens/profile_screen.dart';
import 'package:panoramicai/utils/constant/colors.dart';
import 'package:panoramicai/utils/constant/pages_routes.dart';
import 'package:panoramicai/utils/constant/texts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/home/presentations/screens/home_screen.dart';
import 'firebase_options.dart';

final theme = ThemeData().copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: TColors.primaryColor,
    brightness: Brightness.light,
  ),
  textTheme: GoogleFonts.poppinsTextTheme(),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initializeDateFormatting('id_ID', null);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Firebase initialization would go here when ready
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(url: TTexts.projectUrl, anonKey: TTexts.anonKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PanoramicAi',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const OnboardingScreen(),
      getPages: [
        GetPage(name: PagesRoutes.RUTE_HOME, page: () => const HomeScreen()),
        GetPage(
          name: PagesRoutes.RUTE_DETEKSI,
          page: () => const PilihDeteksiScreen(),
          binding: DeteksiBinding(),
        ),
        GetPage(
          name: PagesRoutes.RUTE_PROFILE,
          page: () => const ProfileScreen(),
        ),
      ],
    );
  }
}
