import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaginaCadastro extends StatefulWidget {
  const PaginaCadastro({super.key});
  @override
  PaginaCadastroState createState() => PaginaCadastroState();
}

class PaginaCadastroState extends State<PaginaCadastro> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailC = TextEditingController();
  TextEditingController senhaC = TextEditingController();

  Future<void> enviarDadosParaFirestore(String email, String senha) async {
    try {
      await FirebaseFirestore.instance.collection('usuarios').add({
        'email': email,
        'senha': senha,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Conta criada com sucesso!'),
        duration: Duration(seconds: 3),
      ));
      Navigator.pop(context);
      print("Dados enviados com sucesso!");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao criar conta!'),
        duration: Duration(seconds: 3),
      ));
      print("Erro ao enviar dados: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF8CB0B0),
          title: const Text(
            'Cadastro',
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
                        padding: const EdgeInsets.only(top: 50),
                        child: Text(
                          'Realize seu cadastro!',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xff361c28),
                                icon: const Icon(Icons.email,
                                    color: Colors.white),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                hintText: ('Email'),
                                hintStyle: TextStyle(color: Colors.white60)),
                            controller: emailC,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xff361c28),
                              icon: const Icon(
                                Icons.key,
                                color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              hintText: ("Senha"),
                              hintStyle: TextStyle(color: Colors.white60)),
                          controller: senhaC,
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
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                enviarDadosParaFirestore(
                                    emailC.text, senhaC.text);
                              }
                            },
                            child: const Text(
                              "Cadastrar",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            )));
  }
}
