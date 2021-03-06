import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import 'model/PostItem.dart';
import 'model/PostResponse.dart';

part 'RestService.g.dart';

//flutter pub run build_runner build --delete-conflicting-outputs
@RestApi(baseUrl: "https://developerslife.ru/")
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;

  static const String TOP_CATEGORY = "top";
  static const String MONTHLY_CATEGORY = "monthly";
  static const String HOT_CATEGORY = "hot";
  static const String LATEST_CATEGORY = "latest";

  @GET("/{category}/{page}?types=gif&json=true")
  Future<PostResponse> getPosts(@Path() String category, @Path() int page);

  @GET("/random?json=true")
  Future<PostItem> getRandomPost();

  @GET("/{id}?json=true")
  Future<PostItem> getPostDetails(@Path() int id);
}