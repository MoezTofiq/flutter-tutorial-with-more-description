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
}

// this is the widget that is home for the application as seen in the MyApp 'home' place
class MyHomePage extends StatelessWidget {
  @override
  // the build is called every time the widget 'circumstances'? changes to keep it up to date
  Widget build(BuildContext context) {
    // 'watch' is used to track the 'MyAppState' state
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    return Scaffold(
      // this is a layout widget, this places the its children in a colum from top to bottom
      body: Center(
        // this is to center the colum in the
        child: Column(
          mainAxisAlignment: MainAxisAlignment
              .center, // this is to center the children of the colum 'Scaffold'
          children: [
            // this is a simple text:
            Text('This is a random word pair: '),
            BigCard(pair: pair),
            SizedBox(height: 10), // just takes spaces to make a visual gape
            // adding a button to the application:
            ElevatedButton(
                onPressed: () {
                  // printing to the console:
                  print('@@ calling the getNext method @@');
                  // calling the assigned function to it:
                  appState.getNext();
                },
                // adding the text for the button:
                child: Text('Next'))
          ], // there is no need to add a comma but this is so when you add an other element it makes it trivial
        ),
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
