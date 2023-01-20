import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'view/homepage.dart';

late SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    const FlutibrePro(),
  );
}

class FlutibrePro extends StatelessWidget {
  const FlutibrePro({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
    );
  }
}
