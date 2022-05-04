
import 'package:clear_architecture/core/errors/failure.dart';
import 'package:clear_architecture/core/usecases/usecases.dart';
import 'package:clear_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clear_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure,NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);    
  }
}


class Params extends Equatable{
  final int number;

  const Params({required this.number});

  @override
  // TODO: implement props
  List<Object?> get props => [number];
  

  
}