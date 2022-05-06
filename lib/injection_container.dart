import 'package:clear_architecture/core/network/network_info.dart';
import 'package:clear_architecture/core/util/Input_converter.dart';
import 'package:clear_architecture/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clear_architecture/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:clear_architecture/features/number_trivia/data/repositories/number_trivia_repositories_impl.dart';
import 'package:clear_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clear_architecture/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:clear_architecture/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:clear_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;

final sl = GetIt.instance;

Future <void> Init() async {
  //!features
  sl.registerFactory(() => NumberTriviaBloc(
    inputConverter: sl(),
    concrete: sl(),
    random: sl()));

  //usecases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  //repositories
  sl.registerLazySingleton<NumberTriviaRepository>(() => 
    NumberTriviaRepositoriesImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      networkInfo: sl()));
  
  //data sources
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(() => 
    NumberTriviaLocalDataSourceImpl(
      sharedPreferences: sl(),
      ));
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(() => 
    NumberTriviaRemoteDataSourceImpl(
      client: sl(),
      ));

  //core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => 
    NetworkInfoImpl(
      sl(),
    ));

  //external
  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());


}