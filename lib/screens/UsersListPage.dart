import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:untitled1/models/UserModel.dart';

import '../db/database_helper.dart';
import 'TransactionsListPage.dart';

class UsersListPage extends StatefulWidget {
  @override
  State<UsersListPage> createState() => _UsersListPageState();
}
class _UsersListPageState extends State<UsersListPage>{
  List<UserModel> users = [];
  late FlutterLocalization _flutterLocalization;
  late String _selectedLanguage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUsers();
    _flutterLocalization = FlutterLocalization.instance;
    _selectedLanguage = _flutterLocalization.currentLocale!.languageCode;
    print(_selectedLanguage);
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
      body: Column(
        children: [
          ListView.builder(
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
          Center(
            child: DropdownButton(
                items: const [
                  DropdownMenuItem(value: "en:", child: Text("English")),
                  DropdownMenuItem(value: "ru:", child: Text("Russian")),
                ],
                onChanged: (value) {
                  _setLocal(value);
                },
            ),
          )
        ],
      ),
    );
  }
  void _setLocal(String? value) {
    if (value != null) return;
    if (value == "en"){
      _flutterLocalization.translate("en");
    }else if (value == "ru"){
      _flutterLocalization.translate("ru");
    }else{
      return;
    }
  }

}