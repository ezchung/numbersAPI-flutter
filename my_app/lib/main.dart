import 'dart:html';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/api_service.dart';
import 'package:my_app/json.dart';
import 'package:carousel_slider/carousel_slider.dart';

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

  // late Fact? fact;
  // var facts = <String?>[];

  // void getFactAPI() async {
  //   print('inside Getfact');
  //   fact = (await ApiService().getFact());
  //   facts.add(fact?.statement);
  //   print('try fact');
  //   // print(fact?.fragment);
  //   print(fact);
  //   notifyListeners();
  // }

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
    // var APIState = APIWidget.of(context);

    // var facts = appState.facts;
    // print('TEST');
    // print('facts');
    // print(facts);
    // // print(appState.fact);
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
            APIWidget(),
          ],
        ),
      ),
    );
  }
}

class APIWidget extends StatefulWidget {
  const APIWidget({super.key});

  // static of(BuildContext context, {bool root = false}) => root
  //     ? context.findRootAncestorStateOfType<APIWidgetState>()
  //     : context.findAncestorStateOfType<APIWidgetState>();

  @override
  State<APIWidget> createState() => APIWidgetState();
}

class APIWidgetState extends State<APIWidget> {
  late Fact? fact;
  var facts = <String?>[];

  @override
  void initState() {
    super.initState();
    print('init state ran');
    getInitFactAPI();
    print('INIT FACTS');
    print(facts);
  }

  void getInitFactAPI() async {
    fact = (await ApiService().getFact('/math/5'));
    facts.add(fact?.statement);
    fact = (await ApiService().getFact('/trivia/42'));
    facts.add(fact?.statement);
    fact = (await ApiService().getFact('/years/2019'));
    facts.add(fact?.statement);

    setState(() {
      facts = facts;
    });
  }

  void getFactAPI() async {
    print('inside Getfact');
    fact = (await ApiService().getFact('/trivia/random'));
    facts.add(fact?.statement);

    setState(() {
      fact = fact;
      facts = facts;
    });
    print('try fact');
    // print(fact?.fragment);
    print(fact?.statement);
    print('Is it really a fact?');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center ,
      children: [
        CarouselWithIndicatorDemo(facts:facts),
            // Text(currFact.fact!.statement)
        SizedBox(height: 5),
        ElevatedButton(
              onPressed: () {
                getFactAPI();
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
      ] ,
    );
  }
}

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => MyAppState(),
//       child: MaterialApp(
//         title: 'Namer App',
//         theme: ThemeData(
//           useMaterial3: true,
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//         ),
//         home: MyHomePage(),
//       ),
//     );
//   }
// }

// class MyAppState extends ChangeNotifier {

//   late Fact? fact;
//   var facts = <String?>[];

//   void getFactAPI() async {
//     print('inside Getfact');
//     fact = (await ApiService().getFact());
//     facts.add(fact?.statement);
//     print('try fact');
//     // print(fact?.fragment);
//     print(fact);
//     notifyListeners();
//   }

//   var current = WordPair.random();

//   void getNext() {
//     current = WordPair.random();
//     notifyListeners();
//   }
// }

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();
//     var pair = appState.current;
//     var facts = appState.facts;
//     print('TEST');
//     print('facts');
//     print(facts);
//     // print(appState.fact);
//     // var currFact;

//     // if (appState.fact != null) {
//     //   currfact = appState.fact.fact.statement;
//     // }
//     // var currFact = appState.fact;

//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CarouselWithIndicatorDemo(),
//             BigCard(pair: pair),
//             // Text(currFact.fact!.statement)
//             SizedBox(height: 5),
//             ElevatedButton(
//               onPressed: () {
//                 appState.getFactAPI();
//               },
//               child: Text('Get Fact'),
//             ),
//             SizedBox(
//               height: 500,
//               child: ListView(
//                 children:[
//                   Padding(
//                     padding: const EdgeInsets.all(20),
//                   ),
//                   for (var fact in facts)
//                     ListTile(
//                       title: Text(fact!)
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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

// // ################# Carousel ############################
class CarouselWithIndicatorDemo extends StatefulWidget {
  final List<String?> facts;

  const CarouselWithIndicatorDemo({
    required this.facts,
  });

  @override
  State<StatefulWidget> createState() => _CarouselWithIndicatorState(facts:facts);

}


// class CarouselDemo extends StatelessWidget {
//   CarouselController buttonCarouselController = CarouselController();
class _CarouselWithIndicatorState extends State<CarouselWithIndicatorDemo> {
  int _current = 0;
  final List<String?> facts;

  _CarouselWithIndicatorState({
    required this.facts,
  });

  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    print('Carousel State');
    print(facts);
  }

 @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      CarouselSlider(
          items: facts.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.amber
                  ),
                  child: Text('$i', style: TextStyle(fontSize: 16.0),)
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
              height: 400,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: facts.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
      ),
      // ElevatedButton(
      //   onPressed: () => buttonCarouselController.nextPage(
      //       duration: Duration(milliseconds: 300), curve: Curves.linear),
      //   child: Text('→'),
      // )
    ]
  );
}
