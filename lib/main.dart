import 'package:flutibre_pro/utils/theme_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/homepage.dart';
import 'pages/settingspage.dart';

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => ThemeSettings())],
      child: Consumer<ThemeSettings>(
          builder: ((context, value, child) => MaterialApp(
                theme: value.darkTheme ? darkTheme3 : baseTheme,
                initialRoute: '/',
                routes: {
                  '/': (context) => HomePage(),
                  '/settings': (context) => const SettingsPage(),
                },
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
              ))),
    );
  }
}

ThemeData darkTheme = ThemeData.dark();
ThemeData darkTheme2 = ThemeData(brightness: Brightness.dark);
ThemeData darkTheme3 = ThemeData(
  textTheme: textTheme().copyWith(
    headline2: const TextStyle(
        fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.grey,
  ),
  scaffoldBackgroundColor: Colors.black87,
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
      .copyWith(secondary: Colors.blueAccent, brightness: Brightness.dark),
);
ThemeData baseTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.cyan,
    foregroundColor: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.cyan[50],
  fontFamily: 'Roboto',
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.cyan, foregroundColor: Colors.white),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.cyan,
    ),
  ),
  textTheme: const TextTheme(
    //appbar text
    headline1: TextStyle(
        fontWeight: FontWeight.normal, color: Colors.white, fontSize: 20),
    //belső fejléc szövegek
    subtitle1: TextStyle(
        fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16),
    subtitle2: TextStyle(
        fontWeight: FontWeight.normal, color: Colors.black, fontSize: 15),
    //gombszövegek
    headline3: TextStyle(
        fontWeight: FontWeight.normal, color: Colors.white, fontSize: 15),
    //nagyobb lista szövegek
    bodyText1: TextStyle(
        fontWeight: FontWeight.normal, color: Colors.black, fontSize: 15),
    //kisebb lista szövegek
    bodyText2: TextStyle(
        fontWeight: FontWeight.normal, color: Colors.black, fontSize: 12),
    //vastag belső szövegek
    headline2: TextStyle(
        fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
  ),
);
ThemeData lightTheme = ThemeData.light();
ThemeData lightTheme2 = ThemeData(
    textTheme: textTheme().copyWith(
      headline2: const TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
    ),
    scaffoldBackgroundColor: Colors.grey[100],
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.blue,
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
        secondary: Colors.lightBlueAccent, brightness: Brightness.light));
ThemeData lightTheme3 = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.green[100],
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
        .copyWith(secondary: Colors.lightBlueAccent));
ThemeData customTheme = ThemeData.light().copyWith(
  textTheme: textTheme().copyWith(
    headline2: const TextStyle(
        fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
  ),
);
TextTheme textTheme() {
  return const TextTheme(
    //appbar text
    headline1: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
    //vastag belső szövegek
    headline2: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
    //gombszövegek
    headline3: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
    //nagyobb lista szövegek
    //belső fejléc szövegek
    subtitle1: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
    subtitle2: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
    bodyText1: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
    //kisebb lista szövegek
    bodyText2: TextStyle(
        fontWeight: FontWeight.normal, color: Colors.black, fontSize: 12),
  );
}
