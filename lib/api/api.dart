import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:segmentation_app_frontend/main.dart';

part 'api.g.dart';

@RestApi(baseUrl: '${MyApp.baseUrl}/')
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST('/kMeans/process')
  @MultiPart()
  Future<List<PathDto>> getImages(
    {
      @Part() required File image,
      @Part() required int K,
    }
  );

}

@JsonSerializable()
class PathDto {
  const PathDto({ required this.path,});

  final String path;

  factory PathDto.fromJson(Map<String, dynamic> json) =>
      _$PathDtoFromJson(json);

  /// Connect the generated [_$LongListDtoToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PathDtoToJson(this);
}


