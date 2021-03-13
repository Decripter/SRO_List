import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyCustomForm();
  }
}

// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds data related to the form.
class _MyCustomFormState extends State<MyCustomForm> {
  final TextEditingController _matTextField = TextEditingController();
  final TextEditingController _senhaTextField = TextEditingController();
  // Define the focus node. To manage the lifecycle, create the FocusNode in
  // the initState method, and clean it up in the dispose method.
  FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: CupertinoPageScaffold(
        backgroundColor: Color.fromRGBO(26, 116, 197, 15),
        child: Padding(
          padding: const EdgeInsets.all(58.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://apps.shopifycdn.com/listing_images/3c310093e62eb029122fcdf3b9792814/icon/d4f660ffbeac192c660fb390504d83c1.png',
                width: 130,
              ),
              Container(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoTextField(
                      placeholder: 'Matricula',
                      placeholderStyle: TextStyle(color: Colors.grey),
                      autofocus: true,
                      maxLength: 8,
                      controller: _matTextField,
                      style: TextStyle(color: Colors.blueGrey),
                      keyboardType: TextInputType.number,
                      onChanged: (String value) async {
                        if (_matTextField.text.length == 8) {
                          myFocusNode.requestFocus();
                        }
                      },
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    CupertinoTextField(
                      placeholder: 'Senha',
                      focusNode: myFocusNode,
                      style: TextStyle(color: Colors.black),
                      placeholderStyle: TextStyle(color: Colors.grey),
                      controller: _senhaTextField,
                      keyboardType: TextInputType.number,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    CupertinoButton(
                      child: Text(
                        "Entrar",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      onPressed: () {
                        LogIn();
                        if (_matTextField.text.toString() == "80886787" &&
                            _senhaTextField.text.toString() == "80886787") {
                          print("login aceito");
                          Navigator.pushNamed(context, '/cadastro');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
LogIn() {
  print('ok');
}