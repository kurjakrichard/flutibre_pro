import 'package:delayed_display/delayed_display.dart';
import 'package:flutibre_pro/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key, required this.context}) : super(key: key);
  final BuildContext context;
  @override
  State<LoadingPage> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingPage> {
  final Duration initialDelay = const Duration(seconds: 0);
  @override
  initState() {
    wait();
    super.initState();
  }

  void wait() async {
    await Future.delayed(const Duration(seconds: 6));

    // ignore: use_build_context_synchronously
    widget.context.read<ThemeProvider>().downloading = true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Flutibre',
              style: TextStyle(fontSize: 28),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: SizedBox(
                  height: 175,
                  child: Image.asset(
                    'images/bookshelf-icon2.png',
                    fit: BoxFit.fitWidth,
                  )),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  delayedDisplay(0, 'Loading'),
                  delayedDisplay(2, '.'),
                  delayedDisplay(3, '.'),
                  delayedDisplay(4, '.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget delayedDisplay(int delay, String displayText) {
    return DelayedDisplay(
      delay: Duration(seconds: initialDelay.inSeconds + delay),
      child: Text(
        displayText,
        style: const TextStyle(
          fontSize: 26.0,
        ),
      ),
    );
  }
}
