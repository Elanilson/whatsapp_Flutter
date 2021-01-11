import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/Home.dart';
import 'package:whatsappclone/model/Usuario.dart';
class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmails = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";
  _validarCampos(){
    String nome = _controllerNome.text;
    String email = _controllerEmails.text;
    String senha = _controllerSenha.text;

    if( nome.isNotEmpty){
      if( email.isNotEmpty && email.contains("@")){
        if( senha.isNotEmpty){
          Usuario usuario = Usuario();
          usuario.nome =nome;
          usuario.email =email;
          usuario.senha =senha;
          _cadastrarUsuario(usuario);
        }else{
          setState(() {
            _mensagemErro="Preencha o campo senha!";
          });
        }

      }else{
        setState(() {
          _mensagemErro="Preencha o Email corretamente!";
        });
      }

    }else{
      setState(() {
        _mensagemErro="Preencha o nome";
      });
    }
  }

  _cadastrarUsuario(Usuario usuario){
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((firebaseUser){

      //salvar dados do usuario no firebase
      Firestore db =Firestore.instance;
      db.collection("usuarios") // criando uma coleção de usuarios
      .document(firebaseUser.uid) // passando id
      .setData(usuario.toMap()); // usuario convertido para map

      setState(() {
        // Navigator.pushReplacementNamed(context, "/home");
        Navigator.pushNamedAndRemoveUntil(context, "/home", (_)=> false);

      });
    }).catchError((){
      setState(() {
        _mensagemErro ="Erro ao realizar o cadastro, verefique os campos";
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xff075e54)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(padding: EdgeInsets.only(bottom: 32),
                    child: Image.asset("imagens/usuario.png",width: 200,height: 150,)
                ),
                Padding(padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerNome,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontSize: 20,
                    ),
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
                Padding(padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerEmails,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "E-mail",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32)
                      ),
                    ),
                  ),
                ),
                TextField(
                  obscureText: true,
                  controller: _controllerSenha,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    hintText: "Senha",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 16,bottom: 10),
                  child: RaisedButton(
                    onPressed: (){
                      _validarCampos();
                    },
                    child: Text("Cadastrar",
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
                Center(
                  child: Text(_mensagemErro,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 20
                    ),
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
