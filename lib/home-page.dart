import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'camera_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(child:
              Text(
                'Open your camera, point it to a landmark and see what landmark it is!',
                style: TextStyle(
                  fontSize: 28.0,
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
              ElevatedButton(
                  onPressed: () async {
                    await availableCameras().then((value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CameraPage(cameras: value))));
                  },
                  child: Row(
                    children: [
                      Text('Try It'),
                      Icon(Icons.camera_alt_sharp, size: 20.0),
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }
}
