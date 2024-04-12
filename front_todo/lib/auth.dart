import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class LoginController extends ChangeNotifier {

  bool _loading = false;
  bool get loading => _loading;

  String? _errorMessage;
  String? get errorMessage =>_errorMessage;

  User? _currentUser;
  User? get currentUser => _currentUser;

  final _mailController = TextEditingController();
  TextEditingController get mailController => _mailController;

  final _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;

  void login({required VoidCallback onSuccess}) async {
    _loading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    final mail = _mailController.text;
    final password = _passwordController.text;

    final result = await http.post(
        Uri.parse('http://localhost:3000/login'),
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*'
        },
        body: jsonEncode({"email": mail, "password": password})
      );
      
      _loading = false;
      if (result.statusCode == 200) {
        _currentUser = User(name: 'Auvergne Aurillac', mail: mail, token: jsonDecode(result.body)['token']);
        notifyListeners();
        onSuccess();
      } else {
        _errorMessage = "Erreur d'identification";
        notifyListeners();
      }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = context.watch<LoginController>();

    return ListenableBuilder(
      listenable: loginController,
      builder: (BuildContext context, child) {
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                      controller: loginController.mailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (String? value) {
                        return value?.contains('@') == true ? null : 'KO';
                      }),
                  TextFormField(
                      controller: loginController.passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      validator: (String? value) {
                        return (value == null || value.isEmpty) ? 'KO' : null;
                      }),
                  if (loginController.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Text(loginController.errorMessage!),
                    ),
                  loginController.loading
                      ? const Center(child: CircularProgressIndicator())
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: Navigator.of(context).pop,
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState?.validate() == true) {
                                  loginController.login(onSuccess: () {
                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                      }
                                    },);
                                }
                              },
                              child: const Text('Submit'),
                            ),
                          ],
                        )
                ]),
              ),
            ),
          ),
        );
      }
    );
  }
}

class User {
  final String name;

  final String mail;

  final String token;

  User({required this.name, required this.mail, required this.token});

  factory User.fromMap(Map<String, dynamic> data) {
    if (data case {'name': final name, 'mail': final mail, 'token': final token}) {
      return User(name: name, mail: mail, token: token);
    }

    throw Exception('Invalid user');
  }
}