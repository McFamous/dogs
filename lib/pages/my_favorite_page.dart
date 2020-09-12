import 'package:dogs/database/client.dart';
import 'package:dogs/database/database.dart';
import 'package:dogs/pages/favorite_image_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyFavoritePage extends StatefulWidget {
  MyFavoritePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyFavoritePageState createState() => _MyFavoritePageState();
}

class _MyFavoritePageState extends State<MyFavoritePage> {
  var response;

  @override
  void initState() {
    super.initState();
    response = DBProvider.db.getAllClients();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      response = DBProvider.db.getAllClients();
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        child: FutureBuilder(
          future: response,
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return const AlertDialog(
                  title: Text('Some server error'),
                  content: Text('Try connect later'));
            return snapshot.hasData
                ? FavoriteList(snapshot)
                : Center(child: CircularProgressIndicator());
          },
        ),
        onRefresh: refreshList,
      ),
    );
  }
}

class FavoriteList extends StatelessWidget {
  final snapshot;

  FavoriteList(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: snapshot.data.length,
        separatorBuilder: (_, __) => Divider(),
        itemBuilder: (context, i) {
          Client item = snapshot.data[i];
          return _buildRow(context, item);
        });
  }

  Widget _buildRow(BuildContext context, Client data) {
    final _biggerFont = TextStyle(fontSize: 18.0);
    final breed = data.favorite;
    final listImage = data.images.split(";");
    listImage.remove("");
    return ListTile(
        title: Text(
          "${breed.substring(0, 1).toUpperCase()}${breed.substring(1)} (${listImage.length} photos)",
          style: _biggerFont,
        ),
        trailing: Icon(Icons.arrow_forward_ios_outlined),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FavoriteImage(
                      data.images,
                      title: data.favorite,
                    )),
          );
        });
  }
}
