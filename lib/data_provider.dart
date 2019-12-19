import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show rootBundle;

import 'RestService.dart';
import 'categories.dart';
import 'package:dio/dio.dart';
import 'model/PostResponse.dart';

import 'package:tuple/tuple.dart';

/// Assumes the given path is a text-file-asset.
Future<String> getFileData(String path) async {
  return await rootBundle.loadString(path);
}

Future<Tuple2<int, PostResponse>> getData(Category category, int pageNumber) async {
  print("getData: category=" + category.toString() + ", page=" + pageNumber.toString());

  if (kIsWeb || Platform.isMacOS) {
    var dataString = await getFileData("assets/best_of_all_time.json");
    print("getData:result: " + dataString);
    PostResponse data = PostResponse.fromJsonMap(json.decode(dataString));
    return Tuple2(pageNumber, data);
  } else {
    final dio = Dio();
    final client = RestClient(dio);
    var response = await client.getPosts(getUrlByCategory(category), pageNumber);

    print("getData:result: ${response.result.toString()}");
    return Tuple2(pageNumber, response);
  }
}

// ignore: missing_return
String getUrlByCategory(Category category) {
  switch (category) {
    case Category.LATEST:
      return RestClient.LATEST_CATEGORY;
    case Category.TOP:
      return RestClient.TOP_CATEGORY;
    case Category.MONTHLY:
      return RestClient.MONTHLY_CATEGORY;
    case Category.HOT:
      return RestClient.HOT_CATEGORY;
    case Category.RANDOM:
      return null;
    case Category.FAVORITE:
      return null;
  }
}

// ignore: missing_return
String getTitleTextByCategory(Category category) {
  switch(category) {
    case Category.LATEST: return "Latest";
    case Category.TOP: return "Best of all time";
    case Category.MONTHLY: return "Best of the month";
    case Category.HOT: return "Hot";
    case Category.RANDOM: return "Random";
    case Category.FAVORITE: return "Favorite";
  }
}