import 'package:alfred/alfred.dart';
import 'package:api_todo/classes/todo.dart';
import 'package:api_todo/services/in_memory.dart';
class TodosRoute {

  static get(HttpRequest req, HttpResponse res) async {
    return await inMemory.get(int.parse(req.params['id']));
  }

  static getAll(HttpRequest req, HttpResponse res) async {
    return await inMemory.getAll();
  }

  static create(HttpRequest req, HttpResponse res) async {
    final body = await req.bodyAsJsonMap;
    return await inMemory.create(Todo.fromJson(body));
  }

  static update(HttpRequest req, HttpResponse res) async {
    final body = await req.bodyAsJsonMap;
    return await inMemory.update(int.parse(req.params['id']), Todo.fromJson(body));
  }

  static delete(HttpRequest req, HttpResponse res) async {
    return await inMemory.delete(int.parse(req.params['id']));
  }
}