import 'package:flutter/material.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int counter = prefs.getInt('counter') ?? 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawerNavigation(context),
      appBar: AppBar(title: const Text('Flutibre Pro')),
      body: Center(
          child: Text(
        counter.toString(),
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
    await prefs.setInt('counter', counter + 1);
    setState(() {
      counter++;
    });
  }

  void _reset() async {
    await prefs.setInt('counter', 0);
    setState(() {
      counter = 0;
    });
  }

  void _decreaseCounter() async {
    await prefs.setInt('counter', counter - 1);
    setState(() {
      counter--;
    });
  }

  //DrawerNavigation widget
  Widget drawerNavigation(context) {
    return Material(
      child: Drawer(
        child: ListView(children: [
          DrawerHeader(child: Image.asset('images/bookshelf-icon.png')),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Homepage'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomePage()));
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
