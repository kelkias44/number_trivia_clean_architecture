import 'package:clear_architecture/core/errors/exception.dart';
import 'package:clear_architecture/core/network/network_info.dart';
import 'package:clear_architecture/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clear_architecture/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:clear_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clear_architecture/core/errors/failure.dart';
import 'package:clear_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

typedef Future<NumberTrivia> concreteOrRandomChooser();
class NumberTriviaRepositoriesImpl implements NumberTriviaRepository{
  final NumberTriviaLocalDataSource localDataSource;
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoriesImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo });
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) async {
    return await _getTrivia((){
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
   
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia()async {
   return await _getTrivia(() {
     return remoteDataSource.getRandomNumberTrivia();
   });
  }


  Future<Either<Failure, NumberTrivia>> _getTrivia(
    concreteOrRandomChooser getConcreteorRandom) async {
    if(await networkInfo.isConnected){
    try {
      final remoteTrivia = await getConcreteorRandom();
      localDataSource.cacheNumberTrivia(remoteTrivia);
      return Right(remoteTrivia);
    } on ServerException {
      return left(ServerFailure());
    }
    }else{
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException{
        return Left(CacheFailure());
      }
    }
   
  }
  
} 