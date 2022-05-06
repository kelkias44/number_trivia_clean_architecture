import 'dart:convert';

import 'package:clear_architecture/core/errors/exception.dart';
import 'package:clear_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';
import '../../domain/entities/number_trivia.dart';

abstract class NumberTriviaLocalDataSource{
  Future<NumberTriviaModel > getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}


class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource{
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
   return sharedPreferences.setString(
     "CACHE_NUMBER_TRIVIA",
     json.encode(triviaToCache.toJson()
     )
     );
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString('CACHE_NUMBER_TRIVIA');
    if(jsonString != null){
    return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString.toString())));
    }else{
      throw CacheException();
    }
  }
}