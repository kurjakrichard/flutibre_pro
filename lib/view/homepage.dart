import 'package:flutibre_pro/main.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int counter = sharedPreferences.getInt('counter') ?? 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(counter.toString())),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _incrementCounter();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _incrementCounter() async {
    await sharedPreferences.setInt('counter', counter + 1);
    setState(() {
      counter++;
    });
  }
}
