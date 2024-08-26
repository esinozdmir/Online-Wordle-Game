import 'package:flutter/material.dart';

class ConstantWordGame extends StatefulWidget {
  const ConstantWordGame({ Key? key }) : super(key: key);

  @override
  _ConstantWordGameState createState() => _ConstantWordGameState();
}

class _ConstantWordGameState extends State<ConstantWordGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text("constant word game"),
    );
  }
}
