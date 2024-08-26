import 'package:flutter/material.dart';

class ScreenUtilities {

  var width;
  var height;

  ScreenUtilities(BuildContext context){
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }
}
