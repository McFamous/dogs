import 'dart:async';
import 'dart:convert';

import 'package:dogs/pojo/image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'image_page.dart';

List<String> data;

class SubbreedPage extends StatefulWidget {
  SubbreedPage(this.breed, {Key key, this.title}) : super(key: key);

  final String title;
  final String breed;

  @override
  _SubbreedPageState createState() => _SubbreedPageState(breed, title);
}

class _SubbreedPageState extends State<SubbreedPage> {
  _SubbreedPageState(this.breed, this.title);

  Future<String> response;
  String breed = '';
  String title = '';

  @override
  initState() {
    super.initState();
    setState(() {
      response = http.read("https://dog.ceo/api/breed/$breed/list");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("${title.substring(0, 1).toUpperCase()}${title.substring(1)}"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: response,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return const AlertDialog(
                title: Text('Some server error'),
                content: Text('Try connect later'));
          return snapshot.hasData
              ? BreedsList(snapshot, breed)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class BreedsList extends StatelessWidget {
  final AsyncSnapshot<String> snapshot;
  final String breed;

  BreedsList(this.snapshot, this.breed);

  @override
  Widget build(BuildContext context) {
    Map breedMap = json.decode(snapshot.data);
    var breedList = JsonImage.fromJson(breedMap);

    data = breedList.images;
    return ListView.separated(
        itemCount: data.length,
        separatorBuilder: (_, __) => Divider(),
        itemBuilder: (context, i) {
          return _buildRow(context, data[i], i);
        });
  }

  Widget _buildRow(BuildContext context, String data, int index) {
    final _biggerFont = TextStyle(fontSize: 18.0);
    var subBreed = data;
    return ListTile(
        title: Text(
          "${subBreed.substring(0, 1).toUpperCase()}${subBreed.substring(1)}",
          style: _biggerFont,
        ),
        trailing: Icon(Icons.arrow_forward_ios_outlined),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ImagePage("$breed/$subBreed", title: subBreed)),
          );
        });
  }
}
