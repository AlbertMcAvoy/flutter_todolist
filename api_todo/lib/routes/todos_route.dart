import 'package:alfred/alfred.dart';
import 'package:api_todo/services/services.dart';

class TodosRoute {

  static login(HttpRequest req, HttpResponse res) async {
    final body = await req.bodyAsJsonMap;
    final email = body['email'];
    final password = body['password'];

    if (email == null || email == '' || 
        password == null || password == ''
      ) {
        throw AlfredException(401, {'message': 'Invalid Credentials'});
    }

    if (email == services.EMAIL && password == services.PASSWORD) {
    }
  }

  static get(HttpRequest req, HttpResponse res) {}

  static getAll(HttpRequest req, HttpResponse res) {}

  static create(HttpRequest req, HttpResponse res) {}

}