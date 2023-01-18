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
            CarouselWithIndicatorDemo(),
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

// ################# Carousel ############################
class CarouselWithIndicatorDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}


// class CarouselDemo extends StatelessWidget {
//   CarouselController buttonCarouselController = CarouselController();
class _CarouselWithIndicatorState extends State<CarouselWithIndicatorDemo> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

 @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      CarouselSlider(
          items: [1,2,3,4,5].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.amber
                  ),
                  child: Text('text $i', style: TextStyle(fontSize: 16.0),)
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
        children: [1,2,3,4,5].asMap().entries.map((entry) {
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
