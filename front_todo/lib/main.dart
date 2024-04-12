import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:front_todo/auth.dart';
import 'package:front_todo/classes/todo.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginController(),
      child: const SpacedItemsList(),
    );
  }
}

class SpacedItemsList extends StatelessWidget {
  const SpacedItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/edit': (context) => const EditScreen(),
        '/login': (context) => LoginScreen()
      },
      title: 'Flutter Todo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        cardTheme: const CardTheme(color: Color.fromARGB(255, 250, 250, 250)),
        useMaterial3: true,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final loginController = context.watch<LoginController>();
    return ListenableBuilder(
      listenable: loginController,
      builder: (BuildContext context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Todo list'),
            centerTitle: false,
            actions: [
              if (loginController.currentUser?.name != null) ...[
                Text(loginController.currentUser!.name),
                IconButton(
                  onPressed: () => loginController.logout(),
                  icon: Icon(Icons.logout, color: Colors.pink.shade700),
                )
              ] else
                IconButton(
                  onPressed: () => Navigator.of(context).pushNamed('/login'),
                  icon: Icon(Icons.account_box, color: Colors.pink.shade700),
                )
            ]
          ),
          body: LayoutBuilder(builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: FutureBuilder(
                  future: _loadTodos(loginController),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Veuillez vous connecter pour accéder à la TODO list (en haut à droite)', style: TextStyle(color: Colors.red));
                    }
                
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final items = snapshot.data!;
                
                    return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final todo = items[index];
                
                          return ItemWidget(todo: todo);
                        }
                    );
                  }
                ),
              ),
            );
          }),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/edit',
                arguments: Todo(id: Random().nextInt(1000000), name: '', description: '', isCompleted: false)
              );
            },
          )
        );
      }
    );
  }

  Future<List<Todo>> _loadTodos(LoginController loginController) async {
    final result = await http.get(
      Uri.parse('http://localhost:3000/todos'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'Authorization': 'Bearer ${loginController.currentUser?.token}'
      },
    );

    return List.from(jsonDecode(result.body))
        .map((e) => Todo.fromMap(e))
        .toList();
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 100,
        width: 600,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ButtonListe(
            todo: todo,
          )
        ]),
      ),
    );
  }
}


class ButtonListe extends StatelessWidget {
  const ButtonListe({super.key, required this.todo});
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(todo.name),
      IconButton(
        onPressed: () {
          // Respond to button press
        },
        icon: const Icon(Icons.delete, size: 18),
      ),
      IconButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/edit',
            arguments: todo
          );
        },
        icon: const Icon(Icons.edit, size: 18),
      ),
    ]);
  }
}

class TodoController extends ChangeNotifier  {

  final _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;

  final _descriptionController = TextEditingController();
  TextEditingController get descriptionController => _descriptionController;

  bool _isCompletedController = false;
  bool get isCompletedController => _isCompletedController;

  void init(Todo todo) {
    _nameController.text = todo.name;
    _descriptionController.text = todo.description;
    _isCompletedController = todo.isCompleted;
  }
  
  void inverseIsCompleted() {
    _isCompletedController = !_isCompletedController;
    notifyListeners();
  }
}

class EditScreen extends StatelessWidget {
  const EditScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final todo = ModalRoute.of(context)!.settings.arguments as Todo;
    final todoController = TodoController();
    final loginController = context.watch<LoginController>();
    final formKey = GlobalKey<FormState>();

    todoController.init(todo);
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Tâche n°${todo.id}"),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300.0,
                    child: TextFormField(
                      controller: todoController._nameController,
                      decoration: const InputDecoration(labelText: 'Nom de la tâche'),
                      validator: (String? value) {
                        return value?.isNotEmpty == true ? null : 'Cette valeur ne peut être vide';
                    }),
                  ),
                  SizedBox(
                    width: 300.0,
                    child: TextFormField(
                      controller: todoController._descriptionController,
                      decoration: const InputDecoration(labelText: 'Description de la tâche'),
                      validator: (String? value) {
                        return value?.isNotEmpty == true ? null : 'Cette valeur ne peut être vide';
                    }),
                  ),
                  Checkbox(
                    value: todoController.isCompletedController,
                    onChanged: (bool? value) { // This is where we update the state when the checkbox is tapped
                      todoController.inverseIsCompleted();
                    },
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final result = await http.post(
                          Uri.parse('http://localhost:3000/todos'),
                          headers: {
                            "Access-Control-Allow-Origin": "*",
                            'Content-Type': 'application/json',
                            'Accept': '*/*',
                            'Authorization': 'Bearer ${loginController.currentUser?.token}'
                          },
                          body: jsonEncode({
                            "id": todo.id,
                            "name": todoController._nameController,
                            "description": todoController._descriptionController,
                            "isCompleted": todoController._isCompletedController,
                            }
                          )
                        );
                        
                        if (context.mounted) {
                          if (result.statusCode == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('La liste a été mis à jour')),
                            );
                            Navigator.of(context).pop;
                          } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Une erreur est survenue')),
                            );
                          }
                        }
                      }
                    },
                    child: const Text('Mettre a jour'),
                  ),
                ),
                TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text('Retour'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
