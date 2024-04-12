import 'package:flutter/material.dart';
import 'package:front_todo/auth.dart';
import 'package:provider/provider.dart';

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


// Future<Todo> fetchTodo() async {
//   final response = await http
//       .get(Uri.parse('https://jsonplaceholder.typicode.com/Todos/1'));

//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     return Todo.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load Todo');
//   }
// }

// class Todo {
//   final int userId;
//   final int id;
//   final String title;

//   const Todo({
//     required this.userId,
//     required this.id,
//     required this.title,
//   });

//   factory Todo.fromJson(Map<String, dynamic> json) {
//     return switch (json) {
//       {
//         'userId': int userId,
//         'id': int id,
//         'title': String title,
//       } =>
//         Todo(
//           userId: userId,
//           id: id,
//           title: title,
//         ),
//       _ => throw const FormatException('Failed to load Todo.'),
//     };
//   }
// }

class SpacedItemsList extends StatelessWidget {
  const SpacedItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/edit': (context) => const EditScreen(todo: ''),
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
    const items = 8;
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
            return SingleChildScrollView(
              child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(
                  items,
                  (index) => Column(
                    children: [
                      ItemWidget(text: 'Item $index  '),
                    ]
                  )
                ),
              ),
            ));
          }),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {},
          )
        );
      }
    );
  }

}

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 100,
        width: 600,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ButtonListe(
            text: text,
          )
        ]),
      ),
    );
  }
}


class ButtonListe extends StatelessWidget {
  const ButtonListe({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(text),
      IconButton(
        onPressed: () {
          // Respond to button press
        },
        icon: const Icon(Icons.delete, size: 18),
      ),
      IconButton(
        onPressed: () {
          // Navigator.of(context).pushNamed('/edit');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditScreen(
                        todo: text,
                      )));
        },
        icon: const Icon(Icons.edit, size: 18),
      ),
    ]);
  }
}

class EditScreen extends StatelessWidget {
  const EditScreen({super.key, required this.todo});
  final String todo;
  
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(todo),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300.0,
                    child: TextFormField(
                      decoration: InputDecoration(hintText: todo),
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
