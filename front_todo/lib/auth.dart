import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Connexion';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
       body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    appTitle,
                    style: TextStyle(
                      fontSize: 24, // Définir la taille de la police
                      fontWeight: FontWeight.bold, // Optionnel: définir le poids de la police
                    ),
                  ),
                  MyCustomForm(),
                ],
              ),
            ),
          ],
       ),
      )
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 300.0,
            
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "email"
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "L'email ne peut pas etre vide !";
                }
                return null;
              },
            ),
          ),
          
          SizedBox(
            width: 300.0,
            child: TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: "mot de passe"
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Le mot de passe ne peut pas etre vide";
                }
                return null;
              },
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Connexion réussie')),
                  );
                }
              },
              child: const Text('Se connecter'),
            ),
          ),
        ],
      ),
    );
  }
}
