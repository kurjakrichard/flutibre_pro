import 'package:flutter/material.dart';
import 'package:flutibre_pro/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/l10n.dart';
import 'pages/homepage.dart';
import 'pages/settingspage.dart';
import 'providers/booklist_provider.dart';
import 'providers/locale_provider.dart';
import 'widgets/theme.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(
    const FlutibrePro(),
  );
}

class FlutibrePro extends StatelessWidget {
  const FlutibrePro({Key? key}) : super(key: key);

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
                  initialRoute: '/',
                  routes: {
                    '/': (context) => const HomePage(),
                    '/settings': (context) => SettingsPage(),
                  },
                  debugShowCheckedModeBanner: false,
                  title: 'Flutibre Pro',
                ))),
      ),
    );
  }
}
