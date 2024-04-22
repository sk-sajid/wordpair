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
  var favorites = <WordPair>[];

  // getNext reassings the current with a new random wordpair(change the state)
  // notifyListeners(a method of ChangeNotifier). It ensures anyone watching
  // MyAppState is notified.
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
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
*/

/*
  1) Removed all the old widgets which are inside the Scaffold widget.
  In MyHomePage only Scaffold widget is there from the old widgets.

  2) MyHomePage Scaffold contains one row with two childeren: SafeArea and
  Expand.

  3) The SafeArea ensures that its child is not hidden/unclear by a
  hardware notch or a status bar

  4) SafeArea wraps around the NavigationRail widget  to prevent the navigation
  buttons from being obscured by a mobile status bar.

  5) NaviagationRail have two destinations Home and Favourites. extended:false,
  hides the labels of the destiantion icons.

  6) A selected index of zero selects the first destination, a selected index
  of one selects the second destination, and so on. For now, it's hard coded to
  zero.

  7) The navigation rail also defines what happens when the user selects one
  of the destinations with onDestinationSelected

  8) The second child of the Row is the Expanded widget. Expanded widgets are
  extremely useful in rows and columns—they let you express layouts where some
  children take only as much space as they need (SafeArea, in this case) and
  other widgets should take as much of the remaining room as possible
  (Expanded, in this case). One way to think about Expanded widgets
  is that they are "greedy"

  9) try wrapping the SafeArea widget with another Expanded.
  Two Expanded widgets split all the available horizontal space between
  themselves, even though the navigation rail only really needed a little
  slice on the left.

  10) Inside the Expanded widget, there's a colored Container, and inside the
  container, the GeneratorPage(which contains almost same code as the old
  MyHomePage widget).
*/
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
              ],
              selectedIndex: 0,
              onDestinationSelected: (value) {
                print('selected: $value');
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: GeneratorPage(),
            ),
          ),
        ],
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    // wrap Column with Center using Flutter Refactor helper
    // after this the Column is centered horizontally in the container widget.
    return Center(
      // Column is a simple layout widget
      child: Column(
        // center the children vertically in the column
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // add text widget
          BigCard(pair: pair),
          SizedBox(height: 10),
          // add a button widget
          // button styles are coming from MaterialApp ThemeData
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// this BigCard widget written by Flutter refactoring helper.
// BigCard is a custom widget and it defines the wordpair
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    // wrap Text widget with padding.
    // wrapped by the flutter refactor helper
    /*
      process:
      1) right click Text widget
      2) select refactor
      3) select wrap with padding
      4) change padding width to 20.

      Flutter uses Composition over Inheritance whenever it can.
      Here, instead of padding being an attribute of Text, it's a widget!

      This way, widgets can focus on their single responsibility, and you,
      the developer, have total freedom in how to compose your UI.
      For example, you can use the Padding widget to pad text, images, buttons,
      your own custom widgets, or the whole app.
      The widget doesn't care what it's wrapping.
    */

    // access the app's current theme
    final theme = Theme.of(context);
    // access the app's font/text theme using theme.textTheme
    /*
      theme.textTheme
      includes members such as bodyMedium (for standard text of medium size),
      caption (for captions of images), or headlineLarge (for large headlines).

      The displayMedium property is a large style meant for display text
      (reserved for short, important text).

      displayMedium theoretically be null.

      Dart, the programming language in which you're writing this app,
      is null-safe, so it won't let you call methods of objects that are
      potentially null. In this case, though, you can use the ! operator
      to assure Dart you know what you're doing. (displayMedium is definitely
      not null in this case)

      Calling copyWith() on displayMedium returns a copy of the text style
      with the changes you define. In this case, you're only changing
      the text's color.
    */
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      // define color of the card with app theme's colorScheme primary color
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asPascalCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}
