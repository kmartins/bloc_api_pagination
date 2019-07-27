import 'package:dio/dio.dart';
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
        .scan<List<Data>>((a, b, i) => a..addAll(b), []).asBroadcastStream();

    transformed.skip(1).listen((e) => onScroll());
  }

  void dispose() {
    _replay.close();
  }
}

class Api {
  Future<ApiResult> getFavorites(int page) async {
    Response response = await Dio().get("https://reqres.in/api/users?page=$page");
    return ApiResult.fromJson(response.data);
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

class ApiResult {
  int page;
  int perPage;
  int total;
  int totalPages;
  List<Data> data;

  ApiResult({this.page, this.perPage, this.total, this.totalPages, this.data});

  ApiResult.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    perPage = json['per_page'];
    total = json['total'];
    totalPages = json['total_pages'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['per_page'] = this.perPage;
    data['total'] = this.total;
    data['total_pages'] = this.totalPages;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int id;
  String email;
  String firstName;
  String lastName;
  String avatar;

  Data({this.id, this.email, this.firstName, this.lastName, this.avatar});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['avatar'] = this.avatar;
    return data;
  }
}
