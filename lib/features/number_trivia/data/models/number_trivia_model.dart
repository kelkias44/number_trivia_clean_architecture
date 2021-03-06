import 'package:clear_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter/foundation.dart';


class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel({
    required int number,
    required String text 
  }): super(text: text,number: number);
  factory NumberTriviaModel.fromJson(Map<String,dynamic> json){
    return NumberTriviaModel(number: (json['number']as num).toInt(), text: json['text']);     
  }

  Map<String , dynamic> toJson(){
    return{
      'text' : text,
      'number' : number
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [number,text];
}

