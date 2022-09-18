import 'dart:convert';
import 'dart:io' as Io;

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:landmark_recognition/landmark_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:landmark_recognition/models/landmark.dart';
import 'package:uuid/uuid.dart';

import 'models/hitory-landmark.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription>? cameras;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with TickerProviderStateMixin{
  late CameraController _cameraController;
  bool _isRearCameraSelected = true;
  User? loggedInUser = FirebaseAuth.instance.currentUser;
  final DatabaseReference? _dbRef = FirebaseDatabase.instance.ref();
  final uuid = const Uuid();
  bool isLandmarkLoading = false;

  // Whether or not the rectangle is displayed
  bool _isRectangleVisible = false;
  var description = "";

  late AnimationController loadingController;

  // Holds the position information of the rectangle
  Map<String, List> _position = {
    'a': [0, 0],
    'b': [0, 0],
    'c': [0, 0],
    'd': [0, 0],
  };

  @override
  void dispose() {
    _cameraController.dispose();
    loadingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initCamera(widget.cameras![0]);
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
      setState(() {});
    });
    loadingController.repeat(reverse: false);
  }

  void saveLandmark(Landmark landmark, String image) {
    _dbRef?.child(loggedInUser!.uid).child(uuid.v1()).set(<String, Object>{
      "mid": landmark.mid,
      "description": landmark.description,
      "image": image,
      "dateTime": DateTime.now().toString()
    });
  }

  Future takePicture() async {
    setState(() {
      isLandmarkLoading = true;
    });
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      XFile picture = await _cameraController.takePicture();
      var decodedImage = await decodeImageFromList(Io.File(picture.path).readAsBytesSync());
      print('hereherehere');
      print(decodedImage.width);
      print(decodedImage.height);
      final bytes = Io.File(picture.path).readAsBytesSync();
      String bytesString = base64Encode(bytes);

      final landmark = await LandmarkRepository().getLandmarkInfo(bytesString);
      if (landmark != null) {
        updateRectanglePosition(landmark.boundingPoly.vertices);
        description = landmark.description;

        if (loggedInUser != null) {
          saveLandmark(landmark, bytesString);
        }
      }
      else {
        double position = (MediaQuery.of(context).size.height * 0.25).toDouble();
        var snackBar = SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: position),
          content: Text('The landmark was not recognized'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      // print(landmark.locations);
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) => PreviewPage(
      //                 picture: picture,
      //               )));
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
    finally {
      setState(() {
        isLandmarkLoading = false;
      });
    }
  }

  // Some logic to get the rectangle values
  void updateRectanglePosition(vertices) {
    setState(() {
      // assign new position
      _position = {
        'a': [vertices[0].x.toDouble(), vertices[0].y.toDouble()],
        //.x.toDouble(), // mala (vertices[0].x.toDouble() / 1000) * ((MediaQuery.of(context).size.width)),
        'b': [vertices[1].x.toDouble(), vertices[1].y.toDouble()],
        //.y.toDouble(), // mala (vertices[0].y.toDouble() / 1000) * ((MediaQuery.of(context).size.height * 0.80)), //* 0.80,
        'c': [vertices[2].x.toDouble(), vertices[2].y.toDouble()],
        //.x.toDouble(), // golema (vertices[1].x.toDouble() / 1000) * ((MediaQuery.of(context).size.width)), // - vertices[0].x.toDouble(),
        'd': [vertices[3].x.toDouble(), vertices[3].y.toDouble()],
        //.y.toDouble(), // golema (vertices[2].y.toDouble() / 1000) * ((MediaQuery.of(context).size.height * 0.80)), //* 0.80 - vertices[0].y.toDouble()* 0.80,
      };
      _isRectangleVisible = true;
    });
  }

  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("-----------------------------------------------------");
    print(MediaQuery.of(context).size.height);
    print(MediaQuery.of(context).size.width);
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        (_cameraController.value.isInitialized)
            ? Container(
                height: MediaQuery.of(context).size.height * 0.80,
                child: AspectRatio(
                  aspectRatio: _cameraController.value.aspectRatio,
                  child: CameraPreview(_cameraController),
                ),
              )
            : Container(
                color: Colors.black,
                child: const Center(child: CircularProgressIndicator())),
        if (_isRectangleVisible)
          Positioned(
            // color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.80,
            child: CustomPaint(
              painter: RectanglePainter(
                  _position,
                  description,
                  MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height * 0.80),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _isRectangleVisible = false;
                  });
                },
                onDoubleTap: () {
                  setState(() {
                    _isRectangleVisible = false;
                  });
                },
              ),
            ),
          ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.20,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  color: Colors.grey),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                    child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 30,
                  icon: Icon(
                      _isRearCameraSelected
                          ? CupertinoIcons.switch_camera
                          : CupertinoIcons.switch_camera_solid,
                      color: Colors.white),
                  onPressed: () {
                    setState(
                        () => _isRearCameraSelected = !_isRearCameraSelected);
                    initCamera(widget.cameras![_isRearCameraSelected ? 0 : 1]);
                  },
                )),
                    isLandmarkLoading ?
                    CircularProgressIndicator(
                      value: loadingController.value,
                      color: Colors.grey[700],
                      semanticsLabel: 'Circular progress indicator',
                    )
                        :
                Expanded(
                    child: IconButton(
                  onPressed: takePicture,
                  iconSize: 50,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.circle, color: Colors.white),
                )),
                const Spacer(),
              ]),
            )),
      ]),
    ));
  }
}

class RectanglePainter extends CustomPainter {
  final Map<String, List> pos;
  final String desc;
  final double width;
  final double height;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    print("krajjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj");
    print(size.width);
    print(this.pos);

    canvas.drawPath(
        Path()
          ..addPolygon([
            // Offset(
            //     pos['a']![0], pos['a']![1]),
            // Offset(
            //     pos['b']![0], pos['b']![1]),
            // Offset(
            //     pos['c']![0], pos['c']![1]),
            // Offset(
            //     pos['d']![0], pos['d']![1]),
            Offset(
                (pos['a']![0] / 1000) * width, (pos['a']![1] / 1000) * height),
            Offset(
                (pos['b']![0] / 1000) * width, (pos['b']![1] / 1000) * height),
            Offset(
                (pos['c']![0] / 1000) * width, (pos['c']![1] / 1000) * height),
            Offset(
                (pos['d']![0] / 1000) * width, (pos['d']![1] / 1000) * height),
          ], true),
        paint);

    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 10,
    );
    final textSpan = TextSpan(
      text: desc,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final offset = Offset(
        (pos['a']![0] / 1000) * width, (pos['a']![1] / 1000) * height - 5);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  RectanglePainter(this.pos, this.desc, this.width, this.height);
}
