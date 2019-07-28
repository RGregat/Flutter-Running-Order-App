import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import './model/band.dart';
import './bandDetailsScreen.dart';
import './Constants.dart';

class FirstPage extends StatefulWidget {
  final List<Band> bandList;

  const FirstPage({Key key, @required this.bandList}) : super(key: key);

  @override
  State createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int stageMapGroupValue = 0;
  List<Band> tempBandList;
  final Map<int, Widget> stageMap = const <int, Widget>{
    0: Padding(child: Text(Constants.AllStages), padding: EdgeInsets.all(5.0)),
    1: Padding(
        child: Text(Constants.SeaShepherd), padding: EdgeInsets.all(5.0)),
    2: Padding(
        child: Text(Constants.Jaegermeister), padding: EdgeInsets.all(5.0)),
    3: Padding(child: Text(Constants.Obscure), padding: EdgeInsets.all(5.0)),
    4: Padding(child: Text(Constants.Octagon), padding: EdgeInsets.all(5.0)),
  };

  void changeState(int changeFromGroupValue) {
    setState(() {
      stageMapGroupValue = changeFromGroupValue;
    });
  }

  List<Band> filterToStage() {
    switch (this.stageMapGroupValue) {
      case 0:
        return widget.bandList;
      case 1:
        return widget.bandList
            .where((band) => band.stage.contains("Sea Shepherd"))
            .toList();
      case 2:
        return widget.bandList
            .where((band) => band.stage.contains("Jägermeister"))
            .toList();
      case 3:
        return widget.bandList
            .where((band) => band.stage.contains("Obscure"))
            .toList();
      case 4:
        return widget.bandList
            .where((band) => band.stage.contains("Octagon"))
            .toList();
    }
  }

  ListView buildListView() {
    print("buildListView called");

    List<Band> modifiedBandList = filterToStage();

    return ListView.builder(
      itemCount: modifiedBandList.length ?? 0,
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BandDetailsScreen(band: modifiedBandList[index]),
                ),
              );
            },
            child: Card(
                child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          modifiedBandList[index].thumbnail,
                          width: 110,
                        ),
                        Column(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(left: 10.0, top: 4.0),
                                child: Text(modifiedBandList[index].bandName,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            Padding(
                                padding: EdgeInsets.only(left: 10.0, top: 4.0),
                                child: Text(
                                  DateFormat("HH:mm").format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              modifiedBandList[index].time *
                                                  1000,
                                              isUtc: true)) +
                                      ", " +
                                      modifiedBandList[index].stage,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 12.0),
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 10.0, top: 4.0, bottom: 4.0),
                                child: Text(modifiedBandList[index].genre,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(fontSize: 12.0))),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        )
                      ],
                    ))));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CupertinoSegmentedControl(
                  borderColor: Colors.black54,
                  selectedColor: Colors.black54,
                  groupValue: stageMapGroupValue,
                  onValueChanged: changeState,
                  children: stageMap,
                ))),
        Expanded(
          child: buildListView(),
        )
      ],
    ));
  }
}
