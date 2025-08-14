import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:panoramicai/features/onboarding/onboarding_screen.dart';
import 'package:panoramicai/utils/constant/colors.dart';

final theme = ThemeData().copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: TColors.primaryColor,
    brightness: Brightness.light,
  ),
  textTheme: GoogleFonts.poppinsTextTheme(),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'PanoramicAi',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const OnboardingScreen(),
    );
  }
}
