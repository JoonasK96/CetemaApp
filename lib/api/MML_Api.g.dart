// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MML_Api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) {
  return Task(
    type: json['type'] as String,
  );
}

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'type': instance.type,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _RestClient implements RestClient {
  _RestClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??=
        'https://avoin-paikkatieto.maanmittauslaitos.fi/geocoding/v1/pelias/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<List<Task>> getTasks(
      lang, sources, boundarycircleradius, pointlon, pointlat, apikey) async {
    ArgumentError.checkNotNull(lang, 'lang');
    ArgumentError.checkNotNull(sources, 'sources');
    ArgumentError.checkNotNull(boundarycircleradius, 'boundarycircleradius');
    ArgumentError.checkNotNull(pointlon, 'pointlon');
    ArgumentError.checkNotNull(pointlat, 'pointlat');
    ArgumentError.checkNotNull(apikey, 'apikey');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'lang': lang,
      r'sources': sources,
      r'boundary.circle.radius': boundarycircleradius,
      r'point.lon': pointlon,
      r'point.lat': pointlat,
      r'api-key': apikey
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('/reverse',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => Task.fromJson(i as Map<String, dynamic>))
        .toList();
    return (value[0] as List);
  }
}
