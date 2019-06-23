<h1>Flutter App Multilingualizer</h1>

A handy tool for making your flutter app multilingual in a flash!
Requires Firefox Browser.

Simply merge with your flutter project, map your desired UI Text and run the Translator.js
file using Node.

Usage is easy too! Simply:

1. Add the key-value pair to the _languageLibrary Map in the Translator.dart file
2. Add the key to the LanguageLibraryAttributes enum so that the application can reference it
3. Run the Translator.js file to make the translations using Firefox + Google Translate. It may take a while.
4. Run the Translator.translateLanguageLibrary function from the Translator.dart file  upon app launch

Done! just add the Translator.getLibraryValue to fetch the translation
