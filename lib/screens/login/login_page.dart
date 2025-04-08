  import 'package:flutter/material.dart';
  import 'package:untitled1/db/database_helper.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:untitled1/screens/MainScreen.dart';
  import '../../db/app_database_helper.dart';
import '../../db/database_factory.dart';
import '../../db/sembast_database_helper.dart';
import '../../models/UserModel.dart';
  import '../register/RegistrationPage.dart';

  class LoginPage extends StatefulWidget {
    const LoginPage({super.key});

    @override
    State<LoginPage> createState() => _LoginPageState();
  }

  class _LoginPageState extends State<LoginPage> {

    final _formKey = GlobalKey<FormState>();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _dbHelper = getDatabaseHelper();
    Future<void> _login() async {
      if(_formKey.currentState!.validate()){
        final email = _emailController.text;
        final password = _passwordController.text;

        final users = await _dbHelper.getUsers();
        final user = users.firstWhere(
              (user) => user.email == email && user.password == password,
          orElse: () => UserModel(id: -1),
        );

        if (user.id != -1) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('userId', user.id!);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(),
            ),(route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid email or password')),
          );
        }
      }
    }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'Sign in',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Sign In',
                    style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  style: ElevatedButton.styleFrom(
                    // primary: Colors.blue,
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistrationPage()),
                    );
                  },
                  child: Text('You dont have account? Create account'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
