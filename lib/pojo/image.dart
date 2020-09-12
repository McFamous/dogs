class JsonImage{
  dynamic status;
  List<String> images;

  JsonImage(this.status, this.images);

  JsonImage.fromJson(Map<String, dynamic> json) {
    images = [];
    status = json["status"];
    List list = json["message"];
    // links = new Map();
    for (String key in list) {
      images.add(key);
    }
    images = images;
  }
}