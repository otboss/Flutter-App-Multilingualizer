import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './DefaultLanguage.dart';
///Update this method for each new Language class attribute
enum LanguageClassAttributes { homeScreenTitle, chatScreenTitle }

class Language {
  //Define all new UI Text to be translated here and update the toJSON 
  //method and LanguageClassAttributes enum
  final String homeScreenTitle;
  final String chatScreenTitle;

  ///Converts the Language class to a Map. Update this method for each 
  ///new Language class attribute
  Map toJSON() {
    return {
      "homeScreenTitle": this.homeScreenTitle,
      "chatScreenTitle": this.chatScreenTitle
    };
  }

  Language({
    @required this.homeScreenTitle, 
    @required this.chatScreenTitle
  });

  String defaultLanguage = SupportedLanguages.en.toString();

  ///Takes three mandatory parameters. The first two are the BuildContext
  /// and the desired Language class attribute. The Language parameter 
  /// is the result of the asynchronous creation of a Language object 
  /// (requires reading a json asset file). If the languageLibrary object 
  /// is null then it has not yet loaded. This parameter will enable the
  ///app to read from memory only after the Language object has been created 
  ///for better performance.
  FutureBuilder<String> getTranslation(BuildContext context, LanguageClassAttributes attribute, Language languageLib) {
    return FutureBuilder<String>(
      future: _getLanguageStringFromFile(context, attribute, languageLib),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('');
          case ConnectionState.active:
            return Text('');
          case ConnectionState.waiting:
            return Text('');
          case ConnectionState.done:
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            return Text('${snapshot.data}');
        }
      },
    );
  }
}

enum SupportedLanguages {
  al,
  bg,
  cs,
  de,
  el,
  en,
  es,
  fr,
  hi,
  hu,
  it,
  jp,
  ko,
  nl,
  pl,
  ru,
  sr,
  sv,
  ta,
  th,
  vi,
  zh_CN,
  zh_TW
}

Locale _getLocality(BuildContext context) {
  return Localizations.localeOf(context);
}

String _getSystemLanguage(BuildContext context) {
  if (Localizations.localeOf(context).toString() == "zh_CN" || Localizations.localeOf(context).toString() == "zh_TW")
    return Localizations.localeOf(context).toString();
  return Localizations.localeOf(context).toString().substring(0, 2);
}

Future<String> _getLanguageFile(String languageFileName) async {
  try {
    String contents = await rootBundle.loadString('assets/languages/$languageFileName.json');
    return contents;
  } catch (err) {
    return null;
  }
}

Language _generateLanguageClass(Map<String, String> languageFile) {
  return new Language(
      homeScreenTitle: languageFile[LanguageClassAttributes.homeScreenTitle.toString()],
      chatScreenTitle: languageFile[LanguageClassAttributes.chatScreenTitle.toString()]);
}

Future<Language> _generateFullLanguageClass(BuildContext context) async {
  try {
    String systemLanguage = _getSystemLanguage(context);
    Map<String, String> languageFile = json.decode(await _getLanguageFile(systemLanguage));
    return _generateLanguageClass(languageFile);
  } catch (err) {
    return defaultLanguage;
  }
}

Future<String> _getLanguageStringFromFile(BuildContext context, LanguageClassAttributes attribute, Language languageLibrary) async {
  try {
    if (languageLibrary != null) {
      if (languageLibrary.toJSON()[attribute] != null)
        return languageLibrary.toJSON()[attribute];
    }
    String systemLanguage = _getSystemLanguage(context);
    return json.decode(await _getLanguageFile(systemLanguage))[attribute.toString()];
  } catch (err) {
    print(err);
    return null;
  }
}
