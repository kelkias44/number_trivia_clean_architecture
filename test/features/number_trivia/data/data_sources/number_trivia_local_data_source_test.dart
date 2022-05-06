import 'dart:convert';

import 'package:clear_architecture/core/errors/exception.dart';
import 'package:clear_architecture/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clear_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixtures.dart';

class MockSharedPreferences extends Mock implements SharedPreferences{}
 
void main(){
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp((){
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('get last number trivia', (){
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json'))); 
    test('should return number trivia from shared preference if there is one cached data', ()async{
      when(mockSharedPreferences.getString('CACHE_NUMBER_TRIVIA'))
      .thenReturn(fixture('trivia_cached.json'));

      final result = await dataSource.getLastNumberTrivia();
      verify(mockSharedPreferences.getString('CACHE_NUMBER_TRIVIA'));
      expect(result, equals(tNumberTriviaModel));
    });
    test('should throw cache exception when there is no data', ()async{
      when(mockSharedPreferences.getString('CACHE_NUMBER_TRIVIA'))
      .thenReturn(null);

      final call = dataSource.getLastNumberTrivia;
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });
  group('cache number trivia', (){
    final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test trivia');
    test('should call shared preference to cach data', (){
      dataSource.cacheNumberTrivia(tNumberTriviaModel);
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
        'CACHE_NUMBER_TRIVIA',
        expectedJsonString
        ));
    });
  });

}