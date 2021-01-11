import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/Cadastro.dart';
import 'package:whatsappclone/Configuracoes.dart';
import 'package:whatsappclone/Home.dart';
import 'package:whatsappclone/Login.dart';
import 'package:whatsappclone/Mensagens.dart';

class RouteGeneretor {
  static Route<dynamic> genereteRoute (RouteSettings settings){

    final args = settings.arguments;

    switch (settings.name){
      case "/":
        return MaterialPageRoute(builder: (_) => Login());
        break;
      case "/login":
        return MaterialPageRoute(builder: (_) => Login());
        break;
      case "/cadastro":
        return MaterialPageRoute(builder: (_) => Cadastro());
        break;
      case "/home":
        return MaterialPageRoute(builder: (_) => Home());
        break;
      case "/configuracoes":
        return MaterialPageRoute(builder: (_) => Configuracoes());
        break; case "/mensagens":
        return MaterialPageRoute(builder: (_) => Mensagens(args));
        break;
      default:
        _erroRota();


    }

  }
    static Route<dynamic> _erroRota(){
    return MaterialPageRoute(builder: (_){
      return Scaffold(
        appBar: AppBar(
          title: Text("Tela não encontrada!"),
        ),
        body: Center(
          child: Text("Tela não encontrada!"),
        ),
      );
    });

    }
}