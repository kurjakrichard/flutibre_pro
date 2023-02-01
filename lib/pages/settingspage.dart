import 'package:flutibre_pro/providers/locale_provider.dart';
import 'package:flutibre_pro/providers/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);
  final Map<String, String> _localeList = {'en': 'English', 'hu': 'magyar'};
  final Map<String, String> _reverseLocaleList = {
    'English': 'en',
    'magyar': 'hu'
  };

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, locale, child) => Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.settingspage)),
        body: Wrap(alignment: WrapAlignment.center, children: [
          Card(
            child: ListTile(
              title: Text(AppLocalizations.of(context)!.theme),
            ),
          ),
          Consumer<ThemeProvider>(
            builder: (context, value, child) => SwitchListTile(
              title: Text(AppLocalizations.of(context)!.darktheme),
              value: value.darkTheme,
              onChanged: (newValue) {
                value.toggleTheme();
                //Navigator.pop(context);
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text(AppLocalizations.of(context)!.language),
            ),
          ),
          dropDownButton()
        ]),
      ),
    );
  }

  Widget dropDownButton() {
    return Consumer<LocaleProvider>(
      builder: (context, value, child) => DropdownButton<String>(
          icon: const Icon(Icons.arrow_downward),
          isExpanded: true,
          underline: Container(),
          value: _localeList[value.currentLocale.languageCode],
          items: _localeList.values.map((String value) {
            return DropdownMenuItem(
                value: value, child: Center(child: Text(value)));
          }).toList(),
          onChanged: (newValueSelected) {
            value.setLocale(Locale(_reverseLocaleList[newValueSelected]!));

            //Navigator.pop(context);
          }),
    );
  }
}
