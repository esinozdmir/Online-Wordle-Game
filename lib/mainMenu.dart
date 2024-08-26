import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yazlabkelimeoyunu/Helpers/screen.dart';
import 'package:yazlabkelimeoyunu/WordGame.dart';
import 'package:yazlabkelimeoyunu/constantWordGame.dart';
import 'package:yazlabkelimeoyunu/main.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> with TickerProviderStateMixin {
  late AnimationController _topContainerController;
  late AnimationController _bottomContainerController;
  late Animation<double> _topContainerAnimation;
  late Animation<double> _bottomContainerAnimation;

  @override
  void initState() {
    super.initState();
    _topContainerController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _bottomContainerController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _topContainerAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_topContainerController)
          ..addListener(() {
            setState(() {});
          });
    _bottomContainerAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_bottomContainerController)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  void dispose() {
    _topContainerController.dispose();
    _bottomContainerController.dispose();
    super.dispose();
  }

  void _onTopContainerTap() {
    if (_bottomContainerController.isCompleted) {
      _bottomContainerController.reverse();
    }
    _topContainerController.forward().then((_) {
      // Animasyon tamamlandıktan sonra WordGame sayfasına yönlendir
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConstantWordGame()),
      );
    });
  }

  void _onBottomContainerTap() {
    if (_topContainerController.isCompleted) {
      _topContainerController.reverse();
    }
    _bottomContainerController.forward().then((_) {
      // Animasyon tamamlandıktan sonra WordGame sayfasına yönlendir
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WordGame()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtilities sc = ScreenUtilities(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                );
              },
              icon: Icon(Icons.start))
        ],
        backgroundColor: Colors.white,
        foregroundColor: Color.fromARGB(223, 0, 0, 0),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: _onTopContainerTap,
            child: Transform.translate(
              offset: Offset(0.0, -100.0 * _topContainerAnimation.value),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: sc.width * 0.95,
                  height: sc.height * 0.4,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(223, 83, 141, 216),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(50.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: sc.height * 0.25),
                    child: Text(
                      "Word Game With \nLetter Constant",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: sc.height * 0.04,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: _onBottomContainerTap,
            child: Transform.translate(
              offset: Offset(0.0, 100.0 * _bottomContainerAnimation.value),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: sc.width * 0.95,
                  height: sc.height * 0.4,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(223, 83, 141, 216),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(50.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Text(
                      "Word \nGame",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: sc.height * 0.05,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
