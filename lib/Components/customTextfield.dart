import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
Widget customTextfield(
    String text, double radius, IconData icon, Color color, bool pass, TextEditingController controller) {
  return Container(
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: Colors.black),
      boxShadow: [
        BoxShadow(
          color:
              Colors.black.withOpacity(0.2), // Siyah gölge rengi, opaklık 0.2
          spreadRadius: 1, // Gölgenin yayılma yarıçapı
          blurRadius: 5, // Gölgenin bulanıklık yarıçapı
          offset:
              Offset(0, 2), // Gölgenin pozisyonu, burada yukarı doğru (0, 2)
        ),
      ],
    ),
    child: TextField(
      controller: controller,
      obscureText: pass,
      decoration: InputDecoration(
        labelText: text,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide.none, // Sınır yok
        ),
      ),
    ),
  );
}
