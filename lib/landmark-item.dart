import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:landmark_recognition/models/hitory-landmark.dart';
import 'package:landmark_recognition/models/landmark.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class LandmarkItem extends StatelessWidget {
  HistoryLandmark _landmark;
  BuildContext contx;
  Function _deleteItem;
  // Function _navigateToLocation;

  LandmarkItem(this._landmark, this.contx, this._deleteItem);

  void cardTapped() {
    print('Card tapped');
  }

  void itemDeleted() {
    print('Item deleted');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {/*open details here*/},

      child: Dismissible(
        key: ValueKey<String>(_landmark.mid),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          color: Colors.red,
          child: Container(
            margin: EdgeInsets.only(right: 25.0),
            child: Icon(
                Icons.delete,
                size: 30.0,
                color: Colors.white,
            ),
          )
        ),
        onDismissed: (direction) {
          print(direction);
        },
        confirmDismiss: (direction) {
          return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Delete confirmation'),
                  content: const Text('Are you sure you want to delete this landmark?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        _deleteItem(_landmark.id);
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text('No'),
                    ),
                  ],
                );
              });
        },
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(contx).primaryColorLight,
                  width: 2,
                )),
            child:
            // Column(
            //   children: [
            //     Row(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: <Widget>[
            //         Expanded(
            //           flex: 2,
            //           child: Text(
            //             _landmark.description,
            //             style: TextStyle(
            //               fontSize: 25,
            //               color: Theme.of(contx).primaryColorDark,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //         ),
            //
            //         Image.memory(base64Decode(_landmark.image), height: 120,),
            //       ],
            //     ),
            //     Row(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: <Widget>[
            //         Expanded(
            //           flex: 2,
            //           child: Text(
            //                 DateFormat('dd-MM-yyyy – kk:mm').format(_landmark.dateTime),
            //                 style: TextStyle(
            //                   fontSize: 18,
            //                   color: Theme.of(contx).primaryColor,
            //                 ),
            //               ),
            //         ),
            //       ],
            //     )
            //   ],
            // )
            ListTile(
              title: Text(
                _landmark.description,
                style: TextStyle(
                  fontSize: 25,
                  color: Theme.of(contx).primaryColorDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                DateFormat('dd-MM-yyyy – kk:mm').format(_landmark.dateTime),
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(contx).primaryColor,
                ),
              ),
              trailing: Image.memory(base64Decode(_landmark.image)),
            ),
            //   children: [
            //     Text(
            //       _course.name,
            //       style: TextStyle(
            //         fontSize: 30,
            //         color: Theme.of(contx).primaryColorDark,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     Text(
            //       DateFormat('yyyy-MM-dd – kk:mm').format(_course.dateTime),
            //       style: TextStyle(
            //         fontSize: 20,
            //         color: Theme.of(contx).primaryColor,
            //       ),
            //     ),
            //     trai
            //   ],
            // )
          ),
        ),
      )
    );
  }
}
