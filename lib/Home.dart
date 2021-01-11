import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/Login.dart';
import 'package:whatsappclone/abas/AbaContatos.dart';
import 'package:whatsappclone/abas/AbaConversas.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _controllertab;
    String _email =""  ;
    List<String> itensMenu = [
      "Configurações" , "Deslogar"
    ];

    _menuSelecEscolhaItem ( String item){

      switch(item){

        case "Configurações":
          Navigator.pushNamed(context, "/configuracoes");

          break;
        case "Deslogar":
          _deslogarUsuario();
          break;

      }

    }
    _deslogarUsuario () async {
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signOut();
      Navigator.pushReplacementNamed(context, "/login");


    }

  Future  _recuperarDadosUsuario() async{
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseUser usuarioLogado = await auth.currentUser();
      setState(() {
        _email = usuarioLogado.email;
      });
    }
  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    _verificarUsuarioLogado();
    _recuperarDadosUsuario();

    _controllertab = TabController(
        length: 2,
        vsync: this
    );
  }


  Future _verificarUsuarioLogado () async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    // auth.signOut();
    if(usuarioLogado ==null){
      Navigator.pushReplacementNamed(context, "/login");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Whatsapp - clone"),
        bottom: TabBar(
         indicatorWeight: 4,
          labelStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
          controller: _controllertab,
          indicatorColor: Colors.white,
          tabs: [
            Tab(child: Text("Conversas"),),
            Tab(child: Text("Contatos"),),
          ],
        ),
        actions: [
          PopupMenuButton <String> (
            onSelected: _menuSelecEscolhaItem,
            itemBuilder: (context){
              return itensMenu.map((String item){
                return PopupMenuItem <String>(
                  value: item,
                  child: Text(item),
                );
              }
              ).toList();

            },
          )
        ],

      ),

      body: TabBarView(
        controller: _controllertab,
        children: [
          AbaConversas(),
          AbaContatos()
        ],
      ),
    );
  }
}
