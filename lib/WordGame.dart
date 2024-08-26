import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yazlabkelimeoyunu/Helpers/screen.dart';
import 'package:yazlabkelimeoyunu/channels.dart';
import 'package:yazlabkelimeoyunu/db.dart';
import 'package:yazlabkelimeoyunu/user.dart';

class WordGame extends StatefulWidget {
  const WordGame({super.key});

  @override
  _WordGameState createState() => _WordGameState();
}

class _WordGameState extends State<WordGame> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    ScreenUtilities sc = ScreenUtilities(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 127, 205, 239),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 127, 205, 239),
      ),
      body: FutureBuilder<Player>(
          future: getUserName(FirebaseAuth.instance.currentUser?.uid ?? ''),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      children: <Widget>[
                        buildPage(sc, '4 Harfli ', 'assets/esin4.png',
                            'Kısa ama etkili!','4LetterNotConstant', "4", snapshot.data!),
                        buildPage(sc, '5 Harfli ', 'assets/esin5.png',
                            'Sınırsız eğlence!','5LetterNotConstant',"5", snapshot.data!),
                        buildPage(sc, '6 Harfli ', 'assets/esin6.png',
                            'Sonsuz keşif!','6LetterNotConstant',"6", snapshot.data!),
                        buildPage(sc, '7 Harfli ', 'assets/esin7.png',
                            'Büyük heyecan!','7LetterNotConstant',"7", snapshot.data!, ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: DotsIndicator(
                        controller: _pageController, itemCount: 4),
                  ),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  Widget buildPage(
      ScreenUtilities sc, String text, String imagePath, String text2, String channelName, String channelId, Player player) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(200.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment
              .end, // Widget'ları dikey olarak alt tarafa hizala
          children: [
            SizedBox(
              height: sc.height * 0.02,
            ),
            Text(text,
                style: TextStyle(
                    fontSize: sc.height * 0.07,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(2.0, 2.0),
                      ),
                    ])),
            SizedBox(
              height: sc.height * 0.01,
            ),
            Text(text2,
                style: TextStyle(
                  fontSize: sc.height * 0.035,
                  fontWeight: FontWeight.normal,
                  shadows: [
                    Shadow(
                      blurRadius: 5.0,
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                )),
            Spacer(),
            Container(
              width: sc.width * 0.3,
              child: ElevatedButton(
                  onPressed: () {
                    enterChannel(player, channelId);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Channels(channelName: channelName, player: player,)));
                  },
                  child: Row(
                    children: [
                      Icon(Icons.play_arrow),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        "Başla",
                        style: TextStyle(fontSize: sc.height * 0.02),
                      )
                    ],
                  )),
            ),
            Spacer(), // Üstte maksimum boşluk bırakır, böylece resim altta kalır.
            Image.asset(imagePath,
                width:
                    sc.width * 0.85), // Resmin genişliği burada ayarlanabilir.
            SizedBox(
                height: sc.height *
                    0.08), // Resim ile alttaki noktalar arasında boşluk bırakır.
          ],
        ),
      ),
    );
  }

  Future<void> enterChannel(Player player, String channelId) async {
    try {
      // Kullanıcının bilgilerini users koleksiyonundan çek

        // Kullanıcı bilgilerini yeni koleksiyona yaz
        await FirebaseFirestore.instance.collection(channelId + 'LetterNotConstant').doc(player.id).set({
          "username": player.username});
    } catch (e) {
      print("Hata: $e");
    }
  }
}

class DotsIndicator extends AnimatedWidget {
  final PageController controller;
  final int itemCount;
  final Color color;

  DotsIndicator({
    required this.controller,
    required this.itemCount,
    this.color = const Color.fromARGB(255, 26, 56, 97),
  }) : super(listenable: controller);

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 15.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? color : color.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> indicators =
        List<Widget>.generate(itemCount, (int index) {
      return _indicator(
          index == (controller.page ?? controller.initialPage).round());
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: indicators,
    );
  }


}
