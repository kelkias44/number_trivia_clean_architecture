import 'package:clear_architecture/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:clear_architecture/injection_container.dart' as di;
import 'package:flutter/material.dart';

void main()async {
  di.Init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      home: NumberTriviaPage(),
    );
  }
}

