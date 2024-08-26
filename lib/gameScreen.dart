import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<TextEditingController> controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  List<FocusNode> focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );
  bool isWordValid = false;

  void focusOnField(int index) {
    if (index < 0 || index >= focusNodes.length) return;
    FocusScope.of(context).requestFocus(focusNodes[index]);
  }

  @override
  Widget build(BuildContext context) {
    double boxSize = 50.0;
    double containerWidth = boxSize * 10;
    double containerHeight = boxSize * 4;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 233, 233, 233),
      appBar: AppBar(
        title: Text(
          'Enter your word to your opponent',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.normal,
            shadows: [Shadow(color: Colors.grey, blurRadius: 2)],
          ),
        ),
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
          // Geri tuşuna basıldığında yapılacak işlemler
        }),
        backgroundColor: Color.fromARGB(255, 177, 206, 230),
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.15,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Positioned(
                    top: containerHeight *
                        0.7, // Kutunun yüksekliğinin %70'i kadar aşağıda
                    left: containerWidth *
                        0.3, // Kutunun genişliğinin %30'u kadar sağda
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Opponent Word',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0, // Yazı boyutu büyütüldü
                            fontWeight: FontWeight.bold, // Yazı kalınlaştırıldı
                            shadows: [
                              BoxShadow(color: Colors.grey, blurRadius: 2)
                            ], // Gölge eklendi
                          ),
                        ),
                        SizedBox(height: 4.0), // Yazı ile simge arasındaki boşluk
                        Container(
                          width:
                              60.0, // Simge için biraz daha genişlik ekleyebilirsiniz
                          height:
                              60.0, // Simge için biraz daha yükseklik ekleyebilirsiniz
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/monster3.gif'), // Simgeyi ayarla
                            radius: 30.0, // Simge boyutu
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.0), // Resim ile mavi kutu arasındaki boşluk
                  Center(
                    child: Container(
                      width: containerWidth * 0.7,
                      height: containerHeight,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 177, 206, 230),
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(40.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for (int i = 0; i < 4; i++)
                              Container(
                                width: boxSize,
                                height: boxSize,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 233, 233, 233),
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  focusNode: focusNodes[i],
                                  maxLength: 1,
                                  onChanged: (value) {
                                    setState(() {
                                      isWordValid = controllers.every((controller) =>
                                          controller.text.length == 1);
                                    });
                                    if (value.length == 1 && i < 3) {
                                      focusOnField(i + 1);
                                    } else if (value.isEmpty && i > 0) {
                                      focusOnField(i - 1);
                                      controllers[i].clear();
                                    }
                                  },
                                  textAlign: TextAlign.center,
                                  controller: controllers[i],
                                  keyboardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.characters,
                                  decoration: InputDecoration(
                                    counterText: '',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0), // Kutucuklar ve buton arasındaki boşluk
                  ElevatedButton(
                    onPressed: isWordValid ? () {} : null,
                    child: Text('Onayla', style: TextStyle(color: Colors.black),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 177, 206, 230),

                      elevation: 5,
                      shadowColor:
                          Color.fromARGB(255, 139, 207, 226).withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        side: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}
