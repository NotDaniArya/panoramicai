import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:panoramicai/features/onboarding/onboarding_screen.dart';
import 'package:panoramicai/utils/constant/colors.dart';
import 'package:panoramicai/utils/constant/texts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    );
  }
}
