import 'package:flutter/material.dart';
import 'package:flutibre_pro/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'l10n/l10n.dart';
import 'pages/homepage.dart';
import 'pages/settingspage.dart';
import 'providers/booklist_provider.dart';
import 'providers/locale_provider.dart';
import 'utils/custom_scroll_behavior.dart';
import 'widgets/theme.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  prefs = await SharedPreferences.getInstance();
  bool isPath = prefs.containsKey("path");

  String path = '${prefs.getString("path")!}/metadata.db';

  bool isDb = await databaseFactory.databaseExists(path);

  print(isDb);

  runApp(
    FlutibrePro(isPath, isDb),
  );
}

class FlutibrePro extends StatelessWidget {
  const FlutibrePro(this.isPath, this.isDb, {Key? key}) : super(key: key);

  final bool isPath;
  final bool isDb;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
        ChangeNotifierProvider(create: (context) => BookListProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, locale, child) => Consumer<ThemeProvider>(
            builder: ((context, value, child) => MaterialApp(
                  localizationsDelegates: L10n.delegates,
                  locale: locale.currentLocale,
                  supportedLocales: L10n.locales,
                  theme: baseTheme,
                  darkTheme: darkTheme,
                  themeMode: value.darkTheme ? ThemeMode.dark : ThemeMode.light,
                  scrollBehavior: CustomScrollBehavior(),
                  initialRoute: '/',
                  routes: {
                    '/': (context) => isPath && isDb
                        ? const HomePage()
                        : const SettingsPage(),
                    '/settings': (context) => const SettingsPage(),
                  },
                  debugShowCheckedModeBanner: false,
                  title: 'Flutibre Pro',
                ))),
      ),
    );
  }
}
