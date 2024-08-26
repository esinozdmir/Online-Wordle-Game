import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final IconData icon;
  final Text title;
  final Text content;
  final String cancelButtonText;
  final String allowButtonText;
  final VoidCallback onCancel;
  final VoidCallback onAllow;
  final Text senderName;

  CustomAlertDialog({
    required this.icon,
    required this.title,
    required this.content,
    required this.cancelButtonText,
    required this.allowButtonText,
    required this.onCancel,
    required this.onAllow,
    required this.senderName,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Icon(icon, size: height * 0.2,),
      content: Container(
        width: width * 0.8,
        height: height * 0.15,
        child: Column(
          children: [
            title,
            content,
            senderName,
          ],
        ),
      ),
      actions: <Widget>[
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                child: Text(cancelButtonText),
                onPressed: onCancel,
              ),
              TextButton(
                child: Text(allowButtonText),
                onPressed: onAllow,
              ),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
