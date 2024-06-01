import 'package:bankapp/models/cards.dart';
import 'package:bankapp/views/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  var islogoutlaoding = false;
  signOut() async {
    setState(() {
      islogoutlaoding = true;
    });
    await FirebaseAuth.instance.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
    setState(() {
      islogoutlaoding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("HomePage"),
          actions: [
            IconButton(
              onPressed: () {
                signOut();
              },
              icon: islogoutlaoding
                  ? CircularProgressIndicator()
                  : Icon(Icons.logout),
            )
          ],
        ),
        body: Container(
          color: Colors.grey.shade300,
          width: double.infinity,
          child: Column(
            children: [
              HeroCard(),
              TransactionCards(),
            ],
          ),
        ));
  }
}
