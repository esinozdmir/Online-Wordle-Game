import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yazlabkelimeoyunu/db.dart';
import 'package:yazlabkelimeoyunu/loginScreen.dart';
import 'package:yazlabkelimeoyunu/signup.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: WelcomeScreen(),
    );
  }
}

class GoogleSignInAccount {
  final String? Username;
  final String? email;
  final String? photoUrl;

  GoogleSignInAccount({
    this.Username,
    this.email,
    this.photoUrl,
  });
}

class WelcomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 24.0, right: 24, top: height * 0.2),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Hello.',
              style: TextStyle(
                fontSize: 72.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Let\'s Get Started!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: height * 0.07),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInScreen()));
              },
              child: Text('Sign Up', style: TextStyle(fontWeight:FontWeight.bold ),),
              style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                  backgroundColor: Color.fromARGB(255, 101, 156, 200),
                  minimumSize: Size(double.infinity, 65)),
            ),
            SizedBox(height: 16.0),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Text("or"),
              alignment: Alignment.center,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text('Already have an account? Sign in here.', style: TextStyle(fontWeight:FontWeight.bold ),),
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 65)),
            ),

          ],
        ),
      ),
    );
  }
}
