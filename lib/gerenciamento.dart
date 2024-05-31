import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaginaGerenciamento extends StatefulWidget {
  final String email;
  const PaginaGerenciamento({super.key, required this.email});
  @override
  PaginaGerenciamentoState createState() => PaginaGerenciamentoState();
}

class PaginaGerenciamentoState extends State<PaginaGerenciamento>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scroll = ScrollController();
  final TextEditingController _pesquisa = TextEditingController();
  List<Widget> itens = [];
  final List<dynamic> itensInfo = [];
  List<int> indicesDisponiveis = [];
  int idExcluido = 0;
  bool get wantKeepAlive => true;

  void _descerTela() {
    _scroll.animateTo(
      _scroll.position.maxScrollExtent,
      duration: Duration(milliseconds: 400),
      curve: Curves.decelerate,
    );
  }

  void _selecionarItem(List<dynamic> listaItensInfo) {
    for (List infos in listaItensInfo) {
      if (_pesquisa.text == infos[1]) {
        double pos = infos[0] * 226;
        print([infos[0], pos]);
        _scroll.animateTo(pos,
            duration: Duration(milliseconds: 400), curve: Curves.decelerate);
        _pesquisa.clear();
        break;
      }
    }
    ;
  }

  void _excluirItem(List<Widget> itens, List<dynamic> listaItensInfo,
      List<int> indicesDisponiveis, int idExcluido) async {
    print(listaItensInfo);
    for (List infos in listaItensInfo) {
      if (_pesquisa.text == infos[1]) {
        listaItensInfo.remove(infos);
        idExcluido = infos[0];
        print(indicesDisponiveis);
        indicesDisponiveis[idExcluido] = 0;
        print(indicesDisponiveis);

        double pos = infos[0] * 226;
        _scroll.animateTo(pos,
            duration: Duration(milliseconds: 400), curve: Curves.decelerate);
        _pesquisa.clear();

        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('produtos')
            .where('email', isEqualTo: widget.email)
            .where('produto', isEqualTo: infos[1])
            .get();

        for (var doc in snapshot.docs) {
          await FirebaseFirestore.instance
              .collection('produtos')
              .doc(doc.id)
              .delete();
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Item excluído com sucesso!'),
            duration: Duration(seconds: 3)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF8CB0B0),
          title: GestureDetector(
              child: TextField(
                  controller: _pesquisa,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      prefixIcon: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            _selecionarItem(itensInfo);
                            print(itens.length);
                          }),
                      hintText: ('Pesquisar / Excluir'),
                      hintStyle: TextStyle(color: Colors.white60),
                      border:
                          OutlineInputBorder(borderSide: BorderSide.none)))),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(left: 10, right: 20),
                child: CircleAvatar(
                  backgroundColor: Color(0xFFDA6450),
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete_forever,
                      color: Color(0xff525252),
                    ),
                    tooltip: 'Excluir item',
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      bool valorZero = false;
                      for (int i in indicesDisponiveis) {
                        if (i == 0) {
                          valorZero = true;
                          break;
                        } else {
                          valorZero = false;
                        }
                      }
                      if (valorZero == true) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Insira os valores no item excluído antes de excluir mais itens.'),
                          duration: Duration(seconds: 3),
                        ));
                      } else {
                        _excluirItem(
                            itens, itensInfo, indicesDisponiveis, idExcluido);
                        print(idExcluido);
                      }
                    },
                  ),
                )),
            Padding(
                padding: const EdgeInsets.only(left: 10, right: 20),
                child: CircleAvatar(
                  backgroundColor: Color(0xFFF2E0A0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.bookmark_add,
                      color: Color(0xff525252),
                    ),
                    tooltip: 'Adicionar novo',
                    onPressed: () {
                      setState(() {
                        bool valorZero = false;
                        for (int i in indicesDisponiveis) {
                          if (i == 0) {
                            valorZero = true;
                            break;
                          } else {
                            valorZero = false;
                          }
                        }
                        if (valorZero == true) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Insira os valores no item excluído antes de criar mais itens.'),
                            duration: Duration(seconds: 3),
                          ));
                        } else {
                          _selecionarItem(itensInfo);
                          itens.add(criarItem(
                              itens, itensInfo, indicesDisponiveis, context));
                          Future.delayed(Duration(milliseconds: 100), () {
                            _descerTela();
                          });
                        }
                      });
                    },
                  ),
                )),
          ],
        ),
        body: Container(
          color: Color(0xFF432332),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: ScrollbarTheme(
                      data: ScrollbarThemeData(
                          thumbColor:
                              MaterialStateProperty.all(Color(0xffcdfefe))),
                      child: Scrollbar(
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            controller: _scroll,
                            child: Column(
                              children: itens,
                            ),
                          ))),
                )
              ],
            ),
          ),
        ));
  }

  void atualizarIndicesDisponiveis(List<int> novosIndices) {
    setState(() {
      indicesDisponiveis = novosIndices;
    });
  }

  Widget criarItem(List<Widget> listaItens, List<dynamic> listaItensInfo,
      List<int> indicesDisponiveis, BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController nomeProd = TextEditingController();
    final TextEditingController quantidadeProd = TextEditingController();
    final TextEditingController precoProd = TextEditingController();

    void _salvarItem(BuildContext context, List<Widget> listaItens,
        List<dynamic> listaItensInfo, List<int> indicesDisponiveis) async {
      if (_formKey.currentState!.validate()) {
        try {
          String produto = nomeProd.text;
          int quantidade = int.parse(quantidadeProd.text);
          double preco = double.parse(precoProd.text);
          List<dynamic> infos = [];
          List<int> tamanhoIndicesDisponiveis =
              List.generate(indicesDisponiveis.length, (index) => index);
          print(tamanhoIndicesDisponiveis);
          bool posZero = false;
          bool nomeIgual = false;
          for (List item in listaItensInfo) {
            if (item[1] == produto) {
              nomeIgual = true;
              break;
            }
          }
          if (nomeIgual == true) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Este nome de produto já existe! Não foi possível salva-lo'),
              duration: Duration(seconds: 3),
            ));
            return;
          }
          for (int i in tamanhoIndicesDisponiveis) {
            if (indicesDisponiveis[i] == 0) {
              print("condição confirmada, valor i: $i");
              infos = [i, produto, quantidade, preco];
              listaItensInfo.add(infos);
              indicesDisponiveis[i] = 1;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Item salvo com sucesso.'),
                duration: Duration(seconds: 3),
              ));
              posZero = true;
              break;
            }
          }
          if (posZero == false) {
            infos = [listaItensInfo.length, produto, quantidade, preco];
            listaItensInfo.add(infos);
            indicesDisponiveis.add(1);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Item salvo com sucesso.'),
              duration: Duration(seconds: 3),
            ));
          }
          if (widget.email != '') {
            await FirebaseFirestore.instance.collection('produtos').add({
              'produto': produto,
              'quantidade': quantidade,
              'preco': preco,
              'email': widget.email,
            });
          }
          print([listaItensInfo]);
        } catch (FormatException) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Insira somente valores numéricos nos campos Quantidade e Preço Unitário'),
              duration: Duration(seconds: 3)));
        }
      }
    }

    return Container(
      height: 214,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: BoxDecoration(
          color: Color(0xFFF2E0A0),
          border: Border.all(
            color: Colors.white,
            width: 4,
          ),
          borderRadius: BorderRadius.circular(20)),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
                controller: nomeProd,
                decoration: InputDecoration(
                    labelText: 'Produto ' + (listaItens.length + 1).toString(),
                    labelStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    filled: true,
                    fillColor: Color(0xffdcca8e),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.white, width: 4)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            BorderSide(color: Colors.white, width: 2)))),
            Container(
                padding: EdgeInsets.only(top: 5.0),
                child: Row(children: [
                  Expanded(
                      child: TextFormField(
                          controller: quantidadeProd,
                          decoration: InputDecoration(
                              labelText: 'Quantidade',
                              labelStyle: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              filled: true,
                              fillColor: Color(0xffdcca8e),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 4)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2))))),
                  Expanded(
                      child: TextFormField(
                          controller: precoProd,
                          decoration: InputDecoration(
                              labelText: 'Preço Unitário',
                              labelStyle: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              filled: true,
                              fillColor: Color(0xffdcca8e),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 4)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2)))))
                ])),
            Container(
              padding: EdgeInsets.only(top: 5),
              child: RawMaterialButton(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  fillColor: Color(0xff68c670),
                  hoverColor: Color(0xFF8FD995),
                  child: Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    _salvarItem(context, listaItens, listaItensInfo,
                        indicesDisponiveis);
                    atualizarIndicesDisponiveis(indicesDisponiveis);
                    print(indicesDisponiveis);
                  }),
            )
          ],
        ),
      ),
    );
  }
}
