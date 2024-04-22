import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // manage app-wide state

// main tell flutter to run the app defined in MyApp.
void main() {
  // from here the flutter app run starts.
  runApp(MyApp());
}

// The code in MyApp sets up the whole app. It creates the app-wide state
// names the app, defines the visual theme, and sets the
// home widget—the starting point of your app.

// MyApp is a StatelessWidget.(There is StateFullWidget also)
// Widgets are the elements from which you build every Flutter app.
// As you can see, even the app itself is a widget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider helps to manage the state of the application.
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      // this is root widget of your application.
      child: MaterialApp(
        title: 'First App',
        // theme of our app
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        // This widget is the home page of your application
        home: MyHomePage(),
      ),
    );
  }
}

// MyAppState define's the app's well state
// there are many ways to manage the app state, ChangeNotifier is one of them
// and it is easier to start.

/*
  MyAppState defines the data the app needs to function. Right now, it only
  contains single variable.

  MyAppState extends ChangeNotifier, this means MyAppState can notify others
  about the data change.

  The state is created and provided to the whole app using a Class
  ChangeNotifierProvider
            -------
            |MyApp| -----> MyAppState
            -------             ^
                |               |
                v               |
            ------------        |
            |MyHomePage|        |  watches and uses
            ------------        |  MyAppState.
                |               |
                v               |
            -------------       |
            |OtherWidgets|      |
            -------------       |
*/
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  // getNext reassings the current with a new random wordpair(change the state)
  // notifyListeners(a method of ChangeNotifier). It ensures anyone watching
  // MyAppState is notified.
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}

// MyHomePage is the home widget for the MyApp

/*
  1) Every widget defines a build method that's automatically called everytime
  when the widget's circumstances like state changes. so that the widget is
  always upto date.
  2) MyHomePage tracks the app state using the watch method
  3) Every build method must return a widget or (more typically) a nested tree
  of widgets. In this case, the top-level widget is Scaffold
  4) Column is one of the most basic layout widget in flutter. It takes any
  number of children and puts them in a column from top to bottom
  5) Here Column layout widget contains three child widgets, in which second
  text widget takes appState and access the current state of the app.
*/
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    return Scaffold(
      // Column is a simple layout widget
      body: Column(
        children: [
          // add text widget
          Text('A random idea:'),
          // add text widget
          BigCard(pair: pair),
          // add a button widget
          // button styles are coming from MaterialApp ThemeData
          ElevatedButton(
            onPressed: () {
              // print button pressed on the console when button is clicked
              // print('button pressed!');
              appState.getNext();
            },
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    return Text(pair.asPascalCase);
  }
}
