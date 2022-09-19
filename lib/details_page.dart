import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:landmark_recognition/knowledge_graph.dart';
import 'package:landmark_recognition/models/landmark_details.dart';
import 'package:sensors_plus/sensors_plus.dart';

class DetailsPage extends StatefulWidget {
  final String? mid;

  DetailsPage({Key? key, required this.mid}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  String desc = "";
  String name = "";
  String detailedDesc = "";
  String imageUrl = "";
  List<dynamic> type = [];

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  Future<LandmarkDetails> getInfo() async {
    final LandmarkDetails details =
        await KnowledgeGraph().getWikiInfo(widget.mid) as LandmarkDetails;
    return details;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Landmark Details"),
      ),
      body: FutureBuilder(
          future: getInfo(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Container(
                child: Text("ERROR"),
              );
            }

            if (snapshot.hasData) {
              print(snapshot.data);
              LandmarkDetails ld = snapshot.data as LandmarkDetails;
              desc = ld.description;
              name = ld.name;
              detailedDesc = ld.detailedDescription;
              imageUrl = ld.contentUrl;
              type = ld.type;
              Size size = MediaQuery.of(context).size;
              return Scaffold(
                body: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      child: Container(
                        alignment: Alignment.topCenter,
                        height: size.height * 0.45,
                        width: size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            alignment: Alignment.bottomRight,
                            fit: BoxFit.cover,
                            image: NetworkImage(imageUrl),
                            //'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSabVO9_Gci5WDdi_X0NdGxF58jReSIPy8VhHa9vogpW--LVOCC'),
                          )
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: size.height * 0.43,
                        width: size.width,
                        decoration: const BoxDecoration(
                          color: Colors.white, // Color.fromRGBO(0, 25, 51, 20),
                          // borderRadius: BorderRadius.circular(75),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  name,
                                  style: const TextStyle(color: Colors.black, fontSize: 30),
                                ),
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              Center(
                                child: Text(
                                  desc,
                                  style: const TextStyle(color: Colors.black, fontStyle: FontStyle.italic),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              const Center(
                                child: Text(
                                  'Additional information',
                                  style: TextStyle(color: Colors.black, fontSize: 12),
                                ),
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              Center(
                                child: Text(
                                  detailedDesc,
                                  style: const TextStyle(color: Colors.black, fontSize: 15),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    for (var item in type.getRange(0, 3))
                                      Container(
                                        margin: const EdgeInsets.only(right: 14),
                                        height: 32,
                                        width: 95,
                                        alignment: Alignment.bottomCenter,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(9),
                                            border: Border.all(color: Colors.primaries.last)),
                                        child: Center(
                                            child: Text(
                                              item,
                                              style: const TextStyle(color: Colors.black, fontSize: 10),
                                            )),
                                      ),
                                  ],
                                ),
                              )
                        ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
