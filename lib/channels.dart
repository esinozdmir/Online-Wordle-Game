import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yazlabkelimeoyunu/Components/countdownTimer.dart';
import 'package:yazlabkelimeoyunu/Components/customAlert.dart';
import 'package:yazlabkelimeoyunu/db.dart';
import 'package:yazlabkelimeoyunu/gameScreen.dart';
import 'package:yazlabkelimeoyunu/user.dart';

class Channels extends StatefulWidget {
  final String channelName;
  final Player player;

  const Channels({Key? key, required this.channelName, required this.player})
      : super(key: key);

  @override
  _ChannelsState createState() => _ChannelsState();
}

class _ChannelsState extends State<Channels> {
  late CollectionReference usersCollection;
  bool isAccepted = false;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    usersCollection = FirebaseFirestore.instance.collection(widget.channelName);
    // Listen requests when the widget is initialized
    listenRequests(widget.player.id);
    timer = Timer.periodic(
        Duration(seconds: 30), (Timer t) => checkAndUpdateTimeOutRequests());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Users in ${widget.channelName} Channel',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.normal,
            shadows: [Shadow(color: Colors.grey, blurRadius: 2)],
          ),
        ),
        backgroundColor: Color.fromARGB(255, 177, 206, 230),
        leading: BackButton(onPressed: () {
          exitChannel(widget.player, widget.channelName);
          Navigator.pop(context);
        }),
        elevation: 5,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          List<String> userList = [];
          List<String> userIdList = [];
          for (var doc in documents) {
            final username = doc['username'];
            final id = doc.id;
            if (username != widget.player.username) {
              userList.add(username);
              userIdList.add(id);
            }
          }

          return ListView.builder(
            itemCount: userList.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(20.0), // Yuvarlak kenarlık
                      color: Color.fromARGB(255, 177, 206, 230),
                      border: Border.all(color: Colors.black), // Siyah çerçeve
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    padding: EdgeInsets.all(26.0),
                    child: Row(
                      children: [
                        Icon(Icons.account_circle), // Kullanıcı simgesi
                        SizedBox(
                            width:
                                8), // İkon ile kullanıcı adı arasında boşluk bırakır
                        Text(
                          widget.player.username,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 3.0,
                                color: Colors.grey,
                                offset: Offset(1.0, 1.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(20.0), // Yuvarlak kenarlık
                    color: Color.fromARGB(255, 177, 206, 230),
                    border: Border.all(color: Colors.black), // Siyah çerçeve
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          userList[index - 1],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 3.0,
                                color: Colors.grey,
                                offset: Offset(1.0, 1.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Request to ${userList[index - 1]}'),
                              content: Text(
                                  'Do you want to send a request to ${userList[index - 1]}?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    // Send request and start timer
                                    sendRequestAndStartTimer(widget.player.id,
                                        userIdList[index - 1]);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Send Request'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text('Send Request'),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  Future<void> exitChannel(Player player, String channelId) async {
    try {
      await FirebaseFirestore.instance
          .collection(channelId)
          .doc(player.id)
          .delete();
    } catch (e) {
      print("Error: $e");
    }
  }

  void listenRequests(String userId) {
    FirebaseFirestore.instance
        .collection('requests')
        .where('receiverId', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.added) {
          Map<String, dynamic> requestData =
              change.doc.data() as Map<String, dynamic>;
          String senderId = requestData['senderId'];
          String requestId = change.doc.id;
          // Show request dialog when a new request is added
          if (requestData['status'] == 'pending') {
            showRequestDialog(senderId, requestId);
          }
        }
      });
    });
  }

  void showRequestDialog(String senderId, String requestId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(senderId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        String senderName = documentSnapshot.get('username');
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Game Request from $senderName'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Do you want to accept the game request?'),
                    SizedBox(height: 20),
                    CountdownTimer(
                      duration: Duration(seconds: 10),
                      onCompleted: () {
                        // Geri sayım tamamlandığında çalışacak olan kod
                        Navigator.of(context).pop();
                        //rejectRequest(requestId, context);
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      //Navigator.of(context).pop();
                      acceptRequest(requestId);
                    },
                    child: Text('Accept'),
                  ),
                  TextButton(
                    onPressed: () {
                      //Navigator.of(context).pop();
                      rejectRequest(requestId, context);
                    },
                    child: Text('Reject'),
                  ),
                ],
              );
            });
      } else {
        print('Document does not exist on the database');
      }
    }).catchError((error) {
      print('Error getting document: $error');
    });
  }

  void acceptRequest(String requestId) {
    Navigator.pop(context);
    FirebaseFirestore.instance
        .collection("requests")
        .doc(requestId)
        .update({"status": "accepted"});
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => GameScreen()));
    setState(() {
      isAccepted = true;
    });
  }

  void rejectRequest(String requestId, BuildContext context) {
    FirebaseFirestore.instance
        .collection("requests")
        .doc(requestId)
        .update({"status": "rejected"});
    Navigator.pop(context);
  }

  void sendRequestAndStartTimer(String senderId, String receiverId) {
    // Send request
    sendRequest(senderId, receiverId);
  }

  void deleteRequest(String senderId, String receiverId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('senderId', isEqualTo: senderId)
          .where('receiverId', isEqualTo: receiverId)
          .get();

      querySnapshot.docs.forEach((doc) {
        doc.reference.update({"status": "timedout"});
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void dispose() {
    // Cancel timer when the widget is disposed
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkAndUpdateTimeOutRequests() async {
    const timeOutDuration = Duration(seconds: 10);
    final now = Timestamp.now();
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('status', isEqualTo: 'pending')
          .get();

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        Timestamp timestamp = data['timestamp'];
        String status = data['status'];

        if (status == 'accepted') {
          // Eğer istek zaten kabul edilmişse, zaman aşımını kontrol etmeyin
          continue;
        }

        if (now.seconds - timestamp.seconds > timeOutDuration.inSeconds) {
          // Zaman aşımına uğramış ve henüz kabul edilmemiş istekleri güncelleyin
          doc.reference.update({"status": "timedout"});
        }
      }
    } catch (e) {
      print("Error checking time out requests: $e");
    }
  }
}
