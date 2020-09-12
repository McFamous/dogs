import 'package:dogs/database/client.dart';
import 'package:dogs/database/database.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

String displayedImage;

class FavoriteImage extends StatefulWidget {
  FavoriteImage(this.images, {Key key, this.title}) : super(key: key);

  final String title;
  final String images;

  @override
  _FavoriteImageState createState() => _FavoriteImageState(images, title);
}

class _FavoriteImageState extends State<FavoriteImage> {
  _FavoriteImageState(this.images, this.title);

  String images = '';
  String title = '';

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
      body: ImageList(images),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.favorite_border),
        onPressed: removeFavoriteImage,
      ),
    );
  }

  removeFavoriteImage() async {
    List<Client> list = await DBProvider.db.getAllClients();
    var listImage = "";
    for (Client client in list) {
      if (client.favorite == title)
        listImage = client.images.replaceAll("$displayedImage;", "");
    }
    listImage.length == 0
        ? await DBProvider.db.deleteClient(title)
        : await DBProvider.db
            .updateClient(Client(favorite: title, images: listImage));
    setState(() {});
  }
}

class ImageList extends StatelessWidget {
  final images;

  ImageList(this.images);

  @override
  Widget build(BuildContext context) {
    final listImage = images.split(";");
    listImage.remove("");
    return PageView.builder(
        scrollDirection: Axis.horizontal,
        controller: PageController(initialPage: 1),
        itemCount: listImage.length,
        itemBuilder: (context, i) {
          return _buildRow(context, listImage[i]);
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
  }
}
