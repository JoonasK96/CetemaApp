import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'MML_Api.g.dart';

@RestApi(baseUrl: "avoin-paikkatieto.maanmittauslaitos.fi/geocoding/v1/pelias/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/reverse")
  Future<List<Places>> getTasks();
}

@JsonSerializable()
class Places {
  String id;
  String name;
  String avatar;
  String createdAt;

  Places({this.id, this.name, this.avatar, this.createdAt});

  factory Places.fromJson(Map<String, dynamic> json) => _$PlacesFromJson(json);
  Map<String, dynamic> toJson() => _$PlacesToJson(this);
}

