import 'package:flutter/material.dart';
import 'package:paginations/PaginationBloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PaginationBloc _paginationBloc;
  ScrollController _controller;
  @override
  void initState() {
    _paginationBloc = new PaginationBloc(
      onScroll: showPopUp,
    );
    _controller = new ScrollController();
    _controller.addListener(pagesListener);
    super.initState();
  }

  void pagesListener() {
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 3) {
      _paginationBloc.event.add(null);
    }
  }

  void showPopUp() {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("Hello"),
              content: Container(
                child: Text("Scroll new page"),
              ),
              actions: <Widget>[],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        initialData: [],
        stream: _paginationBloc.transformed,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          print("snapshot dnv");
          print(snapshot.data);
          return ListView.builder(
            controller: _controller,
            itemCount: snapshot?.data?.length ?? 0,
            itemBuilder: (ctx, i) {
              return Container(
                margin: const EdgeInsets.all(10),
                color: Colors.red,
                width: 200,
                height: 200,
              );
            },
          );
        },
      ),
    );
  }
}
