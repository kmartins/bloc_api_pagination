import 'package:rxdart/rxdart.dart';

class PaginationBloc {
  Function() onScroll;
  Observable<List> transformed;
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
        .takeWhile((e) => e.items.isNotEmpty == true)
        .map((e) => e.items)
        .scan<List>((a, b, i) => a..addAll(b), [])
        .asBroadcastStream();

    transformed
    .skip(1)
    .listen((e) => onScroll());
  }

  void dispose() {
    _replay.close();
  }
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
