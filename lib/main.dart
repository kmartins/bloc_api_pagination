import 'package:flutter/material.dart';
import 'package:paginations/PaginationBloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
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
  void dispose() {
    _controller.removeListener(pagesListener);
    _controller.dispose();
    _paginationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        initialData: <Data>[],
        stream: _paginationBloc.transformed,
        builder: (BuildContext context, AsyncSnapshot<List<Data>> snapshot) {
          print("snapshot dnv");
          print(snapshot.data);
          return ListView.builder(
            controller: _controller,
            itemCount: snapshot?.data?.length ?? 0,
            itemBuilder: (ctx, i) {
              final data = snapshot.data[i];
              return Container(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 20, left: 10, right: 10),
                margin: const EdgeInsets.all(10),
                color: Colors.blueGrey,
                width: double.infinity,
                height: 200,
                child: Column(
                  children: <Widget>[
                    Text("${data.id}"),
                    Text("${data.firstName}"),
                    Text("${data.lastName}"),
                    Text("${data.email}"),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
