import 'package:flutter/material.dart';

class EnviarEmail extends InheritedWidget {
  final String email;
  final Widget child;

  EnviarEmail({required this.email, required this.child}) : super(child: child);

  static EnviarEmail? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<EnviarEmail>();
  }

  @override
  bool updateShouldNotify(EnviarEmail oldWidget) {
    return email != oldWidget.email;
  }
}
