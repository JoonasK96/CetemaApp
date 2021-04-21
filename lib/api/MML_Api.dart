import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'MML_Api.g.dart';

@RestApi(baseUrl: "https://avoin-paikkatieto.maanmittauslaitos.fi/geocoding/v1/pelias/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/reverse")
  Future<String> getPlaces(
  @Query('lang') String lang,
  @Query('sources') String sources,
  @Query('boundary.circle.radius') String boundarycircleradius,
  @Query('point.lon') String pointlon,
  @Query('point.lat') String pointlat,
  @Query('api-key') String apikey

      );
}

@JsonSerializable()
class Places {

  List features;

  Places({this.features});

  factory Places.fromJson(Map<String, dynamic> json) => _$PlacesFromJson(json);
  Map<String, dynamic> toJson() => _$PlacesToJson(this);
}