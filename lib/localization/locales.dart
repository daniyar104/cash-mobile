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
  static const String categories = "categories";
  static const String summary = "summary";


  //Login
  static const String unCurrect = "unCurrect";
  static const String enterEmail = "enterEmail";
  static const String enterPassword = "enterPassword";
  static const String fogotPassword = "fogotPassword";
  static const String dontHaveAccount = "dontHaveAccount";
  static const String createAccount = "createAccount";

  // Register
  static const String register = "register";
  static const String createNewAccount = "createNewAccount";
  // List
  static const String allType = "All";
  static const String incomeType = "Income";
  static const String expenseType = "Expense";
  static const String transfer = "Transfer";
  //Time Greeting
  static const String morning = "morning";
  static const String afternoon = "afternoon";
  static const String evening = "evening";
  static const String night = "night";


  // Categories
  static const String food = "Food";
  static const String transportation = "Transportation";
  static const String entertainment = "Entertainment";
  static const String shopping = "Shopping";
  static const String health = "Health";
  static const String bills = "Bills";
  static const String utilities = "Utilities";
  static const String salary = "Salary";
  static const String investment = "Investment";
  static const String education = "Education";
  static const String travel = "Travel";
  static const String groceries = "Groceries";
  static const String housing = "Housing";
  static const String leisure = "Leisure";
  static const String gifts = "Gifts";
  static const String donations = "Donations";
  static const String subscriptions = "Subscriptions";
  static const String pets = "Pets";
  static const String insurance = "Insurance";
  static const String other = "Other";



  static const Map<String, dynamic> EN = {
      title: 'Localiztion',
      body: 'Welcome to the localization example app. This is a simple app to demonstrate localization in Flutter. You can change the language from the settings screen.',
      welcomeBack: 'Welcome back',
      welcome: 'Welcome,',
      login: 'Login',
      password: 'Password',
      email: 'Email',
      username: 'Username',
      logout: 'Logout',
      account: 'Account',
      transactions: 'Transactions',
      expenses: 'Expenses',
      income: 'Income',
      showAll: 'Show all',
      settings: 'Settings',
      language: 'Language',
      pushNotifications: 'Notifications',
      stylesSetting: 'Styles',
      templateSetting: 'Template',
      categories: 'Categories',
      summary: 'Total Balance',

      // Login Page
      unCurrect: "Incorrect email or password",
      enterEmail: 'Please enter email',
      enterPassword: 'Please enter password',
      fogotPassword: 'Forgot password?',
      dontHaveAccount: 'Don\'t have an account?',
      createAccount: 'Create account',

      // Register
      register: 'Registration',
      createNewAccount: 'Create new account',

      // List
      allType: 'All',
      incomeType: 'Income',
      expenseType: 'Expense',
      transfer: 'Transfer',

      //Time greeting
      morning: 'Good morning',
      afternoon: 'Good afternoon',
      evening: 'Good evening',
      night: 'Good night',

      // Categories
      food: 'Food',
      transportation: 'Transportation',
      entertainment: 'Entertainment',
      shopping: 'Shopping',
      health: 'Health',
      bills: 'Bills',
      utilities: 'Utilities',
      salary: 'Salary',
      investment: 'Investment',
      education: 'Education',
      travel: 'Travel',
      groceries: 'Groceries',
      housing: 'Housing',
      leisure: 'Leisure',
      gifts: 'Gifts',
      donations: 'Donations',
      subscriptions: 'Subscriptions',
      pets: 'Pets',
      insurance: 'Insurance',
      other: 'Other',

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
    expenses: "Расход",
    income: "Доход",
    showAll: "Показать все",
    settings: "Настройки",
    language: "Язык",
    pushNotifications: "Уведомления",
    stylesSetting: "Стиль",
    templateSetting: "Шаблон",
    categories: "Категории",
    summary: "Общий баланс",


    // Login Page
    unCurrect: "Неверная электронная почта или пароль",
    enterEmail: "Пожалуйста, введите электронную почту",
    enterPassword: "Пожалуйста, введите пароль",
    fogotPassword: "Забыли пароль?",
    dontHaveAccount: "Нет аккаунта?",
    createAccount: "Создать аккаунт",

    // Register
    register: "Регистрация",
    createNewAccount: "Создать аккаунт",

    // List
    allType: "Все",
    incomeType: "Доход",
    expenseType: "Расход",
    transfer: "Перевод",

    //Time greeting
    morning: "Доброе утро",
    afternoon: "Добрый день",
    evening: "Добрый вечер",
    night: "Доброй ночи",


    // Categories
    food: "Еда",
    transportation: "Транспорт",
    entertainment: "Развлечения",
    shopping: "Покупки",
    health: "Здоровье",
    bills: "Счета",
    utilities: "Ком-услуги",
    salary: "Зарплата",
    investment: "Инвестиции",
    education: "Образование",
    travel: "Путешествия",
    groceries: "Продукты",
    housing: "Жилище",
    leisure: "Досуг",
    gifts: "Подарки",
    donations: "Пожертвования",
    subscriptions: "Подписки",
    pets: "Животные",
    insurance: "Страхование",
    other: "Другое",
  };

  static String getTranslatedCategory(BuildContext context, String? key) {
    if (key == null) return '';
    return key.getString(context);
  }
  static List<String> getCategories(BuildContext context) {
    return [
      getTranslatedCategory(context, 'Food'),
      getTranslatedCategory(context, 'Transportation'),
      getTranslatedCategory(context, 'Entertainment'),
      getTranslatedCategory(context, 'Shopping'),
      getTranslatedCategory(context, 'Health'),
      getTranslatedCategory(context, 'Bills'),
      getTranslatedCategory(context, 'Utilities'),
      getTranslatedCategory(context, 'Salary'),
      getTranslatedCategory(context, 'Investment'),
      getTranslatedCategory(context, 'Education'),
      getTranslatedCategory(context, 'Travel'),
      getTranslatedCategory(context, 'Groceries'),
      getTranslatedCategory(context, 'Housing'),
      getTranslatedCategory(context, 'Leisure'),
      getTranslatedCategory(context, 'Gifts'),
      getTranslatedCategory(context, 'Donations'),
      getTranslatedCategory(context, 'Subscriptions'),
      getTranslatedCategory(context, 'Pets'),
      getTranslatedCategory(context, 'Insurance'),
      getTranslatedCategory(context, 'Other'),
    ];
  }
}
