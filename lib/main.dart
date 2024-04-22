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

/*
  StateLessWidget vs StateFullWidget

  until now MyAppState covers all your state needs. That's why all the widgets
  you have written are state less. StateLessWidgets don't contain any mutable
  state of their own.

  when onDestinationSelected method is called we need to change the selected-
  Index value. so we need to maintain the state i.e add selectedIndex to the
  MyAppState. But it is bad practice to add all of the state inside the
  MyAppState function. Some state is only relevant to a single widget,
  so it should stay with that widget.

  StateFullWidget have the mutable state to itself.
  Both MyHomePage and _MyHomePageState are rewritten by Flutter refactor helper
  :right click MyHomePage, select refactor and select convert to the statefull
  widget.
*/
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// The underscore (_) at the start of _MyHomePageState makes that class private
// this class extends State and can therefore manage its own state.
class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    // Placeholder; a handy widget that draws a crossed rectangle wherever you
    // place it, marking that part of the UI as unfinished.
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavouritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // Make MyHomePage responsive
    /*
      Flutter provides several widgets that help you make your apps
      automatically responsive. For example, Wrap is a widget similar to
      Row or Column that automatically wraps children to the next "line"
      (called "run") when there isn't enough vertical or horizontal space.
      There's FittedBox, a widget that automatically fits its child into
      available space according to your specifications.

      But NavigationRail doesn't automatically show labels when there's enough
      space because it can't know what is enough space in every context.
      It's up to you, the developer, to make that call.

      show labels only if MyHomePage is atleast 600 pixels wide.

      Flutter works with logical pixels as a unit of length. They are also
      sometimes called device-independent pixels.

      A padding of 8 pixels is visually the same regardless of whether the app
      is running on an old low-res phone or a newer ‘retina' device. There are
      roughly 38 logical pixels per centimeter, or about 96 logical
      pixels per inch, of the physical display.

      To achieve responsiveness here we have to use LayoutBuilder widget. It
      lets you change the widget tree on how much available space you have. To
      do that wrap the existing Scaffold widget with the builder.

      Use Flutter refactor helper to do this:
      Inside _MyHomePageState's build method, put your cursor on Scaffold.
      Call up the Refactor menu with Ctrl+. (Windows/Linux) or Cmd+. (Mac).
      Select Wrap with Builder and press Enter.
      Modify the name of the newly added Builder to LayoutBuilder.
      Modify the callback parameter list from (context) to (context,constraints)

      LayoutBuilder's builder callback is called when the constraints changes.
      - The user resizes the app's window
      - The user rotates their phone from portrait to landscape or back
      - some widget next to MyHomPage grows in size, making the MyHomePage
        constraints smaller
      - and soon
    */
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
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
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  // similar to the notifyListeners - makes sure the UI updates
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
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

// FavouritesPage widget defines all the wordpairs which are liked
class FavouritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }
    // ListView is a column that scrolls
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text('You have ${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          // ListTile widget have properties like text, icon and OnTap for
          // interactions
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
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
