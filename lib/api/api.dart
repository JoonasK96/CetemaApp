
import 'dart:convert';
import 'package:http/http.dart' as http;


Future<List<Post>> fetchPosts( lang, sources, boundarycircleradius, pointlon, pointlat, apikey) async {
  ArgumentError.checkNotNull(lang, 'lang');
  ArgumentError.checkNotNull(sources, 'sources');
  ArgumentError.checkNotNull(boundarycircleradius, 'boundarycircleradius');
  ArgumentError.checkNotNull(pointlon, 'pointlon');
  ArgumentError.checkNotNull(pointlat, 'pointlat');
  ArgumentError.checkNotNull(apikey, 'apikey');

  final queryParameters = <String, dynamic>{
    r"lang": lang,
    r"sources": sources,
    r"boundary.circle.radius": boundarycircleradius,
    r"point.lon": pointlon,
    r"point.lat": pointlat,
    r"api-key": apikey
  };
  print(queryParameters);
  http.Response response = await http.get(Uri.parse("https://avoin-paikkatieto.maanmittauslaitos.fi/geocoding/v1/pelias/reverse?$queryParameters")


  );
  var responseJson = json.decode(response.body);
  print(responseJson);
  return (responseJson['features'] as List)
      .map((p) => Post.fromJson(p))
      .toList();
}

class Post {
  final String type;

  Post({
    this.type
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return new Post(
      type: json['type'].toString(),

    );
  }
}