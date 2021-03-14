import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sro_list/data.dart';
import 'dart:async';

import 'database_helper.dart';
import 'login.dart';

class CriarLista extends StatefulWidget {
  @override
  _CriarListaState createState() => _CriarListaState();
}

final TextEditingController _objeto = TextEditingController();
final TextEditingController _logradouro = TextEditingController();
final TextEditingController _numero = TextEditingController();
final FocusNode focusObjetoNode = FocusNode();
final FocusNode focusLogradouroNode = FocusNode();
final FocusNode focusNumeroNode = FocusNode();
bool _numeric = false;

final dbHelper = DatabaseHelper.instance;

class _CriarListaState extends State<CriarLista> {
  @override
  Widget build(BuildContext context) {
    var tipo = "text";
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.white,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Color.fromRGBO(247, 243, 240, 2),
          leading: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CupertinoButton(
                  padding: EdgeInsets.all(0),
                  child: Text('Sair'),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(builder: (context) => Login()));
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 15.0),
                  child: Container(
                    height: 8.0,
                    width: 8.0,
                  ),
                ),
              ]),
          middle: Image.asset(
            'assets/logo_correios.png',
            width: 120,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey5,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.cube_box,
                            color: Color(0xff808080),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: CupertinoTextField(
                                maxLength: 13,
                                controller: _objeto,
                                textCapitalization:
                                    TextCapitalization.characters,
                                autofocus: true,
                                focusNode: focusObjetoNode,
                                placeholder: "Objeto",
                                cursorColor: CupertinoColors.activeBlue,
                                keyboardType: _numeric
                                    ? TextInputType.number
                                    : TextInputType.text,
                                onChanged: (String value) async {
                                  if (_objeto.text.length < 2) if (_objeto
                                              .text.length >
                                          1 &&
                                      _objeto.text.length < 11) {
                                    setState(() {
                                      _numeric = true;
                                    });
                                  }
                                  if (_objeto.text.length == 11) {
                                    setState(() {
                                      _numeric = false;
                                    });
                                    //keyboardType: joinlinkname.value

                                  }
                                  if (_objeto.text.length == 13) {
                                    focusLogradouroNode.requestFocus();
                                  }
                                },
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              scan();
                            },
                            child: Icon(
                              CupertinoIcons.search,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.map,
                            color: Color(0xff808080),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: CupertinoTextField(
                                controller: _logradouro,
                                focusNode: focusLogradouroNode,
                                textCapitalization:
                                    TextCapitalization.characters,
                                placeholder: "Logradouro",
                                cursorColor: CupertinoColors.activeBlue,
                                onSubmitted: (String value) async {
                                  focusNumeroNode.requestFocus();
                                },
                              ),
                            ),
                          ),
                          Container(
                            width: 25,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.number,
                            color: Color(0xff808080),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: CupertinoTextField(
                                maxLength: 6,
                                controller: _numero,
                                focusNode: focusNumeroNode,
                                placeholder: "Número",
                                keyboardType: TextInputType.number,
                                cursorColor: CupertinoColors.activeBlue,
                                onChanged: (String value) async {},
                              ),
                            ),
                          ),
                          Container(
                            width: 25,
                          )
                        ],
                      ),
                      Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CupertinoButton(
                              child: Text("Ver Lista"),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    CupertinoPageRoute(
                                        builder: (context) => MyApp()));
                              }),
                          CupertinoButton(
                              child: Text("Limpar"),
                              onPressed: () {
                                _objeto.clear();
                                _logradouro.clear();
                                _numero.clear();
                                focusObjetoNode.requestFocus();
                              }),
                          CupertinoButton(
                              child: Text("Adicionar"),
                              onPressed: () {
                                _insert();
                              })
                        ],
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

Future scan() async {
  String barcode = await BarcodeScanner.scan();
  _objeto.text = barcode;
  focusLogradouroNode.requestFocus();
}

// ignore: unused_element
void _insert() async {
  // row to insert
  Map<String, dynamic> row = {
    DatabaseHelper.columnObjeto: _objeto.text,
    DatabaseHelper.columnLogradouro: _logradouro.text,
    DatabaseHelper.columnNumero: _numero.text
  };
  final id = await dbHelper.insert(row);
  print('inserted row id: $id');
  _objeto.clear();
  _logradouro.clear();
  _numero.clear();
  focusObjetoNode.requestFocus();
}
