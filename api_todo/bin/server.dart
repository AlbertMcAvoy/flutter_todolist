import 'dart:async';

import 'package:alfred/alfred.dart';

import 'package:api_todo/routes/todos_route.dart';

FutureOr _authenticationMiddleware(HttpRequest req, HttpResponse res) async {
  res.statusCode = 401;
  await res.close();
}

FutureOr errorHandler(HttpRequest req, HttpResponse res) {
  res.statusCode = 500;
  return {'message': 'error not handled'};
}

void main() async {
  final app = Alfred(onInternalError: errorHandler);

  app.all('/todos*', (req, res) => _authenticationMiddleware);

  app.get('/todos', TodosRoute.getAll);
  app.post('/todos', TodosRoute.create);
  app.post('/todos/:id', TodosRoute.get);

  await app.listen();
}
