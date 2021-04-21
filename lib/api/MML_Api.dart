import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'MML_Api.g.dart';

@RestApi(baseUrl: "https://avoin-paikkatieto.maanmittauslaitos.fi/geocoding/v1/pelias/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/reverse")
  Future<List<Task>> getTasks(
      @Query('lang') String lang,
      @Query('sources') String sources,
      @Query('boundary.circle.radius') String boundarycircleradius,
      @Query('point.lon') String pointlon,
      @Query('point.lat') String pointlat,
      @Query('api-key') String apikey);
}

@JsonSerializable()
class Task {
  String type;

  Task({this.type});

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
