import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:landmark_recognition/models/hitory-landmark.dart';
import 'package:landmark_recognition/models/landmark.dart';
import 'package:intl/intl.dart';

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
                        Navigator.of(context).pop(false);
                      },
                      child: const Text('no'),
                    ),
                    TextButton(
                      onPressed: () {
                        _deleteItem(_landmark.id);
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                );
              });
        },
        child: Card(
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(contx).primaryColorLight,
                  width: 2,
                )),
            child: ListTile(
              title: Text(
                _landmark.description,
                style: TextStyle(
                  fontSize: 30,
                  color: Theme.of(contx).primaryColorDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                DateFormat('dd-MM-yyyy – kk:mm').format(_landmark.dateTime),
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(contx).primaryColor,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () =>
                {
                  /*delete here*/
                },
              ),
            ), // Column(
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
