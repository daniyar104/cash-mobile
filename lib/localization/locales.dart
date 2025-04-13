import 'package:flutter/cupertino.dart';
import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> LOCALES = [
  MapLocale("en", LocalData.EN),
  MapLocale("ru", LocalData.RU),
];

mixin LocalData {
  static const String welcome = 'welcome';
  static const String title = 'title';
  static const String body = 'body';
  static const String welcomeBack = 'welcomeBack';
  static const String login = 'login';
  static const String password = 'password';
  static const String email = 'email';
  static const String username = 'username';
  static const String logout = 'logout';
  static const String account = "account";
  static const String transactions = "transactions";
  static const String expenses = "expenses";
  static const String income = "income";
  static const String showAll = "showAll";
  static const String settings = "settings";
  static const String language = "language";
  static const String pushNotifications = "pushNotifications";
  static const String stylesSetting = "stylesSetting";
  static const String templateSetting = "templateSetting";

  // Categories
  static const String food = "Food";


  static const Map<String, dynamic> EN = {
      title: 'Localiztion',
      body: 'Welcome to the localization example app. This is a simple app to demonstrate localization in Flutter. You can change the language from the settings screen.',
      welcomeBack: 'Welcome back',
      welcome: 'Welcome',
      login: 'Login',
      password: 'Password',
      email: 'Email',
      username: 'Username',
      logout: 'Logout',
      account: 'Account',
      transactions: 'Transactions',
      expenses: 'Expenses',
      income: 'Income',
      food: 'Food',
      showAll: 'Show all',
      settings: 'Settings',
      language: 'Language',
      pushNotifications: 'Notifications',
      stylesSetting: 'Styles',
      templateSetting: 'Template',
  };

  static const Map<String, dynamic> RU = {
    title: 'Локализация',
    body: 'Добро пожаловать в пример локализации приложения. Это простое приложение для демонстрации локализации в Flutter. Вы можете изменить язык на экране настроек.',
    welcomeBack: "Добро пожаловать",
    welcome: "Добро пожаловать,",
    login: "Войти",
    password: "Пароль",
    email: "Электронная почта",
    username: "Имя пользователя",
    logout: "Выйти",
    account: "Аккаунт",
    transactions: "Транзакции",
    expenses: "Расходы",
    income: "Доход",
    food: "Еда",
    showAll: "Показать все",
    settings: "Настройки",
    language: "Язык",
    pushNotifications: "Уведомления",
    stylesSetting: "Стиль",
    templateSetting: "Шаблон",
  };

  static String getTranslatedCategory(BuildContext context, String? key) {
    if (key == null) return '';
    return key.getString(context);
  }
}
