import 'package:flutter/material.dart';

import '../../db/database_helper.dart';
import '../../db/sembast_database_helper.dart';
import '../../models/UserModel.dart';

class RegistrationPage extends StatefulWidget{
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage>{
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _dbHelper = SembastDatabaseHelper();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final newUser = UserModel(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
      // final newUserId = await DataBaseHelper.instance.insertUser(newUser);
      final newUserId = await _dbHelper.insertUser(newUser);
      if (newUserId > 0) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _usernameController, decoration: InputDecoration(labelText: 'Username')),
              TextFormField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
              TextFormField(controller: _passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
              ElevatedButton(onPressed: _register, child: Text('Register')),
            ],
          ),
        ),
      ),
    );
  }
}