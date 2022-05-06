part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

class GetTriviaForConcreteNumber implements NumberTriviaEvent{
  final String numberString;

  GetTriviaForConcreteNumber(this.numberString);
  @override
  // TODO: implement props
  List<Object> get props => [];

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();


}
class GetTriviaForRandomNumber implements NumberTriviaEvent{
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}