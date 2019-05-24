import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './DefaultLanguage.dart';

class Language{
  //Define all UI text variables that your wish to translate
  //between the delimiters below.
  //&& <- START DELIMITER
  final String homeScreenTitle;
  final String chatScreenTitle;
  //&& <- END DELIMITER  
  Language({
    @required this.homeScreenTitle,
    @required this.chatScreenTitle
  });

  String defaultLanguage = SupportedLanguages.en_US.toString();

  FutureBuilder<String> getTranslation(BuildContext context, LanguageClassAttributes attribute){
    return FutureBuilder<String>(
      future: _getLanguageStringFromFile(context, attribute) ,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('');
          case ConnectionState.active:
            return Text('');
          case ConnectionState.waiting:
            return Text('');
          case ConnectionState.done:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            return Text('${snapshot.data}');
        }
        return null; // unreachable
      },
    );     
  }
}

//For each UI text variable defined above enter its variable 
//name in the enum below
enum LanguageClassAttributes{
  homeScreenTitle, 
  chatScreenTitle
}

Locale _getLocality(BuildContext context){
  return Localizations.localeOf(context);
}

String _getSystemLanguage(BuildContext context){
  return Localizations.localeOf(context).toString();
}

Future<String> _getLanguageFile(String languageFileName) async {
  try {
    String contents = await rootBundle
        .loadString('assets/languages/$languageFileName.json');
    return contents;
  } catch (err) {
    return null;
  }
}

Language _generateLanguageClass(Map<String, String> languageFile){
  return new Language(
    homeScreenTitle: languageFile[LanguageClassAttributes.homeScreenTitle.toString()],
    chatScreenTitle: languageFile[LanguageClassAttributes.chatScreenTitle.toString()]
  );
}

Future<Language> _generateFullLanguageClass(BuildContext context) async{
  try{
    String systemLanguage = _getSystemLanguage(context);
    Map<String, String> languageFile = json.decode(await _getLanguageFile(systemLanguage));
    return _generateLanguageClass(languageFile);
  }
  catch(err){
    return defaultLanguage;    
  }
}

Future<String> _getLanguageStringFromFile(BuildContext context, LanguageClassAttributes attribute) async{
  try{
    String systemLanguage = _getSystemLanguage(context);
    return json.decode(await _getLanguageFile(systemLanguage))[attribute];
  }
  catch(err){
    print(err);
    return null;    
  }
}

