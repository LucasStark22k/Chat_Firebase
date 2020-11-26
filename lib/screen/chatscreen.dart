import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  TextEditingController _mensagem = TextEditingController();
  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);
    Widget Lista() {
      return Container(
        height: MediaQuery.of(context).size.height - 80,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("mensagens")
              .orderBy("createdAt")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final documents = snapshot.data.docs;
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: documents.length,
              itemBuilder: (ctx, i) => Container(
                padding: EdgeInsets.all(8),
                child: Text(documents[i]['msg']),
              ),
            );
          },
        ),
      );
    }

    Widget Mensagem() {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: TextFormField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: "mensagem",
            labelStyle: TextStyle(
              color: Colors.blueGrey,
            ),
            suffix: GestureDetector(
              child: Icon(
                Icons.send,
                color: Colors.blueAccent,
              ),
              onTap: () {
                FirebaseFirestore.instance.collection("mensagens").add({
                  'msg': _mensagem.text,
                  'Usuario': "Lucas",
                  'createdAt': Timestamp.now(),
                });
                _mensagem.text = "";
              },
            ),
          ),
          controller: _mensagem,
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.red, fontSize: 30.0),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              Lista(),
              Mensagem(),
            ],
          )),
    );
  }
}
