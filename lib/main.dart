import 'package:flutibre/firstrun_wizard/wizard.dart';
import 'package:flutibre/screens/editscreen.dart';
import 'package:flutibre/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/booklist_provider.dart';
import 'screens/homescreen.dart';
import 'screens/readscreen.dart';
// ignore: unused_import
import 'screens/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const Flutibre());
}

class Flutibre extends StatelessWidget {
  const Flutibre({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => BooksListProvider()..selectAll())
      ],
      builder: (context, child) => MaterialApp(
        theme: baseTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          //'/': (context) => FirstRunWizard.provider(),
          '/homescreen': (context) => const HomeScreen(),
          '/addpage': (context) => const EditScreen(
                title: 'Add Item',
                buttonText: 'Insert',
              ),
          '/editpage': (context) => const EditScreen(
                title: 'Edit Item',
                buttonText: 'Update',
              ),
          '/readpage': (context) => const ReadScreen()
        },
        debugShowCheckedModeBanner: false,
        title: 'Flutibre',
      ),
    );
  }
}
