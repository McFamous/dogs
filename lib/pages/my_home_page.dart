import 'dart:async';
import 'dart:convert';

import 'package:dogs/pages/subreed_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'image_page.dart';
import '../pojo/breeds.dart';
import '../pojo/value.dart';

const allDogs = "https://dog.ceo/api/breeds/list/all";

List<Value> data;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<String> response;

  @override
  initState() {
    super.initState();
    setState(() {
      response = http.read(allDogs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: response,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return const AlertDialog(
                title: Text('Some server error'),
                content: Text('Try connect later'));
          return snapshot.hasData
              ? BreedsList(snapshot)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class BreedsList extends StatelessWidget {
  final AsyncSnapshot<String> snapshot;

  BreedsList(this.snapshot);

  @override
  Widget build(BuildContext context) {
    Map breedMap = json.decode(snapshot.data);
    var breedList = JsonList.fromJson(breedMap);

    data = breedList.breeds;
    return ListView.separated(
        itemCount: data.length,
        separatorBuilder: (_, __) => Divider(),
        itemBuilder: (context, i) {
          return _buildRow(context, data[i]);
        });
  }

  Widget _buildRow(BuildContext context, Value data) {
    final _biggerFont = TextStyle(fontSize: 18.0);
    var breed = data.title;
    return ListTile(
        title: Text(
          "${breed.substring(0, 1).toUpperCase()}${breed.substring(1)}",
          style: _biggerFont,
        ),
        trailing: Icon(Icons.arrow_forward_ios_outlined),
        onTap: () {
          var str = breed.split(" ");
          if (breed != str[0]) {
            Navigator.push(
              context,
               MaterialPageRoute(
                  builder: (context) =>
                       SubbreedPage(str[0], title: str[0])),
            );
          } else {
            Navigator.push(
              context,
               MaterialPageRoute(
                  builder: (context) =>  ImagePage(breed, title: breed)),
            );
          }
        });
  }
}
