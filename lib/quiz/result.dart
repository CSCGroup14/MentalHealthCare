import 'package:flutter/material.dart';
import 'package:mentalhealthcare/Communities/AnxietyPage.dart';
import 'package:mentalhealthcare/Communities/traumaPage.dart';
import 'package:mentalhealthcare/MainPage.dart';

import '../Communities/depressionPage.dart';

class Result extends StatelessWidget {
  final int resultScore;
  // final Function resetHandler;

  const Result(this.resultScore, {super.key});

  String get resultPhrase {
    String resultText;
    if (resultScore >= 6 && resultScore < 9) {
      resultText = 'You are depressed.'; 
    } else if (resultScore >= 9 && resultScore < 12) {
      resultText = 'You are traumatized'; 
    } else if (resultScore >= 12 && resultScore < 15) {
      resultText = 'You are stressed';
    } else {
      resultText = 'You are anxious'; 
    }
    return resultText;
  }

  void navigateToNewScreen(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      if (resultPhrase == 'You are depressed.') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DepressionPage()));
      } else if (resultPhrase == 'You are traumatized') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => TraumaPage()));
      } else if (resultPhrase == 'You are stressed') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AnxietyPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            resultPhrase,
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            child: const Text(
              'Restart Quiz!',
            ),
            onPressed: () => navigateToNewScreen(context),
          ),
        ],
      ),
    );
  }
}
