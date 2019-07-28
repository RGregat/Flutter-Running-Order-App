import 'package:flutter/material.dart';
import './model/band.dart';

class BandDetailsScreen extends StatelessWidget {
  final Band band;

  BandDetailsScreen({Key key, @required this.band}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
        appBar: AppBar(
          title: new Text("Details"),
          backgroundColor: Colors.black54,
        ),
        
        body: SingleChildScrollView(child:Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text(band.bandName,  style:
                                      TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(band.genre),
            ),
            Image.asset(
              band.thumbnail,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(band.bandDescription),
            ),
          ],
        )));
  }
}
