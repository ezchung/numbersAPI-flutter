import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/api_service.dart';
import 'package:my_app/json.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {

  late Fact? fact;
  var facts = <String?>[];

  void getFactAPI() async {
    print('inside Getfact');
    fact = (await ApiService().getFact());
    facts.add(fact?.statement);
    print('try fact');
    // print(fact?.fragment);
    print(fact);
    notifyListeners();
  }

  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    var facts = appState.facts;
    print('TEST');
    print('facts');
    print(facts);
    // print(appState.fact);
    // var currFact;

    // if (appState.fact != null) {
    //   currfact = appState.fact.fact.statement;
    // }
    // var currFact = appState.fact;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigCard(pair: pair),
            // Text(currFact.fact!.statement)
            SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {
                appState.getFactAPI();
              },
              child: Text('Get Fact'),
            ),
            SizedBox(
              height: 500,
              child: ListView(
                children:[
                  Padding(
                    padding: const EdgeInsets.all(20),
                  ),
                  for (var fact in facts)
                    ListTile(
                      title: Text(fact!)
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    Key? key,
    required this.pair,
  }) : super(key: key);

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(pair.asLowerCase, style: style),
      ),
    );
  }
}