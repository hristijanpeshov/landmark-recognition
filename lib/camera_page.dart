import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:landmark_recognition/landmark_repository.dart';
import 'package:landmark_recognition/preview-page.dart';
import 'dart:io' as Io;
import 'dart:convert';
import 'dart:typed_data';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription>? cameras;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  bool _isRearCameraSelected = true;

  // Whether or not the rectangle is displayed
  bool _isRectangleVisible = false;
  var description = "";

  // Holds the position information of the rectangle
  Map<String, double> _position = {
    'x1': 0,
    'y1': 0,
    'x2': 0,
    'y2': 0,
  };

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initCamera(widget.cameras![0]);
  }

  Future takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      XFile picture = await _cameraController.takePicture();
      final bytes = Io.File(picture.path).readAsBytesSync();
      String bytesString = base64Encode(bytes);

      final landmark = await LandmarkRepository().getLandmarkInfo(bytesString);
      if (landmark != null) {
        updateRectanglePosition(landmark.boundingPoly.vertices);
        description = landmark.description;
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
  }


  // Some logic to get the rectangle values
  void updateRectanglePosition(vertices) {
    setState(() {
      // assign new position
      _position = {
        'x1': vertices[0].x.toDouble(), // mala (vertices[0].x.toDouble() / 1000) * ((MediaQuery.of(context).size.width)),
        'y1': vertices[0].y.toDouble(), // mala (vertices[0].y.toDouble() / 1000) * ((MediaQuery.of(context).size.height * 0.80)), //* 0.80,
        'x2': vertices[1].x.toDouble(), // golema (vertices[1].x.toDouble() / 1000) * ((MediaQuery.of(context).size.width)), // - vertices[0].x.toDouble(),
        'y2': vertices[2].y.toDouble(), // golema (vertices[2].y.toDouble() / 1000) * ((MediaQuery.of(context).size.height * 0.80)), //* 0.80 - vertices[0].y.toDouble()* 0.80,
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
        // appBar: AppBar(
        //   elevation: 1,
        //   backgroundColor: Colors.grey,
        //   title: Row(
        //     children: const <Widget>[
        //       Icon(Icons.camera_alt),
        //       SizedBox(width: 5),
        //       Text("Camera frame"),
        //     ],
        //   ),
        // ),
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
                  painter: RectanglePainter(_position),
                  // child: Text(
                  //   "Custom Paint",
                  //   style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic),
                  // ),
                ),
              ),
            //  if (_isRectangleVisible)
            //   Positioned(
            //   // left: _position['x'],
            //   // top: _position['h'],
            //   // right: _position['w'],
            //   // bottom: _position['y'],
            //   child: Material( child: InkWell(
            //     onTap: () {
            //       setState(() {
            //         _isRectangleVisible = false;
            //       });
            //     },
            //     // child: Container(
            //     //   // width: 10, // _position['w'],
            //     //   // height: _position['h'],
            //     //   decoration: BoxDecoration(
            //     //     // backgroundBlendMode: Color.fromRGBO(24,233, 111, 0.6),
            //     //     // color: const Color.fromARGB(100, 22, 44, 33),
            //     //     border: Border.all(
            //     //       width: 2,
            //     //       color: Colors.blue,
            //     //     ),
            //     //   ),
            //     //   child: Align(
            //     //     alignment: Alignment.topLeft,
            //     //     child: Container(
            //     //       color: Colors.blue,
            //     //       child: Text(
            //     //         description,
            //     //         style: TextStyle(color: Colors.white),
            //     //       ),
            //     //     ),
            //     //   ),
            //     // ),
            //     child: CustomPaint(
            //
            //       painter: RectanglePainter(),
            //     // child: Text(
            //     //   "Custom Paint",
            //     //   style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic),
            //     // ),
            //   ),
            //   ),
            //   ),
            // ),
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

  // @override
  // Widget build(BuildContext context) {
  //   if (!_cameraController.value.isInitialized) {
  //     return Container();
  //   }
  //   return Stack(
  //     children: [
  //       AspectRatio(
  //         aspectRatio: _cameraController.value.aspectRatio,
  //         child: _cameraController == null ? Container() : CameraPreview(
  //             _cameraController),
  //       ),
  //       if (_isRectangleVisible)
  //         Positioned(
  //           left: _position['x'],
  //           top: _position['y'],
  //           child: Material( child: InkWell(
  //             onTap: () {
  //               // When the user taps on the rectangle, it will disappear
  //               setState(() {
  //                 _isRectangleVisible = false;
  //               });
  //             },
  //             child: Container(
  //               width: _position['w'],
  //               height: _position['h'],
  //               decoration: BoxDecoration(
  //                 border: Border.all(
  //                   width: 2,
  //                   color: Colors.blue,
  //                 ),
  //               ),
  //               child: Align(
  //                 alignment: Alignment.topLeft,
  //                 child: Container(
  //                   color: Colors.blue,
  //                   child: Text(
  //                     'hourse -71%',
  //                     style: TextStyle(color: Colors.white),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //         )],
  //   );
  // }

}

class RectanglePainter extends CustomPainter {

  final Map<String, double> pos;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    final a = Offset(size.width * 1 / 6, size.height * 1 / 4);
    final b = Offset(size.width * 5 / 6, size.height * 3 / 4);
    // final rect = Rect.fromLTRB(10, 10, 10, 10);//pos['x1']!, pos['y2']!, pos['x2']!, pos['y1']!);
    print("krajjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj");
    print(size.width);
    print(this.pos);

    // canvas.drawRect(rect, paint);
    var x1 = (pos['x1']! / 1000) * 360;
    var x2 = (pos['x2']! / 1000) * 360;
    var y1 = (pos['y1']! / 1000) * 732;
    var y2 = (pos['y2']! / 1000) * 732;
    // canvas.drawPath(
    //     Path()..addPolygon([
    //       Offset(pos['x1']!, pos['y1']!),
    //       Offset(pos['x1']!, pos['y2']!),
    //       Offset(pos['x2']!, pos['y1']!),
    //       Offset(pos['x2']!, pos['y2']!),
    //     ], true),
    //     paint);

    canvas.drawPath(
        Path()..addPolygon([
          Offset(x2, y1),
          Offset(x1, y1),
          Offset(x2, y2),
          Offset(x1, y2),
        ], true),
        paint);
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  RectanglePainter(this.pos);
}