import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager/navegacao.dart';
import 'cadastro.dart';
import 'enviar_email.dart';

class PaginaLogin extends StatefulWidget {
  const PaginaLogin({super.key});
  @override
  PaginaLoginState createState() => PaginaLoginState();
}

class PaginaLoginState extends State<PaginaLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailC = TextEditingController();
  TextEditingController senhaC = TextEditingController();

  void acessarCadastro() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PaginaCadastro()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF8CB0B0),
          title: const Text(
            'Login',
            style: TextStyle(
                color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Container(
            color: Color(0xFF432332),
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Text(
                          'Realize seu login!',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xff361c28),
                                icon:
                                    new Icon(Icons.email, color: Colors.white),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                hintText: ('Email'),
                                hintStyle: TextStyle(color: Colors.white60)),
                            controller: emailC,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira o email';
                              }
                              return null;
                            },
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xff361c28),
                              icon: new Icon(
                                Icons.key,
                                color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              hintText: ("Senha"),
                              hintStyle: TextStyle(color: Colors.white60)),
                          controller: senhaC,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira a senha';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: RawMaterialButton(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            fillColor: Color(0xFFF2E0A0),
                            hoverColor: Color(0xffb9ac77),
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                try {
                                  QuerySnapshot query = await FirebaseFirestore
                                      .instance
                                      .collection('usuarios')
                                      .where('email', isEqualTo: emailC.text)
                                      .where('senha', isEqualTo: senhaC.text)
                                      .get();

                                  if (query.docs.isNotEmpty) {
                                    String emailUsuario = emailC.text;

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content:
                                          Text('Login efetuado com sucesso!'),
                                      duration: Duration(seconds: 3),
                                    ));
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EnviarEmail(
                                                email: emailUsuario,
                                                child: PaginaNavegacao(),
                                              )),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('Usuário não encontrado'),
                                      duration: Duration(seconds: 3),
                                    ));
                                    print('Usuário não encontrado');
                                  }
                                } catch (e) {
                                  print('Erro de login: $e');
                                }
                              }
                            },
                            child: const Text(
                              "Entrar",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 60),
                        child: Text(
                          'Ainda não tem uma conta?',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: RawMaterialButton(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              fillColor: Color(0xFFF2E0A0),
                              hoverColor: Color(0xffb9ac77),
                              onPressed: () {
                                acessarCadastro();
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                child: const Text(
                                  "Crie uma clicando aqui",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ))),
                    ],
                  ),
                ),
              ),
            )));
  }
}
