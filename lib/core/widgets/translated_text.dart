import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../localization/language_cubit.dart';
import '../localization/translation_service.dart';

class TranslatedText extends StatefulWidget {
  const TranslatedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  State<TranslatedText> createState() => _TranslatedTextState();
}

class _TranslatedTextState extends State<TranslatedText> {
  String _translatedText = '';

  @override
  void initState() {
    super.initState();
    _translatedText = widget.text;
    _translateIfNecessary();
  }

  @override
  void didUpdateWidget(covariant TranslatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _translatedText = widget.text;
      _translateIfNecessary();
    }
  }

  Future<void> _translateIfNecessary() async {
    final locale = context.read<LanguageCubit>().state;
    if (locale.languageCode == 'en' || widget.text.isEmpty) {
      if (mounted && _translatedText != widget.text) {
        setState(() => _translatedText = widget.text);
      }
      return;
    }

    final translated = await TranslationService.instance.translate(
      widget.text,
      to: locale.languageCode,
    );

    if (mounted) {
      setState(() {
        _translatedText = translated;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LanguageCubit, Locale>(
      listener: (context, locale) {
        _translateIfNecessary();
      },
      child: Text(
        _translatedText,
        style: widget.style,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        overflow: widget.overflow,
      ),
    );
  }
}
