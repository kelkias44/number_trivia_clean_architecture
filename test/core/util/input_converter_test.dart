import 'package:clear_architecture/core/util/Input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  late InputConverter inputConverter;

  setUp((){
    inputConverter = InputConverter();
  });

  group('string to unsigned integer', (){
    test('should return integer when string represents unsigned integer', () {
      final str = '123';
      final result = inputConverter.stringToUnsignedInteger(str);
      expect(result, Right(123));
    });
  test('should return invalid input failure when string is not integer', () {
      final str = 'abc';
      final result = inputConverter.stringToUnsignedInteger(str);
      expect(result, Left(InvalidInputFailure()));
    });
    test('should return invalid input failure when string is negative integer', () {
      final str = '-123';
      final result = inputConverter.stringToUnsignedInteger(str);
      expect(result, Left(InvalidInputFailure()));
    });
  });
}