import 'package:paginations/ApiResult.dart';
import 'package:paginations/Services.dart';
import 'package:rxdart/rxdart.dart';

class PaginationBloc {
  Function() onScroll;
  Observable<List<Data>> transformed;
  final Api api = new Api();
  final _replay = new BehaviorSubject();

  Observable get stream => _replay.stream;
  Sink get event => _replay.sink;

  PaginationBloc({this.onScroll}) {

    transformed = stream
        .startWith(1)
        .mapTo<int>(1)
        .scan<int>((b, c, i) => b + c, 0)
        .asyncMap((a) => api.getFavorites(a))
        .takeWhile((e) => e.data.isNotEmpty == true)
        .map((e) => e.data)
        .scan<List<Data>>((a, b, i) => a..addAll(b), [])
        .asBroadcastStream();

    transformed.skip(1).listen((e) => onScroll());
  }

  void dispose() {
    _replay.close();
  }
}

/*
class ApiResult {
  List items;
  int currentPage;

  ApiResult({this.items, this.currentPage});
}




class Api {
  Future<ApiResult> getFavorites(int page) async {
    List list = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
      [10, 11, 12],
      []
    ];
    List<ApiResult> items = list.map((e) {
      return ApiResult(
        currentPage: list.indexOf(e),
        items: e,
      );
    }).toList();
    print("MINHA PAGE : ${items[page - 1].items.isEmpty} e ${page - 1}");
    return Future.delayed(Duration(seconds: 1), () => items[page - 1]);
  }
}

class ApiResult {
  List items;
  int currentPage;

  ApiResult({this.items, this.currentPage});
}

*/
