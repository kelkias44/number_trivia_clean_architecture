import '../../domain/entities/number_trivia.dart';

abstract class NumberTriviaRemoteDataSource{

  /// calls the http://numbersapi.com/{numbers} endpoint
  /// throws [server exception] for all error codes
  
  Future<NumberTrivia> getConcreteNumberTrivia(int number);

  /// calls the http://numbersapi.com/random endpoint
  /// throws [server exception] for all error codes

  Future<NumberTrivia> getRandomNumberTrivia();
}