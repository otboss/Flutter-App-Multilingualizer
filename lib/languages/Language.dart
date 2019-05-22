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
}

//For each UI text variable defined above enter its variable 
//name in the enum below
enum LanguageClassAttributes{
  homeScreenTitle, 
  chatScreenTitle
}

Locale getLocality(BuildContext context){
  return Localizations.localeOf(context);
}

String getSystemLanguage(BuildContext context){
  return Localizations.localeOf(context).toString();
}

Future<String> getLanguageFile(String languageFileName) async {
  try {
    String contents = await rootBundle
        .loadString('assets/languages/$languageFileName.json');
    return contents;
  } catch (err) {
    return null;
  }
}

Language generateLanguageClass(Map<String, String> languageFile){
  return new Language(
    homeScreenTitle: languageFile[LanguageClassAttributes.homeScreenTitle.toString()],
    chatScreenTitle: languageFile[LanguageClassAttributes.chatScreenTitle.toString()]
  );
}

Future<Language> generateFullLanguageClass(BuildContext context) async{
  try{
    String systemLanguage = getSystemLanguage(context);
    Map<String, String> languageFile = json.decode(await getLanguageFile(systemLanguage));
    return generateLanguageClass(languageFile);
  }
  catch(err){
    return defaultLanguage;    
  }
}

enum SupportedLanguages{
  en_US,
  zh_CN
}