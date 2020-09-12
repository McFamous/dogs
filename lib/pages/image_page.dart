import 'dart:async';
import 'dart:convert';
import 'package:dogs/database/client.dart';
import 'package:dogs/database/database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

import '../pojo/image.dart';

List<String> data;
String displayedImage;

class ImagePage extends StatefulWidget {
  ImagePage(this.breed, {Key key, this.title}) : super(key: key);

  final String title;
  final String breed;

  @override
  _ImagePageState createState() => _ImagePageState(breed, title);
}

class _ImagePageState extends State<ImagePage> {
  _ImagePageState(this.breed, this.title);

  Future<String> response;
  String breed = '';
  String title = '';

  @override
  initState() {
    super.initState();
    setState(() {
      response = http.read("https://dog.ceo/api/breed/" + breed + "/images");
    });
  }

  shareAction() {
    if (displayedImage.isNotEmpty) {
      share(displayedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("${title.substring(0, 1).toUpperCase()}${title.substring(1)}"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            tooltip: 'Share Dog',
            onPressed: shareAction,
          )
        ],
      ),
      body: FutureBuilder(
        future: response,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return const AlertDialog(
                title: Text('Some server error'),
                content: Text('Try connect later'));
          return snapshot.hasData
              ? ImageList(snapshot)
              : Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.favorite),
        onPressed: addFavoriteImage,
      ),
    );
  }

  addFavoriteImage() async {
    List<Client> list = await DBProvider.db.getAllClients();
    var flag = false;
    var listImage = "";
    for (Client client in list)
      if (client.favorite == title) {
        flag = true;
        listImage = client.images;
      }
    if (flag) {
      listImage.contains(displayedImage)
          ? await DBProvider.db
              .updateClient(Client(favorite: title, images: listImage))
          : await DBProvider.db.updateClient(
              Client(favorite: title, images: "$listImage$displayedImage;"));
    } else
      await DBProvider.db
          .newClient(Client(favorite: title, images: "$displayedImage;"));
    setState(() {});
  }
}

class ImageList extends StatelessWidget {
  final AsyncSnapshot<String> snapshot;

  ImageList(this.snapshot);

  @override
  Widget build(BuildContext context) {
    Map breedMap = json.decode(snapshot.data);
    var breedList = JsonImage.fromJson(breedMap);

    data = breedList.images;
    return PageView.builder(
        scrollDirection: Axis.horizontal,
        controller: PageController(initialPage: 1),
        itemCount: data.length,
        itemBuilder: (context, i) {
          return _buildRow(context, data[i]);
        });
  }

  Widget _buildRow(BuildContext context, String image) {
    displayedImage = image;
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Image.network(image, fit: BoxFit.cover),
        ));
    // return ListTile(
    //   title: Image.network(image, fit: BoxFit.cover),
    // );
  }
}
