import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yazlabkelimeoyunu/request.dart';
import 'package:yazlabkelimeoyunu/user.dart';

Future<void> createUser(String email, String password, String username) async {
  try {
    // Kullanıcıyı Firebase Auth ile oluştur
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Firestore'a kullanıcı bilgilerini ekle
    await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
      'username': username,
      'email': email,
    });
    print("user oluşturuldu!");
  } catch (e) {
    print(e); // Hata durumunda hata mesajını yazdır
  }
}

void sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print("Password reset email sent.");
      // Burada başarılı olduğuna dair kullanıcıya bir bildirim gösterebilirsiniz.
    } catch (e) {
      print("Error in sending password reset email: $e");
      // Hata durumunda kullanıcıya bir uyarı gösterin.
    }
  }

Future<User?> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  if (googleUser == null) {
    return null; // Kullanıcı giriş yapmayı iptal etti
  }

  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final OAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

  return userCredential.user;
}


Future<Player> getUserName(String userId) async {
  var userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
  if (userDoc.exists) {
    return Player(userId, userDoc.data()!['username']);
  } else {
    return Player("1", "İsimsiz Kullanıcı");
  }
}


Future<void> sendRequest(String senderId, String receiverId) async {
  try {
    // Firestore'daki "requests" koleksiyonuna yeni bir belge ekleyin
    await FirebaseFirestore.instance.collection('requests').add({
      'senderId': senderId, // İsteği gönderen kullanıcının ID'si
      'receiverId': receiverId, // İsteğin gönderildiği kullanıcının ID'si
      'status': 'pending', // İsteğin durumu (beklemede, kabul edildi, reddedildi vb.)
      'timestamp': FieldValue.serverTimestamp(), // Belgenin oluşturulduğu tarih ve zaman
    });
    print('Request sent successfully!');
  } catch (e) {
    print('Error sending request: $e');
  }
}
