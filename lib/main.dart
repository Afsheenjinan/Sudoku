import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<List<int>> grid = List.generate(9, (index) => [1, 2, 9, 7, 5, 6, 3, 8, 4]..shuffle());
    print(grid);
    List<int> flatten_grid = grid.expand((element) => element).toList();
    print(flatten_grid);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Center(
          child: Stack(
            children: <Widget>[
              const SizedBox(
                height: 360,
                width: 360,
                child: GridPaper(
                  divisions: 1,
                  interval: 360 / 3,
                  subdivisions: 3,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 360,
                width: 360,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 9,
                  ),
                  itemCount: 81,
                  itemBuilder: (BuildContext context, int index) {
                    return Material(
                      borderOnForeground: true,
                      child: InkWell(
                        onTap: () => selectContainer(),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, style: BorderStyle.solid),
                          ),
                          child: Center(
                            child: Text('${flatten_grid[index]}'),
                          ),
                        ),
                      ),
                    );
                  },
                  // children: List<Widget>.generate(flatten_grid.length, (int i) {
                  //   return Builder(builder: (BuildContext context) {
                  //     return Center(
                  //       child: Container(
                  //         decoration: BoxDecoration(border: Border.all(color: Colors.blue, style: BorderStyle.solid)),
                  //         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  //         child: Text(
                  //           '${flatten_grid[i]}',
                  //           textAlign: TextAlign.center,
                  //         ),
                  //       ),
                  //     );
                  //   });
                  // }),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void selectContainer() => debugPrint("Container was tapped");
}
