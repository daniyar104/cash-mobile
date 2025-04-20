import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../db/database_factory.dart';
import '../../db/database_helper.dart';
import '../../db/sembast_database_helper.dart';
import '../../localization/locales.dart';
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

  final _dbHelper = getDatabaseHelper();

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
      appBar: AppBar(title: Text(LocalData.register.getString(context))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                      labelText: LocalData.username.getString(context),
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                      //labelText: LocalData.password.getString(context),
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                  )
              ),
              SizedBox(height: 20),
              TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: LocalData.email.getString(context),
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.grey,
                      ),
                      //labelText: LocalData.password.getString(context),
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                  )
              ),
              SizedBox(height: 20),
              TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      labelText: LocalData.password.getString(context),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                      //labelText: LocalData.password.getString(context),
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                  ),
                  obscureText: true),
              SizedBox(height: 30),
              ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text(LocalData.createNewAccount.getString(context),
                    style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onPrimary),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}