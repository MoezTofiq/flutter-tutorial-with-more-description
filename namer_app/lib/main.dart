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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      // ),
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

    return Scaffold(
      // this is a layout widget, this places the its children in a colum from top to bottom
      body: Column(
        children: [
          // this is a simple text:
          Text('text no 1:'),
          // this is a text with the current app state in lower case:
          Text('this is the name : ${appState.current.asSnakeCase}'),
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
    );
  }
}
