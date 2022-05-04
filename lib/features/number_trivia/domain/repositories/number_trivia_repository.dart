import 'package:dartz/dartz.dart';

import 'package:clear_architecture/core/errors/failure.dart';
import 'package:clear_architecture/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository{
  Future<Either<Failure,NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure,NumberTrivia>> getRandomNumberTrivia();
}