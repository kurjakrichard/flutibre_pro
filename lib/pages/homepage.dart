import 'package:flutibre_pro/providers/booklist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BookListProvider>(
      builder: (context, value, child) => Scaffold(
        drawer: drawerNavigation(context),
        appBar: AppBar(title: const Text('Flutibre Pro')),
        body: Center(
            child: Text(
          value.counter.toString(),
        )),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'btn1',
              tooltip: 'Increment',
              onPressed: () {
                value.incrementCounter();
              },
              child: const Icon(Icons.add),
            ),
            FloatingActionButton(
              heroTag: 'btn2',
              tooltip: 'Reset',
              onPressed: () {
                value.reset();
              },
              child: const Icon(Icons.exposure_zero_outlined),
            ),
            FloatingActionButton(
              heroTag: 'btn3',
              tooltip: 'Decrement',
              onPressed: () {
                value.decreaseCounter();
              },
              child: const Icon(Icons.remove),
            ),
          ],
        ),
      ),
    );
  }

  //DrawerNavigation widget
  Widget drawerNavigation(context) {
    return Material(
      child: Drawer(
        child: ListView(children: [
          DrawerHeader(
              child: Row(
            children: [
              Image.asset('images/bookshelf-icon2.png'),
              const Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Text(
                  'Flutibre',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ],
          )),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(AppLocalizations.of(context)!.homepage),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                '/',
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(AppLocalizations.of(context)!.settingspage),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          )
        ]),
      ),
    );
  }
}
