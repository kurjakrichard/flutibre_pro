import 'package:flutibre_pro/providers/locale_provider.dart';
import 'package:flutibre_pro/providers/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Map<String, String> _localeList = {'en': 'English', 'hu': 'magyar'};

  final Map<String, String> _reverseLocaleList = {
    'English': 'en',
    'magyar': 'hu'
  };

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, locale, child) => Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.settingspage)),
        body: Wrap(alignment: WrapAlignment.center, children: [
          const Card(
            child: ListTile(
              title: Text('Theme'),
            ),
          ),
          Consumer<ThemeProvider>(
            builder: (context, value, child) => SwitchListTile(
              title: const Text('Dark Theme'),
              value: value.darkTheme,
              onChanged: (newValue) {
                value.toggleTheme();
                //Navigator.pop(context);
              },
            ),
          ),
          const Card(
            child: ListTile(
              title: Text('Language selector'),
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
          underline: Container(
            height: 1,
            color: Colors.white,
          ),
          value: _localeList[value.currentLocale.languageCode],
          items: _localeList.values.map((String value) {
            return DropdownMenuItem(value: value, child: Text(value));
          }).toList(),
          onChanged: (newValueSelected) {
            setState(() {
              value.setLocale(Locale(_reverseLocaleList[newValueSelected]!));
            });

            //Navigator.pop(context);
          }),
    );
  }
}
