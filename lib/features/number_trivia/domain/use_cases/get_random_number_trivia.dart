import 'package:clear_architecture/core/errors/failure.dart';
import 'package:clear_architecture/core/usecases/usecases.dart';
import 'package:clear_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clear_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';


class GetRandomNumberTrivia extends UseCase<NumberTrivia, NoParams>{
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(params) async {
    return await repository.getRandomNumberTrivia();
  }
  
}

