import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const SpacedItemsList());

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
        '/': (context) => Home(),
        '/edit': (context) => EditScreen(todo: ''),
      },
      title: 'Flutter Todo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        cardTheme: CardTheme(color: Color.fromARGB(255, 250, 250, 250)),
        useMaterial3: true,
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => HomeScreen();
}

class HomeScreen extends State<Home> {
  // const HomeScreen({Key? key}) : super(key: key);
    var items = 1;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
            child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(
                items,
                (index) => Column(children: [
                      ItemWidget(text: 'Item $index  '),
                    ])),
          ),
        ));
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          items = items + 1;
          print(items);
          setState(() {});  
        },
      ),
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
  const ButtonListe({Key? key, required this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(text),
      IconButton(
        onPressed: () {
          // Respond to button press
        },
        icon: Icon(Icons.delete, size: 18),
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
        icon: Icon(Icons.edit, size: 18),
      ),
    ]);
  }
}

class EditScreen extends StatelessWidget {
  const EditScreen({Key? key, required this.todo}) : super(key: key);
  final String todo;
  
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(todo),
            TextButton(
              child: const Text('Retour'),
              onPressed: Navigator.of(context).pop,
            ),
            Form(
              key: _formKey,
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
            Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('La liste a été mis à jour')),
                  );
                }
              },
              child: const Text('Mettre a jour'),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
