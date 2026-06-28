import 'package:translator/translator.dart';

class TranslationService {
  TranslationService._internal();
  static final TranslationService instance = TranslationService._internal();

  final GoogleTranslator _translator = GoogleTranslator();
  final Map<String, String> _cache = {};

  Future<String> translate(String text, {required String to}) async {
    if (text.isEmpty || to == 'en') return text;
    
    final cacheKey = '${to}_$text';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    try {
      final translation = await _translator.translate(text, to: to);
      _cache[cacheKey] = translation.text;
      return translation.text;
    } catch (_) {
      return text;
    }
  }
}
