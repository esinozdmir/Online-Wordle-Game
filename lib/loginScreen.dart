import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yazlabkelimeoyunu/Helpers/screen.dart';
import 'package:yazlabkelimeoyunu/db.dart';
import 'package:yazlabkelimeoyunu/mainMenu.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    ScreenUtilities screen = ScreenUtilities(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 177, 206, 230),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color.fromARGB(255, 0, 0, 0)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Log In', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
        backgroundColor: Color.fromARGB(255, 177, 206, 230),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: screen.height * 0.2,
              left: screen.width * 0.05,
              right: screen.width * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Login.',
                style: TextStyle(
                    fontSize: screen.height * 0.1,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 0, 0)),
              ),
              SizedBox(height: screen.height * 0.01),
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: screen.height * 0.035,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              SizedBox(height: screen.height * 0.07),
              Textfields(screen),
              SizedBox(height: 24),
              ElevatedButton(
                child: Text('Log In'),
                onPressed: () {
                  signInWithEmailAndPassword(context);
                },
                style: ElevatedButton.styleFrom(
                    foregroundColor: Color.fromARGB(255, 255, 255, 255),
                    backgroundColor: Color.fromARGB(255, 85, 130, 168),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    minimumSize:
                        Size(screen.width * 0.9, screen.height * 0.06)),
              ),
              TextButton(
                child: Text('Forgot?', style: TextStyle(color: Color.fromARGB(255, 1, 1, 2))),
                onPressed: () {
                  forgotPassword(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget Textfields(ScreenUtilities screen) {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            fillColor: Colors.white54, // Gri iç arka plan rengi
            filled: true, // İç arka plan rengini etkinleştir
            labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)), // Label metni mor renk
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0), // Yuvarlak köşeler
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Colors.grey[800]!, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Color.fromARGB(255, 177, 206, 230), width: 2.0),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)), // Yazı metni mor renk
          cursorColor: const Color.fromARGB(255, 0, 0, 0), // İmleç rengi mor
          //shadowColor: Colors.black.withOpacity(0.5), // Gölge rengi
        ),
        SizedBox(height: screen.height * 0.02),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            fillColor: Colors.white54, // Gri iç arka plan rengi
            filled: true, // İç arka plan rengini etkinleştir
            labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)), // Label metni mor renk
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0), // Yuvarlak köşeler
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Colors.grey[800]!, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Color.fromARGB(255, 177, 206, 230), width: 2.0),
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(

                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: Color.fromARGB(255, 82, 77, 77),
              ),
            ),
          ),
          obscureText: _obscureText,
          style: TextStyle(color: const Color.fromARGB(255, 2, 2, 2)), // Yazı metni mor renk
          cursorColor: Color.fromARGB(255, 0, 0, 0),  // İmleç rengi mor
          //shadowColor: Colors.black.withOpacity(0.5), // Gölge rengi
        ),
      ],
    );
  }

  void forgotPassword(BuildContext context) {
    TextEditingController forgotPasswordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Forgot Password'),
          content: TextField(
            controller: forgotPasswordController,
            decoration: InputDecoration(hintText: "Enter your email"),
            keyboardType: TextInputType.emailAddress,
          ),
          actions: [
            TextButton(
              child: Text('Send'),
              onPressed: () {
                sendPasswordResetEmail(forgotPasswordController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void signInWithEmailAndPassword(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print("User logged in: ${userCredential.user!.email}");
      // Burada kullanıcı giriş yaptıktan sonra ne yapmak istediğinizi belirtebilirsiniz,
      // Örneğin, başka bir sayfaya yönlendirebilirsiniz.
      Navigator.push(context, MaterialPageRoute(builder: (context) => const MainMenu()));
    } catch (e) {
      print("Login failed: $e");
      // Giriş başarısız olduğunda burada kullanıcıya bir uyarı gösterebilirsiniz.
    }
  }
}
