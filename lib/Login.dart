import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/Cadastro.dart';
import 'package:whatsappclone/Home.dart';
import 'package:whatsappclone/model/Usuario.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmails = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";
  _validarCampos(){
    String email = _controllerEmails.text;
    String senha = _controllerSenha.text;

    if( email.isNotEmpty && email.contains("@")){
      if( senha.isNotEmpty){
        Usuario usuario = Usuario();
        usuario.email =email;
        usuario.senha =senha;
        _logarUsuario(usuario);
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
  }
  _logarUsuario(Usuario usuario ){
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signInWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((firebaseUser) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
          builder: (context) => Home()
      )
      );

    }
    ).catchError((erro){
      setState(() {
        _mensagemErro="Erro ao autenticar usúario!";
      });
    });

  }

  Future _verificarUsuarioLogado () async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    // auth.signOut();
    if(usuarioLogado !=null){
      Navigator.pushReplacementNamed(context, "/home");
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verificarUsuarioLogado();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xff075e54)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(padding: EdgeInsets.only(bottom: 32),
                child: Image.asset("imagens/logo.png",width: 200,height: 150,)
                ),
                Padding(padding: EdgeInsets.only(bottom: 8),
                child: TextField(
                  controller: _controllerEmails,
                  autofocus: true,
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
                  controller: _controllerSenha,
                  obscureText: true,
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
                  child: Text("Entrar",
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
                  child: GestureDetector(
                    child: Text("Não tem conta? cadastra-se!",
                    style: TextStyle(
                      color: Colors.white,

                    ),),
                    onTap:(){
                      Navigator.pushReplacementNamed(context, "/cadastro");

                    } ,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 16),
                child:  Center(
                  child: Text(_mensagemErro,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 20
                    ),
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
