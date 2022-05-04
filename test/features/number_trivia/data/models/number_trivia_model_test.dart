import 'dart:convert';

import 'package:clear_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clear_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixtures.dart';
 
 void main(){
   final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');
   test('should be a subclass of numbertrivia entity',
    (){
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    });
    group('fromjson', 
     (){
       test('should return a valid model when JSON is an integer', 
       (){
         final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));

         final result = NumberTriviaModel.fromJson(jsonMap);
         expect(result, equals(tNumberTriviaModel));

       });

       test('should return a valid model when JSON number is regarded as double', 
       (){
         final Map<String, dynamic> jsonMap = json.decode(fixture('trivia_double.json'));

         final result = NumberTriviaModel.fromJson(jsonMap);
         expect(result, equals(tNumberTriviaModel));

       });
     });

     group('toJson',
      (){
        test('should send a valid data to JSON',(){
          final result = tNumberTriviaModel.toJson();
          final expectedMap = {
          'text' : "Test Text",
          'number': 1        
          }; 
          expect(result, expectedMap);});     
      });
 }
