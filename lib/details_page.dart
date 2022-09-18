import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:landmark_recognition/knowledge_graph.dart';
import 'package:landmark_recognition/models/landmark_details.dart';

class DetailsPage extends StatefulWidget {
  final String? mid;

  DetailsPage({Key? key, required this.mid}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  String desc = "";
  String name = "";

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
              return Container(
                child: Text(name),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
