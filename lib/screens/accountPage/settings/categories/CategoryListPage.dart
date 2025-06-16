import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../../../localization/locales.dart';
import '../../../../utils/categories.dart';
import '../../../../utils/category_icon.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocalData.categories.getString(context)),
      ),
      body: ListView.builder(
          itemCount: categoriesList.length,
          itemBuilder: (context, index) {
        return ListTile(
          title: Text(LocalData.getTranslatedCategory(context, categoriesList[index]),),
          leading: Icon(
            getCategoryIcon(categoriesList[index]),
            size: 30,
          ),
        );
      }),
    );
  }
}
