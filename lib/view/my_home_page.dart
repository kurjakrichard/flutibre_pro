import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/counter_provider.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  final String title = 'Database Handling';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider teszt'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                'You have pushed the button this many times: ${context.watch<Counter>().count}'),
            counter()
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            key: const Key('decrement'),
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
            onPressed: () {
              context.read<Counter>().decrement();
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FloatingActionButton(
              key: const Key('reset'),
              tooltip: 'Reset',
              child: const Icon(Icons.exposure_zero),
              onPressed: () {
                context.read<Counter>().reset();
              },
            ),
          ),
          FloatingActionButton(
            key: const Key('increment'),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
            onPressed: () {
              context.read<Counter>().increment();
            },
          ),
        ],
      ),
    );
  }

  Widget counter() {
    return Builder(builder: (context) {
      return Text('${context.watch<Counter>().count}');
    });
  }
}
