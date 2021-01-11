import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/Home.dart';
import 'package:whatsappclone/Login.dart';
import 'package:whatsappclone/RouteGeneretor.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      title: 'Whatsapp - clone',
      home: Login(),
      theme: ThemeData(
        primaryColor: Color(0xff075e54),
        accentColor: Color(0xff25d366),
      ),
      initialRoute: "/",
      onGenerateRoute: RouteGeneretor.genereteRoute,
      debugShowCheckedModeBanner: false,
    ),
  );
  // Firestore.instance
  //     .collection('usuarios')
  //     .document('002')
  //     .setData({'nome': 'Wagner'});

}

