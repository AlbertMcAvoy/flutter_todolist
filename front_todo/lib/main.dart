import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front_todo/auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

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
        '/edit': (context) => EditScreen(todo: Todo(id: int.parse(const Uuid().v4()), name: '', description: '', isCompleted: false)),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditScreen(
                    todo: Todo(
                      id: int.parse(const Uuid().v4()),
                      name: '',
                      description: '',
                      isCompleted: false
                    ),
                  )
                )
              );
            },
          )
        );
      }
    );
  }

  Future<List<Todo>> _loadTodos(LoginController loginController) async {
    final token = loginController.currentUser?.token;
    final result = await http.get(
      Uri.parse('http://localhost:3000/todos'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'Authorization': 'Bearer $token'
      },
    );

    return List.from(jsonDecode(result.body))
        .map((e) => Todo.fromMap(e))
        .toList();
  }
}

class Todo {
  int id;
  String name;
  String description;
  bool isCompleted;

  Todo ({
    this.id = 0,
    this.name = '',
    this.description = '',
    this.isCompleted = false
  });

  Todo.fromMap(Map<String, dynamic> data)
    : id = data['id'],
      name = data['name'],
      description = data['description'],
      isCompleted = data['isCompleted'];
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditScreen(
                todo: todo,
              )
            )
          );
        },
        icon: const Icon(Icons.edit, size: 18),
      ),
    ]);
  }
}

class EditScreen extends StatelessWidget {
  const EditScreen({super.key, required this.todo});
  final Todo todo;
  
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(todo.name),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300.0,
                    child: TextFormField(
                      decoration: InputDecoration(hintText: todo.name),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Le champs text ne peut pas etre vide !";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('La liste a été mis à jour')),
                        );
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
