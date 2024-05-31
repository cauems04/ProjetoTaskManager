import 'package:flutter/material.dart';
import 'navegacao.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String _title = 'Gerencie seus produtos';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      home: PaginaNavegacao(),
    );
  }
}
