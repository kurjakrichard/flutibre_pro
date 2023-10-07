import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/authors_provider.dart';
import 'screens/show_items_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const Flutibre());
}

class Flutibre extends StatelessWidget {
  const Flutibre({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {'/': (context) => const HomePage()},
      debugShowCheckedModeBanner: false,
      title: 'Flutibre',
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthorsProvider())
      ],
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutibre',
        theme: ThemeData(),
        home: const ShowItemsScreen(),
      ),
    );
  }
}
