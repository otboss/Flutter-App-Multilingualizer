import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


bool _isLanguageLibraryTranslated = false;
String _defaultLanguage = _SupportedLanguages.en.toString();

///Place all references to String on the user interface here
enum LanguageLibraryAttributes{
  homeScreenTitle
}

///Place all mappings from the LanguageLibraryAttributes class here
final Map<String, String> _languageLibrary = {
  "homeScreenTitle": "hello world"
};

///Class responsible for actual translation of UI text
abstract class Translator{
  static String getLibraryValue(LanguageLibraryAttributes attribute){
    return _languageLibrary[attribute.toString()];
  }
  static void translateLanguageLibrary(BuildContext context) async{
    String systemLanguage = _getSystemLanguage(context);
    if(systemLanguage != _defaultLanguage.toString() && !_isLanguageLibraryTranslated){
        List<LanguageLibraryAttributes> languageLibraryKeys = LanguageLibraryAttributes.values;
        Map languageFileContents = json.decode(await _getLanguageFile(systemLanguage));
        for(var x = 0; x < languageLibraryKeys.length; x++){
          assert(languageFileContents[languageLibraryKeys[x].toString()] == null, "Required Attribute Missing from Language file");
          _languageLibrary[languageLibraryKeys[x].toString()] = languageFileContents[languageLibraryKeys[x].toString()];
        }
        _isLanguageLibraryTranslated = true;
        print("Translation Complete");
    }    
  }
}

enum _SupportedLanguages {
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
  zh_TW,
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
