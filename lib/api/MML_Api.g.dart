// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MML_Api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Places _$PlacesFromJson(Map<String, dynamic> json) {
  return Places(
    id: json['id'] as String,
    name: json['name'] as String,
    avatar: json['avatar'] as String,
    createdAt: json['createdAt'] as String,
  );
}

Map<String, dynamic> _$PlacesToJson(Places instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar': instance.avatar,
      'createdAt': instance.createdAt,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _RestClient implements RestClient {
  _RestClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'avoin-paikkatieto.maanmittauslaitos.fi/geocoding/v1/pelias/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<List<Places>> getTasks() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
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
        .map((dynamic i) => Places.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }
}
