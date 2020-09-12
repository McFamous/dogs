import 'value.dart';

class JsonList {
  // dynamic status;
  // List<Value> breeds;
  // Map<String, String> links;
  //
  // JsonList(this.status, this.breeds);
  //
  // JsonList.fromJson(Map<String, dynamic> json) {
  //   breeds = [];
  //   status = json["status"];
  //   Map map = json["message"];
  //   links = new Map();
  //   // breeds.add(new Value("Random Breed", []));
  //   // links["Random Breed"] = "random";
  //   for (String key in map.keys) {
  //     var currentValue = new Value(key, []);
  //     List currentBreed = map[key];
  //     if (currentBreed.length > 0) {
  //       for (String nestedKey in currentBreed) {
  //         links[nestedKey + " " + key] = key + "/" + nestedKey;
  //         breeds.add(new Value(nestedKey + " " + key, []));
  //       }
  //     } else {
  //       breeds.add(currentValue);
  //       links[key] = key;
  //     }
  //   }
  //   breeds = breeds;
  // }

  dynamic status;
  List<Value> breeds;
  // Map<String, String> links;

  JsonList(this.status, this.breeds);

  JsonList.fromJson(Map<String, dynamic> json) {
    breeds = [];
    status = json["status"];
    Map map = json["message"];
    // links = new Map();
    for (String key in map.keys) {
      var currentValue = new Value(key, []);
      if (map[key].length > 0){
        // for (String nestedKey in map[key]) {
        //   links[nestedKey + " " + key] = key + "/" + nestedKey;
        // }
        breeds.add(new Value("$key (${map[key].length} subbreeds)", []));
      }
      else breeds.add(currentValue);
    }
    breeds = breeds;
  }
}
