import 'dart:convert';
import 'dart:math';

import 'package:clear_architecture/core/errors/exception.dart';
import 'package:clear_architecture/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clear_architecture/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:clear_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart'as http;

import '../../../../fixtures/fixtures.dart';

class MockHttpClient extends Mock implements http.Client{}


void main(){
  late MockHttpClient mockHttpClient;
  late NumberTriviaRemoteDataSourceImpl dataSource;

  setUp((){
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });
  void setupMockHttpClientSuccess200(){
    when(mockHttpClient.get(Uri.parse('http://numbersapi.com/1'), headers: anyNamed('headers')))
       .thenAnswer((_) async => http.Response(fixture('trivia.json'),200));
  }
  void setupMockHttpClientFailed404(){
    when(mockHttpClient.get(Uri.parse('http://numbersapi.com/1'), headers: anyNamed('headers')))
       .thenAnswer((_) async => http.Response('something went error', 404));    
  }
  group('get concrete number trivia', (){
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('''should perform a GET request on URL with number
     being the endpointand with application/json header''', (){
       setupMockHttpClientSuccess200();       
       dataSource.getConcreteNumberTrivia(tNumber);
       verify(mockHttpClient.get(
         Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type':'application/json'}
          ),
         
         );
     });
     test('should return number trivia when response code is 200(success)', ()async{
       setupMockHttpClientSuccess200();
       final result = await dataSource.getConcreteNumberTrivia(tNumber);
       expect(result, equals(tNumberTriviaModel));
       
     });
     test('should throw server exception when response code is 404 or other', ()async{
       setupMockHttpClientFailed404();       
       final call = dataSource.getConcreteNumberTrivia;
       expect(()=>call(tNumber), throwsA(TypeMatcher<ServerException>()));
       
     });
  });
  group('get Random number trivia', (){
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('''should perform a GET request on URL with number
     being the endpointand with application/json header''', (){
       when(mockHttpClient.get(Uri.parse('http://numbersapi.com/random'), headers: anyNamed('headers')))
       .thenAnswer((_) async => http.Response(fixture('trivia.json'),200));              
       dataSource.getRandomNumberTrivia();
       verify(mockHttpClient.get(
         Uri.parse('http://numbersapi.com/random'),
          headers: {'Content-Type':'application/json'}
          ),
         
         );
     });
     test('should return number trivia when response code is 200(success)', ()async{
       when(mockHttpClient.get(Uri.parse('http://numbersapi.com/random'), headers: anyNamed('headers')))
       .thenAnswer((_) async => http.Response(fixture('trivia.json'),200));
       final result = await dataSource.getRandomNumberTrivia();
       expect(result, equals(tNumberTriviaModel));
       
     });
     test('should throw server exception when response code is 404 or other', ()async{
       when(mockHttpClient.get(Uri.parse('http://numbersapi.com/random'), headers: anyNamed('headers')))
       .thenAnswer((_) async => http.Response('something went error', 404));     
       final call = dataSource.getRandomNumberTrivia;
       expect(()=>call() , throwsA(TypeMatcher<ServerException>()));
       
     });
  });
}