import 'package:alfred/alfred.dart';
import 'package:api_todo/classes/todo.dart';
import 'package:get_it/get_it.dart';
class InMemory {

  late Map<int, Todo> todoList = {};

  final dataCount = 10;

  Future initialize() async {
    for (var i = 0; i < dataCount; i++) {
      final currentTodo = Todo(
        id: i,
        name: 'Task n°$i',
        description: 'This is n°$i task\'s the description. Cum haec taliaque sollicitas eius aures everberarent expositas semper eius modi rumoribus et patentes, varia animo tum miscente consilia, tandem id ut optimum factu elegit: et Vrsicinum primum ad se venire summo cum honore mandavit ea specie ut pro rerum tunc urgentium captu disponeretur concordi consilio, quibus virium incrementis Parthicarum gentium a arma minantium impetus frangerentur.',
        isCompleted: false
      );
      todoList[i] = currentTodo;
    }
  }

  Future create(Todo todo) async {
    final newTodo = todoList.putIfAbsent(todo.id, () => todo);
    sortFakeDb();
    return newTodo;
  }

  Future update(int id, Todo todo) async {
    if (todoList[id] == null) {
      throw AlfredException(404, {'message': 'Ressource not found'});
    }
    todoList[id] = todo;
    return todo;
  }

  Future getAll() async {
    return todoList.entries.map((entry) => entry.value).toList();
  }

  Future get(int id) async {
    if (todoList[id] == null) {
      throw AlfredException(404, {'message': 'Ressource not found'});
    }
    return todoList[id];
  }

  Future delete(int id) async {
    if (todoList[id] == null) {
      throw AlfredException(404, {'message': 'Ressource not found'});
    }
    final oldTodo = todoList.remove(id);
    sortFakeDb();
    return oldTodo;
  }

  void sortFakeDb() {
    todoList = Map.fromEntries(todoList.entries.toList()..sort((e1, e2) =>
    e1.value.id.compareTo(e2.value.id)));
  }
}

InMemory get inMemory => GetIt.instance.get<InMemory>();