import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:landmark_recognition/landmark-item.dart';
import 'package:landmark_recognition/models/hitory-landmark.dart';
import 'package:landmark_recognition/models/landmark.dart';


class LandmarkList extends StatelessWidget {
  List<HistoryLandmark> landmarks;
  Function _deleteItem;
  // Function _navigateToLocation;

  LandmarkList(this.landmarks, this._deleteItem);

  @override
  Widget build(BuildContext context) {
    return landmarks.length == 0 ?
    Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No history',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        )
    ) :
    ListView.builder(
        itemCount: landmarks.length,
        itemBuilder: (contx, index) {
          return LandmarkItem(landmarks[index], contx, _deleteItem);
        }
    );
  }
}
