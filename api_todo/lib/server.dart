import 'package:alfred/alfred.dart';
import 'package:api_todo/middleware.dart';
import 'package:api_todo/routes/authenthication_route.dart';
import 'package:api_todo/routes/todos_route.dart';

class Server {
  final app = Alfred();

  Future start({int port = 3000}) async {
    app.get('/status', (req, res) => 'Server Online');

    app.post('/login', Authenthication.login);

    app.get('/todos', TodosRoute.getAll, middleware: [Middleware.isAuthenticated]);
    app.post('/todos', TodosRoute.create, middleware: [Middleware.isAuthenticated]);
    app.get('/todos/:id', TodosRoute.get, middleware: [Middleware.isAuthenticated]);
    app.put('/todos/:id', TodosRoute.update, middleware: [Middleware.isAuthenticated]);
    app.delete('/todos/:id', TodosRoute.delete, middleware: [Middleware.isAuthenticated]);

    await app.listen(port);
  }
}