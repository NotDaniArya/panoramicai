import 'package:flutter_dotenv/flutter_dotenv.dart';

class TTexts {
  static final projectUrl = dotenv.get('PROJECT_URL');
  static final anonKey = dotenv.get('ANON_KEY');
}
