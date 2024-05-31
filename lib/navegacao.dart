import 'package:flutter/material.dart';

import 'gerenciamento.dart';
import 'login.dart';
import 'enviar_email.dart';

class PaginaNavegacao extends StatefulWidget {
  const PaginaNavegacao({super.key});
  @override
  PaginaNavegacaoState createState() => PaginaNavegacaoState();
}

class PaginaNavegacaoState extends State<PaginaNavegacao> {
  int indexAtual = 0;
  late PageController controlador;

  setIndexAtual(index) {
    setState(() {
      indexAtual = index;
    });
  }

  void initState() {
    super.initState();
    controlador = PageController(initialPage: indexAtual);
  }

  @override
  Widget build(BuildContext context) {
    final provedorEmail = EnviarEmail.of(context);
    return Scaffold(
      body: PageView(
        controller: controlador,
        children: [
          PaginaGerenciamento(email: provedorEmail?.email ?? ''),
          PaginaLogin()
        ],
        onPageChanged: setIndexAtual,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexAtual,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home, size: 26),
              label: "Gerenciador",
              tooltip: "Gerenciador"),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person, size: 26),
            label: 'Login',
            tooltip: "Login",
          ),
        ],
        onTap: (index) {
          controlador.animateToPage(index,
              duration: Duration(milliseconds: 200), curve: Curves.decelerate);
        },
        backgroundColor: Color(0xff9dc6c6),
        selectedItemColor: Colors.black,
        selectedFontSize: 16,
        unselectedFontSize: 16,
      ),
    );
  }
}
