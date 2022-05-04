import 'package:clear_architecture/core/errors/exception.dart';
import 'package:clear_architecture/core/errors/failure.dart';
import 'package:clear_architecture/core/network/network_info.dart';
import 'package:clear_architecture/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clear_architecture/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:clear_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clear_architecture/features/number_trivia/data/repositories/number_trivia_repositories_impl.dart';
import 'package:clear_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clear_architecture/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource{    
  }
class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource{    
  }
class MockNetworkInfo extends Mock implements NetworkInfo{

}

void main(){
  late NumberTriviaRepositoriesImpl repository;
  late MockLocalDataSource mockLocalDataSource;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp((){
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoriesImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo);

  });
  void runTestOnline(Function body){
    group('diviceis online',(){
      setUp((){
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

    body();
  });}
  void runTestOffline(Function body){
    group('diviceis offline',(){
      setUp((){
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

    body();
  });}
  group('get concrete number trivia',(){
      final tNumber = 1;
      final tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: "test text");
      final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    runTestOnline(() async {

      test('should check if the device is online', (){     
      repository.getConcreteNumberTrivia(tNumber);
      verify(mockNetworkInfo.isConnected);
    });
    test('should store the data locally when the call to remore data is successful',() async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(1))
          .thenAnswer((_)async => tNumberTriviaModel);
         await repository.getConcreteNumberTrivia(tNumber);
         verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
         verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));         
      });
      test('should return server failure when the call to remore data is unsuccessful',() async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(1))
          .thenThrow(ServerException());
         final result = await repository.getConcreteNumberTrivia(tNumber);
         verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
         verifyZeroInteractions(mockLocalDataSource);
         expect(result, equals(Left(ServerFailure())));  
      });});
    runTestOffline((){
      setUp((){
        when(mockNetworkInfo.isConnected).thenAnswer((_)async => false);
      });
      test('should return last locally cached data when the cache data is present',() async {
        when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
        final result = await repository.getConcreteNumberTrivia(tNumber);
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
        });
        test('should return cache exception when the there is no cache data present',() async {
        when(mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());
        final result = await repository.getConcreteNumberTrivia(tNumber);
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));

         
      });
    });
  });
  group('get random number trivia',(){
      final tNumberTriviaModel = NumberTriviaModel(number: 35, text: "test text");
      final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    runTestOnline(() async {

      test('should check if the device is online', (){     
      repository.getRandomNumberTrivia();
      verify(mockNetworkInfo.isConnected);
    });
    test('should store the data locally when the call to remore data is successful',() async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_)async => tNumberTriviaModel);
         await repository.getRandomNumberTrivia();
         verify(mockRemoteDataSource.getRandomNumberTrivia());
         verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));         
      });
      test('should return server failure when the call to remore data is unsuccessful',() async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
          .thenThrow(ServerException());
         final result = await repository.getRandomNumberTrivia();
         verify(mockRemoteDataSource.getRandomNumberTrivia());
         verifyZeroInteractions(mockLocalDataSource);
         expect(result, equals(Left(ServerFailure())));  
      });});
    runTestOffline((){
      test('should return last locally cached data when the cache data is present',() async {
        when(mockLocalDataSource.getLastNumberTrivia()).
          thenAnswer((_) async => tNumberTriviaModel);
        final result = await repository.getRandomNumberTrivia();
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
        });
        test('should return cache exception when the there is no cache data present',() async {
        when(mockLocalDataSource.getLastNumberTrivia()).
        thenThrow(CacheException());
        final result = await repository.getRandomNumberTrivia();
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));

         
      });
    });
  });
}