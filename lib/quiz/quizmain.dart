import "package:flutter/material.dart";
import "package:mentalhealthcare/quiz/quiz.dart";
import "package:mentalhealthcare/quiz/result.dart";

class Myquiz extends StatefulWidget {
  const Myquiz({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyquizState createState() => _MyquizState();
}

class _MyquizState extends State<Myquiz> {
  final _questions = const [
    {
      'questionText': 'How do u feel now?',
      'answers': [
        {'text': 'Worried', 'score': 5},
        {'text': 'Fatigue', 'score': 4},
        {'text': 'Helpless', 'score': 3},
        {'text': 'Sad', 'score': 2},
      ],
    },
    {
      'questionText': 'What physical symptoms or illness do you have ?',
      'answers': [
        {'text': 'Increased Heart Rate', 'score': 5},
        {'text': 'Headache', 'score': 4},
        {'text': 'Trembling', 'score': 3},
        {'text': 'General Body Discomfort or Weakness', 'score': 2},
      ],
    },
    {
      'questionText': 'What is your mental State ?',
      'answers': [
        {'text': 'Suicidal Thoughts', 'score': 2},
        {'text': 'Trouble Concentrating', 'score': 5},
        {'text': 'Horrific Memories', 'score': 3},
        {'text': 'Anger', 'score': 4},
      ],
    },
  ];
  var _questionIndex = 0;
  var _totalScore = 0;

  

  void _answerQuestion(int score) {
    _totalScore += score;
    setState(() {
      _questionIndex = _questionIndex + 1;
    });
    print(_questionIndex);
    if (_questionIndex < _questions.length) {
      // ignore: avoid_print
      print('We have more questions!');
    } else {
      // ignore: avoid_print
      print('No more questions!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
        appBar: AppBar(
          title: const Text('Mental Health Quiz'),
        ),
        body: _questionIndex < _questions.length
            ? Quiz(
                answerQuestion: _answerQuestion,
                questionIndex: _questionIndex,
                questions: _questions,
              )
            : Result(_totalScore),
      );
    
  }
}
