import 'dart:convert';
import 'dart:io';

import 'package:clear_architecture/core/errors/exception.dart';
import 'package:clear_architecture/features/number_trivia/data/models/number_trivia_model.dart';

import '../../domain/entities/number_trivia.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource{
  Future<NumberTrivia> getConcreteNumberTrivia(int number);
  Future<NumberTrivia> getRandomNumberTrivia();
}


class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource{
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});


  @override
  Future<NumberTrivia> getConcreteNumberTrivia(int number) => getTriviaFromUrl('http://numbersapi.com/$number');

  @override
  Future<NumberTrivia> getRandomNumberTrivia() => getTriviaFromUrl('http://numbersapi.com/random');

  Future<NumberTriviaModel> getTriviaFromUrl(String url)async {
    final response = await client.get( Uri.parse(url),
          headers: {'Content-Type':'application/json'}
          );
          if(response.statusCode == 200){
          return NumberTriviaModel.fromJson(json.decode(response.body));
          }else{
            throw ServerException();
          }
          

  }

}