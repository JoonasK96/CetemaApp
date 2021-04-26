
import 'dart:convert';

import 'package:http/http.dart' as http;


Future<List> fetchPosts( lang, sources, boundarycircleradius, pointlon, pointlat, apikey) async {


String url = "https://avoin-paikkatieto.maanmittauslaitos.fi/geocoding/v1/pelias/reverse?lang=$lang&sources=$sources&boundary.circle.radius=$boundarycircleradius&point.lon=$pointlon&point.lat=$pointlat&api-key=$apikey";
print(url);

  http.Response response = await http.get(Uri.parse(url));
  if(response.statusCode == 200) {
    Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> data = map["features"];
   // print(data[0]["properties"]);


    /*   var list = json.decode(response.body)['features'] as String;
    var bla = json.decode(list)['name'];
    List<String> features = list != null ? List.from(bla) : null;
    print(data);
    print("jalla $list");*/
    //List<dynamic> products = data.map((i) =>
    //    Features.fromJson(i)).toList();




    return data;
  } else {
    throw Exception('failed to load');
  }

}

class Post {
   String id;


  Post({
    this.id
  });


  factory Post.fromJson(Map<String, dynamic> json) {
    return new Post(
      id: json['id'],

    );
  }
}

class Features {
  final String id;

  Features({this.id});
  factory Features.fromJson(Map<String, dynamic> parsedJson){
    return Features(
        id:parsedJson['id'],

    );
  }

}
