import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsappclone/Home.dart';
import 'package:whatsappclone/model/Usuario.dart';
class Configuracoes extends StatefulWidget {
  @override
  _ConfiguracoesState createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  TextEditingController _controllerNome = TextEditingController();
  File _imagem;
  String _idUsuarioLogado;
  bool _subindoImagem = false;
  String  _urlImagemRecuperada;

  Future _recuperarImagem (String origemImagem) async{
    File imagemSelecionada;
    switch(origemImagem){
      case "camera":
        imagemSelecionada =await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      case "galeria":
        imagemSelecionada =await ImagePicker.pickImage(source: ImageSource.gallery);
        break;

    }
    setState(() {
      _imagem = imagemSelecionada;
      if(_imagem != null){
      _subindoImagem = true;
        _uploadImagem();

      }
    });

  }

  Future _uploadImagem () async {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference  pastaRaiz  = storage.ref();
    StorageReference  arqruivo  = pastaRaiz.child("perfil").child(_idUsuarioLogado+".jpg");

      // upload da imagem
    StorageUploadTask task = arqruivo.putFile(_imagem);

    // contrrolar progresso do upload
    task.events.listen((StorageTaskEvent event) {
      if(event.type == StorageTaskEventType.progress){
        setState(() {
          _subindoImagem = true;
        });

      }else if (event.type == StorageTaskEventType.success){
        setState(() {
          _subindoImagem = false;
        });
      }
    });

    //recuperar url da imagem
    task.onComplete.then((StorageTaskSnapshot snapshot){
      _recuperarUrlImagem(snapshot);

    });

}
    Future _recuperarUrlImagem (StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();
    _atualizarUrlImagemFireStore(url);

    setState(() {
      _urlImagemRecuperada = url;
    });

    }
  _atualizarNomeireStore(){
    String nome = _controllerNome.text;
    Map<String, dynamic> dadosAtualizar = {
      "nome" : nome
    };

    Firestore db = Firestore.instance;
    db.collection("usuarios").document(_idUsuarioLogado).updateData(dadosAtualizar);

  }

  _atualizarUrlImagemFireStore(String url){
    Firestore db = Firestore.instance;

    Map<String, dynamic> dadosAtualizar = {
    "urlImagem" : url
    };

    db.collection("usuarios").document(_idUsuarioLogado).updateData(dadosAtualizar);

  }

  _recuperarDadosUsuario () async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usaurioLogado = await auth.currentUser();
    _idUsuarioLogado =usaurioLogado.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await  db.
    collection("usuarios").document(_idUsuarioLogado).get();

    Map<String, dynamic> dados= snapshot.data;
    _controllerNome.text = dados["nome"] ;

    if(dados["urlImagem"] != null){
      _urlImagemRecuperada = dados["urlImagem"];

    }


    }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarDadosUsuario();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text("Configurações"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
              Container(
                padding: EdgeInsets.all(16),
                child: _subindoImagem ?  CircularProgressIndicator() : Container(),
              ),
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey,
                  backgroundImage:
                  _urlImagemRecuperada != null
                    ? NetworkImage(_urlImagemRecuperada): null
                ),
                Row(
                  mainAxisAlignment:  MainAxisAlignment.center,
                  children: [
                    FlatButton(
                        onPressed: (){
                          _recuperarImagem("camera");
                        },
                        child: Text("Câmera")
                    ),
                    FlatButton(
                        onPressed: (){
                          _recuperarImagem("galeria");

                        },
                        child: Text("Galeria")
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerNome,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    onChanged: (texto){
                      _atualizarNomeireStore();
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Nome",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32)
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 16,bottom: 10),
                  child: RaisedButton(
                    onPressed: (){
                      _atualizarNomeireStore();

                    },
                    child: Text("Salvar",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      ),

                    ),
                    color: Colors.green,
                    padding:  EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
