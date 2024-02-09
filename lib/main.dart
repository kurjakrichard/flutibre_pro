import 'package:flutibre/screens/manage_item_screen.dart';
import 'package:flutibre/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/booklist_provider.dart';
import 'screens/show_items_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const Flutibre());
}

class Flutibre extends StatelessWidget {
  const Flutibre({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => BooksProvider())],
      builder: (context, child) => MaterialApp(
        theme: baseTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const ShowItemsScreen(),
          '/addpage': (context) => const ManageItemScreen(
                title: 'Add Item',
                buttonText: 'Insert',
              ),
          '/editpage': (context) => const ManageItemScreen(
                title: 'Edit Item',
                buttonText: 'Update',
              )
        },
        debugShowCheckedModeBanner: false,
        title: 'Flutibre',
      ),
    );
  }
}
