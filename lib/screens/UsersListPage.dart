import 'package:flutter/material.dart';
import 'package:untitled1/models/UserModel.dart';

import '../db/database_helper.dart';
import 'TransactionsListPage.dart';

class UsersListPage extends StatefulWidget {
  @override
  State<UsersListPage> createState() => _UsersListPageState();
}
class _UsersListPageState extends State<UsersListPage>{
  List<UserModel> users = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUsers();
  }
  Future<void> _loadUsers() async {
    users = await DataBaseHelper.instance.getUsers();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(user.username ?? 'Unknown'),
            subtitle: Text(user.email ?? ''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionsListPage(userID: user.id!),
                ),
              );
            },
          );
        },
      ),
    );
  }

}