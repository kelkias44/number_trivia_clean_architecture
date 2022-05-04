import 'package:clear_architecture/features/number_trivia/data/models/number_trivia_model.dart';

import '../../domain/entities/number_trivia.dart';

abstract class NumberTriviaLocalDataSource{
  Future<NumberTrivia> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTrivia triviaToCache);
}