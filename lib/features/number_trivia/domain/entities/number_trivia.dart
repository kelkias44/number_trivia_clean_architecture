import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class NumberTrivia extends Equatable {
 int number;
 String text; 
  NumberTrivia({
    required this.number,
    required this.text,
  }) ;

  @override
  // TODO: implement props
  List<Object?> get props => [number,text];
}
