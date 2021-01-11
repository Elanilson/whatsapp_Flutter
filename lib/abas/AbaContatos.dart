
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsappclone/Home.dart';
import 'package:whatsappclone/model/Conversa.dart';
import 'package:whatsappclone/model/Usuario.dart';

class AbaContatos extends StatefulWidget {
  @override
  _AbaContatosState createState() => _AbaContatosState();
}

class _AbaContatosState extends State<AbaContatos> {
  String  _idUsuarioLogado;
  String  _emailUsuarioLogado;
  _recuperarDadosUsuario () async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usaurioLogado = await auth.currentUser();
    _idUsuarioLogado =usaurioLogado.uid;
    _emailUsuarioLogado =usaurioLogado.email;


    }




  Future<List<Usuario>> _recuperarContatos() async {
    Firestore db = Firestore.instance;
    QuerySnapshot querySnapshot =
        await db.collection("usuarios").getDocuments();

    List<Usuario> usuarios = List();
    for (DocumentSnapshot item in querySnapshot.documents) {
      var dados = item.data;
      if(dados["email" ] == _emailUsuarioLogado)continue;
      Usuario usuario = new Usuario();
      usuario.idUsuario = item.documentID;
      usuario.nome = dados["nome"];
      usuario.email = dados["email"];
      usuario.urlImagem = dados["urlImagem"];

      usuarios.add(usuario);
    }

    return usuarios;
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();

    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Usuario>>(
        future: _recuperarContatos(),
        builder: (context, snaptshot) {
          switch (snaptshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  children: [
                    Text("Carregando contatos..."),
                    CircularProgressIndicator()
                  ],
                ),
              );

              break;
            case ConnectionState.active:
            case ConnectionState.done:
            return  ListView.builder(
                  itemCount: snaptshot.data.length,
                  itemBuilder: (context, index) {
                    List<Usuario> listaItens = snaptshot.data;
                    Usuario usuario = listaItens[index];

                    return ListTile(
                      onTap: (){
                        Navigator.pushNamed(
                            context, "/mensagens",
                          arguments: usuario
                        );
                      },
                      contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      leading: CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: Colors.grey,
                        backgroundImage:

                        usuario.urlImagem != null
                            ? NetworkImage(usuario.urlImagem)
                            : null
                      ),
                      title: Text(
                        usuario.nome,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    );
                  });
              break;
          }
        });
  }
}
