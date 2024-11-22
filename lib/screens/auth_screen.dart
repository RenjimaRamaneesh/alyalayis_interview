import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email = '', password = '';
  bool isLoading = false;

  void login() async {
    setState(() {
      isLoading = true;
    });
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void register() async {
    setState(() {
      isLoading = true;
    });
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration failed')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple[300],
          title: const Text('Authentication',style: TextStyle(color: Colors.white,fontSize: 18,),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Email'),
              onChanged: (value) {
                email = value;
              },
            ),

            const SizedBox(height:30),
            TextField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
            ),
            const SizedBox(height: 50,),
            isLoading
                ? const CircularProgressIndicator()
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: login, child: Text('Login',style: TextStyle(color: Colors.white),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.purple.shade200)),),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: register, child: Text('Register',style: TextStyle(color: Colors.white),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.purple.shade200)),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
