import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';
import './firstPage.dart' as first;
import './secondPage.dart' as second;
import './thirdPage.dart' as third;
import './fourthPage.dart' as fourth;
import './model/days.dart';
import './model/band.dart';
import "./Constants.dart";
/*
theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.white,
        accentColor: Colors.grey,
    ),
    */
void main() {
  runApp(new MaterialApp(
    
    home: new MyTabs()));
}

class MyTabs extends StatefulWidget {
  @override
  MyTabsState createState() => new MyTabsState();
}

Future<String> _loadDataFromAssets() async {
  return await rootBundle.loadString('assets/data.json');
}

class MyTabsState extends State<MyTabs> with SingleTickerProviderStateMixin {
  Icon customIcon = Icon(Icons.search);
  Widget customSearchBar = Text("Running Order");

  List<Days> listOfDays;
  List<Band> filteredDataListForADay;

  TabController controller;

  String searchQuery = "";
  String sortKey = Constants.SortByStage;
  int index = 0;

  final TextEditingController _searchQuery = new TextEditingController();

  Future<List<Days>> getData() async {
    List<Days> dataList;
    String dataString = await _loadDataFromAssets();
    var jsonString = json.decode(dataString);

    dataList = jsonString["days"].map<Days>((i) => Days.fromJson(i)).toList();

    return dataList;
  }

  @override
  void initState() {
    controller = new TabController(vsync: this, length: 4);
    controller.addListener(getTabIndex);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void updateSearchQuery(String newQuery) {
    List<Band> _filteredDataListForADay = new List();

    if (listOfDays != null) {
      List<Band> timeTable = listOfDays[this.index].timeTable;

      timeTable.forEach((band) => {
            if (band.bandName.toLowerCase().contains(newQuery.toLowerCase()))
              {_filteredDataListForADay.add(band)}
          });
    }

    setState(() {
      searchQuery = newQuery;
      filteredDataListForADay = _filteredDataListForADay;
    });
  }

  void getTabIndex() {
    setState(() {
      this.index = controller.index;
      this.filteredDataListForADay =
          this.listOfDays[controller.index].timeTable;
    });
    updateSearchQuery(this.searchQuery);
    handleSortSelection();
  }

  void storeSortSelection(String sortKey) {
    setState(() {
     this.sortKey = sortKey; 
    });
    getTabIndex();
  }

  void handleSortSelection() {
    switch (this.sortKey) {
      case Constants.SortByStage:
        this.filteredDataListForADay.sort((a, b) => a.stage.compareTo(b.stage));
        setState(() {});
        break;
      case Constants.SortByTime:
        this.filteredDataListForADay.sort((a, b) => a.time.compareTo(b.time));
        setState(() {});
        break;
      case Constants.SortByName:
        this
            .filteredDataListForADay
            .sort((a, b) => a.bandName.compareTo(b.bandName));
        setState(() {});
        break;
      case Constants.SortByGenre:
        this.filteredDataListForADay.sort((a, b) => a.genre.compareTo(b.genre));
        setState(() {});
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        title: customSearchBar,
        backgroundColor: Colors.black54,
        actions: <Widget>[
          IconButton(
            icon: customIcon,
            onPressed: () {
              setState(() {
                if (this.customIcon.icon == Icons.search) {
                  this.customIcon = Icon(Icons.cancel);
                  this.customSearchBar = TextField(
                    controller: _searchQuery,
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search Band",
                        hintStyle: new TextStyle(color: Colors.white)),
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                    onChanged: updateSearchQuery,
                  );
                } else {
                  _searchQuery.clear();
                  updateSearchQuery("");
                  this.customIcon = Icon(Icons.search);
                  this.customSearchBar = Text("Running Order");
                }
              });
            },
          ),
          PopupMenuButton(
            icon: Icon(Icons.sort),
            onSelected: storeSortSelection,
            itemBuilder: (BuildContext context) {
              return Constants.sortList.map((String sortKey) {
                return PopupMenuItem<String>(
                    value: sortKey, child: Row(children: <Widget>[Text(sortKey),],));
              }).toList();
            },
          ),
        ],
        bottom: new TabBar(indicatorWeight: 4.0, indicatorColor: Colors.black87, controller: controller, tabs: <Tab>[
          new Tab(
              child: Column(
            children: <Widget>[Text("WED"), Text("07.08")],
          )),
          new Tab(
              child: Column(
            children: <Widget>[Text("THU"), Text("08.08")],
          )),
          new Tab(
              child: Column(
            children: <Widget>[Text("FRI"), Text("09.08")],
          )),
          new Tab(
              child: Column(
            children: <Widget>[Text("SAT"), Text("10.08")],
          ))
        ]),
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.data != null && this.listOfDays == null) {
              this.listOfDays = snapshot.data;
              this.filteredDataListForADay = this.listOfDays[0].timeTable;
              this.searchQuery = "";
            }
            return snapshot.data != null
                ? TabBarView(
                    controller: controller,
                    children: <Widget>[
                      first.FirstPage(bandList: this.filteredDataListForADay),
                      second.SecondPage(bandList: this.filteredDataListForADay),
                      third.ThirdPage(bandList: this.filteredDataListForADay),
                      fourth.FourthPage(bandList: this.filteredDataListForADay)
                    ],
                  )
                : new Text("Still waiting for data");
          }),
    );
  }
}
