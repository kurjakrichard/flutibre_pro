import 'package:flutibre/screens/editscreen.dart';
import 'package:flutibre/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/booklist_provider.dart';
import 'screens/homescreen.dart';
import 'screens/readscreen.dart';

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
        ChangeNotifierProvider(create: (context) => BooksListProvider())
      ],
      builder: (context, child) => MaterialApp(
        theme: baseTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
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
