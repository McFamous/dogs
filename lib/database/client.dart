import 'dart:convert';

Client clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Client.fromMap(jsonData);
}

String clientToJson(Client data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Client {
  String favorite;
  String images;

  Client({
    this.favorite,
    this.images,
  });

  factory Client.fromMap(Map<String, dynamic> json) => new Client(
        favorite: json["favorite"],
        images: json["images"],
      );

  Map<String, dynamic> toMap() => {
        "favorite": favorite,
        "images": images,
      };
}
