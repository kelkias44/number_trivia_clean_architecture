import 'package:bloc/bloc.dart';
import 'package:clear_architecture/core/errors/failure.dart';
import 'package:clear_architecture/core/usecases/usecases.dart';
import 'package:clear_architecture/core/util/Input_converter.dart';
import 'package:clear_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clear_architecture/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:clear_architecture/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHE_FAILURE_MESSAGE = 'Cache Failure';
const INVALID_INPUT_FAILURE_MESSAGE = 'Invalid Input:- must be positive integer';



class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  
  final InputConverter inputConverter;
  final GetConcreteNumberTrivia concrete;
  final GetRandomNumberTrivia random;

  NumberTriviaBloc({
    required this.inputConverter,
    required this.concrete,
    required this.random }) : super(Empty()) {
    on<NumberTriviaEvent>((event, emit) {});

    @override
    Stream<NumberTriviaState> mapEventToState(NumberTriviaEvent event)async*{
      if(event is GetTriviaForConcreteNumber){
        final inputEither = inputConverter.stringToUnsignedInteger(event.numberString);
        yield* inputEither.fold(
          (failure)async*{
            yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
          },
          (integer)async* {
           
           yield Loading();
           final failureOrTrivia = await concrete(Params(number: integer)) ;
           yield* _eitherFailureOrTrivia(failureOrTrivia);
          });}
          else if(event is GetTriviaForRandomNumber){
            () async* {
              yield Loading();
              final failureOrTrivia = await random(NoParams());
            yield* _eitherFailureOrTrivia(failureOrTrivia);
            
          };
          
      }

    }
  }


  Stream<NumberTriviaState> _eitherFailureOrTrivia(
    Either<Failure, NumberTrivia> failureOrTrivia,
    ) async* {
    yield failureOrTrivia.fold(
     (failure)=> Error(message: _mapFailureToMessage(failure)),
     (trivia) => Loaded(trivia: trivia));
  }



  String _mapFailureToMessage(Failure failure){
    switch(failure.runtimeType){
      case(ServerFailure):
       return SERVER_FAILURE_MESSAGE;
      case(CacheFailure):
       return CACHE_FAILURE_MESSAGE;
      default:
       return ("unexpecte error");
    }
  }
}
