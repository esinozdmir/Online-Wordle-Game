import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yazlabkelimeoyunu/Components/customAlert.dart';
import 'package:yazlabkelimeoyunu/Components/customTextfield.dart';
import 'package:yazlabkelimeoyunu/Helpers/screen.dart';
import 'package:yazlabkelimeoyunu/db.dart';
import 'package:yazlabkelimeoyunu/loginScreen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with AutomaticKeepAliveClientMixin {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  @override
  bool get wantKeepAlive => true; // Durumu korumak istediğinizi belirtin

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();

  @override
  void dispose() {
    // Controller'ları bellekten temizle
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtilities sc = new ScreenUtilities(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 177, 206, 230),
      ),
      backgroundColor: Color.fromARGB(255, 177, 206, 230),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: sc.height * 0.06),
              Text(
                'JOIN US!',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: sc.height * 0.08),
              customTextfield("Username", 20.0, Icons.person, Colors.white54,
                  false, _usernameController),
              SizedBox(height: 20.0),
              customTextfield("Email", 20.0, Icons.email, Colors.white54, false,
                  _emailController),
              SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.black),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.2), // Siyah gölge rengi, opaklık 0.2
                      spreadRadius: 1, // Gölgenin yayılma yarıçapı
                      blurRadius: 5, // Gölgenin bulanıklık yarıçapı
                      offset: Offset(0,
                          2), // Gölgenin pozisyonu, burada yukarı doğru (0, 2)
                    ),
                  ],
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword, // Şifreyi gizleme durumu
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none, // Sınır yok
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        //color: Colors.white54,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword =
                              !_obscurePassword; // Şifre görünürlüğünü değiştir
                        });
                      },
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 20.0),
              // Şifre tekrarı alanı için
              Container(
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.black),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.2), // Siyah gölge rengi, opaklık 0.2
                      spreadRadius: 1, // Gölgenin yayılma yarıçapı
                      blurRadius: 5, // Gölgenin bulanıklık yarıçapı
                      offset: Offset(0,
                          2), // Gölgenin pozisyonu, burada yukarı doğru (0, 2)
                    ),
                  ],
                ),
                child: TextField(
                  controller: _cpasswordController,
                  obscureText:
                      _obscureConfirmPassword, // Şifreyi gizleme durumu
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    prefixIcon: Icon(
                      Icons.lock,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none, // Sınır yok
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        //color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword =
                              !_obscureConfirmPassword; // Şifre görünürlüğünü değiştir
                        });
                      },
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 60.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_passwordController.text != _cpasswordController.text) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomAlertDialog(
                            icon: Icons.dangerous,
                            title: Text('Passwords Dont Match'),
                            content: Text('Check the passwords and try again.'),
                            senderName: Text(""),
                            cancelButtonText: 'Not now',
                            allowButtonText: 'Allow',
                            onCancel: () {
                              Navigator.of(context).pop();
                            },
                            onAllow: () {
                              // İzin verildiğinde yapılacak işlemler
                            },
                          );
                        },
                        );
                    } else {
                      // Şifreler eşleşiyorsa createUser fonksiyonunu çağır
                      createUser(_emailController.text,
                          _passwordController.text, _usernameController.text);

                      // Kullanıcıyı giriş sayfasına yönlendir
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LoginScreen()), // LoginPage yerine yönlendirmek istediğiniz sayfa gelmeli
                      );

                      // Toast mesajı gösterme
                      Fluttertoast.showToast(
                        msg: "Başarıyla kayıt oldunuz. Lütfen giriş yapın.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 0, 0, 0),
                    minimumSize: Size(sc.width * 0.40, 50),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
