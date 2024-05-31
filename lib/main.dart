import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirebaseInitializer(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FirebaseInitializer extends StatefulWidget {
  @override
  _FirebaseInitializerState createState() => _FirebaseInitializerState();
}

class _FirebaseInitializerState extends State<FirebaseInitializer> {
  Future<void> _initializeFirebase() async {
    try {
      if (kIsWeb) {
        await Firebase.initializeApp(
            options: FirebaseOptions(
                apiKey: "AIzaSyALdMfZrx2X50fnItZt1voukustGKAOOu4",
                authDomain: "taskmanager-ad82b.firebaseapp.com",
                projectId: "taskmanager-ad82b",
                storageBucket: "taskmanager-ad82b.appspot.com",
                messagingSenderId: "1014221009711",
                appId: "1:1014221009711:web:6349d5588bcc7aac4f27da",
                measurementId: "G-2P3SQ7EKS3"));
        print("Firebase inicializado");
      } else {
        await Firebase.initializeApp();
        print("Firebase inicializado");
      }
      print("Documento escrito");
    } catch (error) {
      print("Erro durante a inicialização ou escrita no Firestore: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Erro ao inicializar o Firebase: ${snapshot.error}"),
            );
          }
          return MyApp();
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Erro ao inicializar o Firebase: ${snapshot.error}"),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
