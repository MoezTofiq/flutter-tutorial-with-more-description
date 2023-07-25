import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// this is the main function of flutter:
void main() {
  // running the application called 'MyApp'
  runApp(MyApp());
}

// This is what 'runApp' is running: it is a widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});
/*this is where the whole code for the application is set (it's kind of like the main)
here everything is set up for the application: 
  the theme
  the name of the application
  where the home widget (home button) is supposed to take you
   */
  @override
  Widget build(BuildContext context) {
    // here the 'ChangeNotifierProvider' is creating and providing a state to the whole application
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

/* this defines the application state, there are many ways to change the app state, this one uses the 'changeNotifier'
  it works like this: 
  'MyAppState: defines the initial data for the application (ATM it contains a variable for the random word pair) 
  'ChangeNotifier' tells the application about changes that happen to it (eg the word-pair changing)
  this state is provided to the whole application (see above)*/
class MyAppState extends ChangeNotifier {
  // random word pair being provided to 'MyApp'
  var current = WordPair.random();
  // function for the button, to make a new word pair for the state
  void getNext() {
    //adding a new word pair for the current:
    current = WordPair.random();
    // telling all the listeners if this state that a change has occurred:
    notifyListeners();
  }

  // favorite button code and state:
  var favorites = <WordPair>[]; // favorite is word pair array

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current); // unfavorite the current word pair
    } else {
      favorites.add(current); // favorite the current word pair
    }
    notifyListeners(); //notify elements that are checking for this element change
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() =>
      _MyHomePageState(); // '_' means that this is a private class in dart
}

class _MyHomePageState extends State<MyHomePage> {
  //this widget has its own state called MyHomePage
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    // this is for catering for the page change:
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page =
            Placeholder(); // this is a widget for making a placeholder when there is no ui implemented
        break;
      default:
        throw UnimplementedError(
            'no widget for $selectedIndex'); // this follows the fail-fast principle, meaning it will fail and let the one that called it cater for the error
    }
    return LayoutBuilder(builder: (context, constraints) {
      // this is to make the navigation rail extend when there is enough space, layout builder is called every time the constraints change, eg: resizing the window or changing the phone screen orientation, the widgets in the home screen resize
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              // this is to avoid the navigation rail being obscured by a notch or status bar
              child: NavigationRail(
                extended: constraints.maxWidth >=
                    600, // 600 here are logical pixels, so it stays the same wether its on lower or higher resolutions
                destinations: [
                  // this is for the icons on navigation bar
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                ],
                selectedIndex:
                    selectedIndex, // this is what is currently selected
                onDestinationSelected: (value) {
                  // this tells what happens when the user selects on of the icons
                  setState(() {
                    // this is similar to notifyListeners() in that it makes sure that the ui updates.
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              // this is for the row, it allows the child to take as much space as needed while the rest of the children in the row take as little as needed
              child: Container(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer, // this is for the colored background
                child: page, // this is to show which page to display
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

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
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

class BigCard extends StatelessWidget {
  // this is made to make the logic separate for displaying the pair and nothing else.
  // this is what is required to pass to the class:
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(
        context); // this gets the current theme of the application through context
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    /* style above is for the text in the word pair
      'theme.textTheme' is to access the apps font theme
      'displayMedium' is reserved for short,important text, for example a heading or something short to catch their attention
      '!' is to avoid the null safety from dart, its called the bang operator, this is to tell dart that we know that 'displayMedium' is definitely not null in this case
      'copyWith()' returns a copy of the text style with the changes you define, eg the color of the text.
      */
    return Card(
      // 'wrap with widget' => renamed to card
      // adding this made the back-ground:
      color: theme.colorScheme.primary,
      elevation: 10, // elevate the card for the shadow of the card
      child: Padding(
        //done with ctrl + . => wrap with padding
        padding: const EdgeInsets.all(20), // this is the measurement
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel:
              "${pair.first} ${pair.second}", // this is for the screen readers, even though flutter takes care of it by its self this is an intervention to help the screen reader pronounce it correctly
        ),
      ),
    );
  }
}
