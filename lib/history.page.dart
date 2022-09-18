import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:landmark_recognition/landmark-list.dart';
import 'package:landmark_recognition/models/hitory-landmark.dart';
import 'package:landmark_recognition/models/landmark.dart';
import 'package:landmark_recognition/models/landmark_screen_location.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _HistoryPageState();
  }
}

class _HistoryPageState extends State<HistoryPage> with TickerProviderStateMixin {
  User? loggedInUser = FirebaseAuth.instance.currentUser;
  DatabaseReference? _dbRef = FirebaseDatabase.instance.ref();
  List<HistoryLandmark> historyLandmarks = [];
  // FirebaseAuth auth = FirebaseAuth.instance;
  //
  bool isEnabling = false;
  late AnimationController loadingController;

  @override
  void initState() {
    // TODO: implement initState
    initDb();
    super.initState();
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
      setState(() {});
    });
    loadingController.repeat(reverse: false);
  }

  void initDb() {
    if (loggedInUser == null) {
      return;
    }
    _dbRef?.child(loggedInUser!.uid).onValue.listen((DatabaseEvent event) {
      List<HistoryLandmark> tmpLandmarks = [];
      print('objects');
      for (final child in event.snapshot.children) {
        if (child.exists) {
          Map<Object?, Object?> historyData =
          child.value as Map<Object?, Object?>;
          HistoryLandmark historyLandmark = HistoryLandmark(child.key!, historyData['mid'].toString(),
              historyData['description'].toString(), historyData['image'].toString(), DateTime.parse(historyData['dateTime'].toString()));

          tmpLandmarks.add(historyLandmark);
        }
      }

      if (this.mounted) {
        setState(() {
          print('setstate');
          historyLandmarks = tmpLandmarks;
        });
      }
    });
  }



  Future<void> _signIn() async {
    setState(() {
      isEnabling = true;
    });
    print('sign in');
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      setState(() {
        loggedInUser = userCredential.user;
        initDb();
      });
      print("Signed in with temporary account.");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
    }
    finally {
      setState(() {
        isEnabling = true;
      });
    }
  }

  void deleteItem(String id) {
    print('delete item ' + id);
    if(loggedInUser != null) {
      _dbRef?.child(loggedInUser!.uid).child(id).remove();
    }
  }


  @override
  Widget build(BuildContext context) {
    print(loggedInUser);
    return loggedInUser != null ?
    LandmarkList(historyLandmarks, deleteItem)
    :
      Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(child:
              Text(
                'Enable History to track all landmarks you have visited',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              ),
            ],
          ),

          SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isEnabling ?
              CircularProgressIndicator(
                value: loadingController.value,
                color: Colors.grey[700],
                semanticsLabel: 'Circular progress indicator',
              )
                  :
              ElevatedButton(
                onPressed: _signIn,
                child: Text('Enable'),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    loadingController.dispose();
    super.dispose();
  }
}