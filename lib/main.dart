import 'package:flutibre_pro/utils/settings_provider.dart';
import 'package:flutibre_pro/db_helper/database_helper.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;

  var flutibreMain = DatabaseHelper();
  flutibreMain.databasefactory();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const Flutibre(),
    ),
  );
}

class Flutibre extends StatelessWidget {
  const Flutibre({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Scaffold());
  }
}
