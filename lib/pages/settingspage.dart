import 'package:flutibre_pro/utils/theme_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Wrap(alignment: WrapAlignment.center, children: [
        const Card(
          child: ListTile(
            title: Text('Theme'),
          ),
        ),
        Consumer<ThemeSettings>(
          builder: (context, value, child) => SwitchListTile(
            title: const Text('Dark Theme'),
            value: value.darkTheme,
            onChanged: (newValue) {
              value.toggleTheme();
              Navigator.pop(context);
            },
          ),
        )
      ]),
    );
  }
}
