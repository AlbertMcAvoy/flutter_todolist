import 'package:flutter/material.dart';

void main() => runApp(const SpacedItemsList());

class SpacedItemsList extends StatelessWidget {
  const SpacedItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const items = 8;

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
        onPressed: () {},
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
