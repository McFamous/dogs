import 'dart:async';
import 'dart:io';

import 'package:dogs/database/client.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Client ("
          "favorite TEXT PRIMARY KEY,"
          "images TEXT)");
    });
  }

  newClient(Client newClient) async {
    final db = await database;
    var raw = await db.rawInsert(
        "INSERT Into Client (favorite,images)"
        " VALUES (?,?)",
        [newClient.favorite, newClient.images]);
    return raw;
  }

  updateClient(Client newClient) async {
    final db = await database;
    var res = await db.update("Client", newClient.toMap(),
        where: "favorite = ?", whereArgs: [newClient.favorite]);
    return res;
  }

  getClient(String favorite) async {
    final db = await database;
    var res =
        await db.query("Client", where: "favorite = ?", whereArgs: [favorite]);
    return res.isNotEmpty ? Client.fromMap(res.first) : null;
  }

  Future<List<Client>> getAllClients() async {
    final db = await database;
    var res = await db.query("Client");
    List<Client> list =
        res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
    return list;
  }

  deleteClient(String favorite) async {
    final db = await database;
    return db.delete("Client", where: "favorite = ?", whereArgs: [favorite]);
  }
}
