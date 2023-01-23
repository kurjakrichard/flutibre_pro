import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../main.dart';

// ignore: must_be_immutable
class HomePage extends HookWidget {
  HomePage({Key? key}) : super(key: key);

  ValueNotifier<int>? counter;

  @override
  Widget build(BuildContext context) {
    counter = useState(prefs.getInt('counter') ?? 0);
    return Scaffold(
      drawer: drawerNavigation(context),
      appBar: AppBar(title: const Text('Flutibre Pro')),
      body: Center(
          child: Text(
        counter!.value.toString(),
        style: Theme.of(context).textTheme.headline2,
      )),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: const Text("btn1"),
            onPressed: () {
              _incrementCounter();
            },
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            heroTag: const Text("btn2"),
            onPressed: () {
              _reset();
            },
            child: const Icon(Icons.exposure_zero_outlined),
          ),
          FloatingActionButton(
            heroTag: const Text("btn3"),
            onPressed: () {
              _decreaseCounter();
            },
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }

  void _incrementCounter() async {
    await prefs.setInt('counter', counter!.value + 1);

    counter!.value++;
  }

  void _reset() async {
    await prefs.setInt('counter', 0);
    counter!.value = 0;
  }

  void _decreaseCounter() async {
    await prefs.setInt('counter', counter!.value - 1);
    counter!.value--;
  }

  //DrawerNavigation widget
  Widget drawerNavigation(context) {
    return Material(
      child: Drawer(
        child: ListView(children: [
          DrawerHeader(child: Image.asset('images/bookshelf-icon2.png')),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Homepage'),
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
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                '/settings',
              );
            },
          )
        ]),
      ),
    );
  }
}
