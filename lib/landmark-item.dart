import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:landmark_recognition/details_page.dart';
import 'package:landmark_recognition/models/hitory-landmark.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class LandmarkItem extends StatelessWidget {
  HistoryLandmark _landmark;
  BuildContext contx;
  Function _deleteItem;
  // Function _navigateToLocation;
  Codec<String, String> stringToBase64 = utf8.fuse(base64);


  LandmarkItem(this._landmark, this.contx, this._deleteItem);

  void cardTapped(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailsPage(mid: _landmark.mid)));
  }

  void itemDeleted() {
    print('Item deleted');
  }

  Image getImage(String bytes) {
    print(base64Decode(_landmark.image));
    return Image.memory(base64Decode(_landmark.image));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {/*open details here*/},

      child: Dismissible(
        key: ValueKey<String>(_landmark.dateTime.toString()),
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
              trailing: Icon(Icons.info_outline, size: 30,),
              onTap: () => cardTapped(context),
            ),
          ),
        ),
      )
    );
  }
}
