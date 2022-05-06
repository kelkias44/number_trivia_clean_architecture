import 'package:clear_architecture/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

class InputConverter{
  Either<Failure,int> stringToUnsignedInteger(String str){
    try {
      if(int.parse(str)>0){
      return Right(int.parse(str));
      }else{
        throw FormatException();
      }
    } on FormatException {
      return Left(InvalidInputFailure());
    }

  }
}

class InvalidInputFailure extends Failure{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}