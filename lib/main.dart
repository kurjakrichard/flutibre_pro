import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/book_provider.dart';
import 'view/flutibre_pro.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookProvider()),
      ],
      child: const FlutibrePro(),
    ),
  );
}
