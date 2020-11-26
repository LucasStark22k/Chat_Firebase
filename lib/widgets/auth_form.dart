import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_firebase/screen/chatscreen.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  TextEditingController _email = TextEditingController();
  TextEditingController _senha = TextEditingController();
  TextEditingController _nome = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    return Center(
      child: Card(
        margin: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nome',
                    ),
                    controller: _nome,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'E-Mail',
                    ),
                    controller: _email,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                    ),
                    controller: _senha,
                  ),
                  SizedBox(height: 10),
                  RaisedButton(
                    child: Text('Entrar'),
                    onPressed: () async {
                      int i = 0;
                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .signInWithEmailAndPassword(
                                email: _email.text, password: _senha.text);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'usuário-não-encontrado') {
                          print(' e-mail inexistente ');
                        } else if (e.code == 'senha-incorreta') {
                          print('Senha errada incorreta');
                        }

                        i = 1;
                      }

                      if (i == 0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen()));
                      }
                    },
                  ),
                  FlatButton(
                    child: Text('Criar  conta?'),
                    onPressed: () async {
                      int i = 0;
                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                                email: _email.text, password: _senha.text);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'senha fraca') {
                          print('A senha fornecida é muito fraca');
                        } else if (e.code == 'email-já-existe') {
                          print('Esse e-mail ja esta registrado');
                        }
                        i = 1;
                      }
                      if (i == 0) {
                        print("Registrou!");
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
