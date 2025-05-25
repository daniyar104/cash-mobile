import 'package:flutter/cupertino.dart';
import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> LOCALES = [
  MapLocale("en", LocalData.EN),
  MapLocale("ru", LocalData.RU),
  MapLocale("kk", LocalData.KK),
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
  static const String analytics = "analytics";
  static const String planning = "planning";
  static const String profile = "profile";
  static const String operations = "operations";
  static const String currency = "currency";
  static const String security = "security";
  static const String key = "key";
  static const String logoutButton = "logoutButton";

  //Login
  static const String unCurrect = "unCurrect";
  static const String error = "error";
  static const String enterEmail = "enterEmail";
  static const String enterPassword = "enterPassword";
  static const String fogotPassword = "fogotPassword";
  static const String dontHaveAccount = "dontHaveAccount";
  static const String createAccount = "createAccount";

  // Register
  static const String register = "register";
  static const String createNewAccount = "createNewAccount";
  static const String usernameRequired = "usernameRequired";
  static const String emailRequired = "emailRequired";
  static const String invalidEmail = "invalidEmail";
  static const String passwordRequired = "passwordRequired";
  static const String passwordTooShort = "passwordTooShort";

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

  //Days
  static const String today = "Today";
  static const String monday = "Monday";
  static const String tuesday = "Tuesday";
  static const String wednesday = "Wednesday";
  static const String thursday = "Thursday";
  static const String friday = "Friday";
  static const String saturday = "Saturday";
  static const String sunday = "Sunday";


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

  // Schedule
  static const String schedule = "Schedule";
  static const String errorSchedule = "errorSchedule";
  static const String noScheduledPayments = "noScheduledPayments";
  static const String selectScheduleIcon = "selectScheduleIcon";
  static const String addScheduledPayment = "addScheduledPayment";
  static const String scheduledPaymentTitle = "scheduledPaymentTitle";
  static const String scheduledPaymentAmount = "scheduledPaymentAmount";
  static const String scheduledPaymentDate = "scheduledPaymentDate";
  static const String scheduledPaymentCategory = "scheduledPaymentCategory";
  static const String scheduledPaymentType = "scheduledPaymentType";
  static const String invalidAmount = "invalidAmount";
  static const String invalidTitle = "invalidTitle";
  static const String invalidDate = "invalidDate";
  static const String invalidCategory = "invalidCategory";
  static const String invalidType = "invalidType";
  static const String pickDate = "pickDate";
  static const String cancel = "cancel";
  static const String add = "add";


  //Analytics
  static const String statics = "Statistics";
  static const String balance = "Balance";
  static const String averageExpense = "Average Expense";
  static const String maxExpense = "Max Expense";
  static const String categoryExpanses = "Category Expenses";
  static const String monthlyExpanses = "Monthly Expenses";



  // Onboarding components
  static const String onboardingNextButton = 'onboardingNextButton';
  static const String onboardingSkipButton = 'onboardingSkipButton';
  static const String onboardingDoneButton = 'onboardingDoneButton';
  // Onboarding Page 1
  static const String onboardingTitle01 = 'onboardingTitle01';
  static const String onboardingBodyText01 = 'onboardingBodyText01';

  // Onboarding Page 2
  static const String onboardingTitle02 = 'onboardingTitle02';
  static const String onboardingBodyText02 = 'onboardingBodyText02';

  // Onboarding Page 3
  static const String onboardingTitle03 = 'onboardingTitle03';
  static const String onboardingBodyText03 = 'onboardingBodyText03';


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
      analytics: 'Analytics',
      planning: 'Planning',
      profile: 'Profile',
      operations: 'Operations',
      currency: 'Currency',
      security: 'Security',
      key: 'Key',
      logoutButton: 'Logout',


      // Login Page
      unCurrect: "Incorrect email or password",
      enterEmail: 'Please enter email',
      enterPassword: 'Please enter password',
      fogotPassword: 'Forgot password?',
      dontHaveAccount: 'Don\'t have an account?',
      createAccount: 'Create account',
      error: "Ops, something went wrong.",

      // Register
      register: 'Registration',
      createNewAccount: 'Create new account',
      usernameRequired: 'Username is required',
      emailRequired: 'Email is required',
      invalidEmail: 'Invalid email',
      passwordRequired: 'Password is required',
      passwordTooShort: 'Password must be at least 6 characters long',

      // List
      allType: 'All',
      incomeType: 'Income',
      expenseType: 'Expense',
      transfer: 'Transfer',


      // Schedule
      schedule: 'Schedule',
      errorSchedule: 'Error',
      noScheduledPayments: 'No scheduled payments',
      selectScheduleIcon: 'Select icon',
      addScheduledPayment: 'Add scheduled payment',
      scheduledPaymentTitle: 'Title',
      scheduledPaymentAmount: 'Amount',
      scheduledPaymentDate: 'Date',
      scheduledPaymentCategory: 'Category',
      scheduledPaymentType: 'Type',
      invalidAmount: 'Invalid amount',
      invalidTitle: 'Invalid title',
      invalidDate: 'Invalid date',
      invalidCategory: 'Invalid category',
      invalidType: 'Invalid type',
      pickDate: 'Pick date',
      cancel: 'Cancel',
      add: 'Add',
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

      // Analytics
      statics: 'Statistics',
      balance: 'Balance',
      averageExpense: 'Average Expense',
      maxExpense: 'Max Expense',
      categoryExpanses: 'Category Expenses',
      monthlyExpanses: 'Monthly Expenses',

      // Days
      today: "Today",
      monday: 'Monday',
      tuesday: 'Tuesday',
      wednesday: 'Wednesday',
      thursday: 'Thursday',
      friday: 'Friday',
      saturday: 'Saturday',
      sunday: 'Sunday',

      // Onboarding components
      onboardingNextButton: 'Next',
      onboardingSkipButton: 'Skip',
      onboardingDoneButton: 'Done',

      // Onboarding Page 1
      onboardingTitle01: 'Welcome to the App',
      onboardingBodyText01: 'Using the app to control your finances is a pleasure.',

      // Onboarding Page 2
      onboardingTitle02: 'Comfortable.',
      onboardingBodyText02: 'Simply and quickly add expenses, income, debts, and transfers.',

      // Onboarding Page 3
      onboardingTitle03: 'Visual analytics',
      onboardingBodyText03: 'Find unnecessary expenses and reduce them.',

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
    analytics: "Аналитика",
    planning: "Планирование",
    profile: "Профиль",
    operations: "Операции",
    currency: "Валюта",
    security: "Безопасность",
    key: "Ключ",
    logoutButton: "Выйти",


    // Login Page
    unCurrect: "Неверная электронная почта или пароль",
    enterEmail: "Пожалуйста, введите электронную почту",
    enterPassword: "Пожалуйста, введите пароль",
    fogotPassword: "Забыли пароль?",
    dontHaveAccount: "Нет аккаунта?",
    createAccount: "Создать аккаунт",
    error: "Упс, что-то пошло не так.",
    // Register
    register: "Регистрация",
    createNewAccount: "Создать аккаунт",
    usernameRequired: "Имя пользователя обязательно",
    emailRequired: "Электронная почта обязательна",
    invalidEmail: "Недействительная электронная почта",
    passwordRequired: "Пароль обязателен",
    passwordTooShort: "Пароль должен содержать не менее 6 символов",


    // Schedule
    schedule: "Расписание",
    errorSchedule: "Ошибка",
    noScheduledPayments: "Нет запланированных платежей",
    selectScheduleIcon: "Выберите иконку",
    addScheduledPayment: "Добавить запланированный платеж",
    scheduledPaymentTitle: "Название",
    scheduledPaymentAmount: "Сумма",
    scheduledPaymentDate: "Дата",
    scheduledPaymentCategory: "Категория",
    scheduledPaymentType: "Тип",
    invalidAmount: "Недействительная сумма",
    invalidTitle: "Недействительное название",
    invalidDate: "Недействительная дата",
    invalidCategory: "Недействительная категория",
    invalidType: "Недействительный тип",
    pickDate: "Выбрать дату",
    cancel: "Отмена",
    add: "Добавить",

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

    // Days
    today: "Сегодня",
    // monday: "Понедельник",
    // tuesday: "Вторник",
    // wednesday: "Среда",
    // thursday: "Четверг",
    // friday: "Пятница",
    // saturday: "Суббота",
    // sunday: "Воскресенье",

    monday: "ПН",
    tuesday: "ВТ",
    wednesday: "СР",
    thursday: "ЧТ",
    friday: "ПТ",
    saturday: "СБ",
    sunday: "ВСК",

    // Analytics
    statics: "Статистика",
    balance: "Баланс",
    averageExpense: "Средний расход",
    maxExpense: "Макс. расход",
    categoryExpanses: "Расходы по категориям",
    monthlyExpanses: "Ежемесячные расходы",

    // Onboarding components
    onboardingNextButton: 'Далее',
    onboardingSkipButton: 'Пропустить',
    onboardingDoneButton: 'Готово',

    // Onboarding Page 1
    onboardingTitle01: 'Добро пожаловать в приложение',
    onboardingBodyText01: 'Использовать приложение для контроля ваших финансов - это удовольствие.',
    // Onboarding Page 2
    onboardingTitle02: 'Удобно',
    onboardingBodyText02: 'Просто и быстро добавляйте расходы, доходы, долги, переводы..',
    // Onboarding Page 3
    onboardingTitle03: 'Наглядная аналитика',
    onboardingBodyText03: 'Находите лишние расходы и сокращайте их.',
  };

  static const Map<String, dynamic> KK = {
    title: 'Локализация',
    body: 'Локализация үлгісі қолданбасына қош келдіңіз. Бұл Flutter-де локализацияны көрсету үшін қарапайым қолданба. Сіз тілді параметрлер экранынан өзгерте аласыз.',
    welcomeBack: "Қайта оралуыңызбен",
    welcome: "Қош келдіңіз,",
    login: "Кіру",
    password: "Құпиясөз",
    email: "Электрондық пошта",
    username: "Пайдаланушы аты",
    logout: "Шығу",
    account: "Есеп",
    transactions: "Транзакциялар",
    expenses: "Шығындар",
    income: "Кіріс",
    showAll: "Барлығын көрсету",
    settings: "Параметрлер",
    language: "Тіл",
    pushNotifications: "Хабарламалар",
    stylesSetting: "Стиль",
    templateSetting: "Үлгі",
    categories: "Санаттар",
    summary: "Жалпы баланс",
    analytics: "Аналитика",
    planning: "Жоспарлау",
    profile: "Профиль",
    operations: "Операциялар",
    currency: "Валюта",
    security: "Қауіпсіздік",
    key: "Кілт",
    logoutButton: "Шығу",


    // Login Page
    unCurrect: "Электрондық пошта немесе құпиясөз қате",
    enterEmail: "Электрондық поштаны енгізіңіз",
    enterPassword: "Құпиясөзді енгізіңіз",
    fogotPassword: "Құпиясөзді ұмыттыңыз ба?",
    dontHaveAccount: "Есеп жоқ па?",
    createAccount: "Есеп жасау",
    error: "Упс, бір нәрсе дұрыс емес.",

    // Register
    register: "Тіркелу",
    createNewAccount: "Жаңа есеп жасау",
    usernameRequired: "Пайдаланушы аты қажет",
    emailRequired: "Электрондық пошта қажет",
    invalidEmail: "Электрондық пошта жарамсыз",
    passwordRequired: "Құпиясөз қажет",
    passwordTooShort: "Құпиясөз кемінде 6 таңбадан тұруы керек",

    // List
    allType: "Барлығы",
    incomeType: "Кіріс",
    expenseType: "Шығын",
    transfer: "Аудару",

    // Schedule
    schedule: "Кесте",
    errorSchedule: "Қате",
    noScheduledPayments: "Жоспарланған төлемдер жоқ",
    selectScheduleIcon: "Иконканы таңдаңыз",
    addScheduledPayment: "Жоспарланған төлем қосу",
    scheduledPaymentTitle: "Атауы",
    scheduledPaymentAmount: "Сомасы",
    scheduledPaymentDate: "Күні",
    scheduledPaymentCategory: "Санаты",
    scheduledPaymentType: "Түрі",
    invalidAmount: "Жарамсыз сома",
    invalidTitle: "Жарамсыз атау",
    invalidDate: "Жарамсыз күн",
    invalidCategory: "Жарамсыз санат",
    invalidType: "Жарамсыз түр",
    pickDate: "Күнді таңдаңыз",
    cancel: "Бас тарту",
    add: "Қосу",


    //Time greeting
    morning: "Қайырлы таң",
    afternoon: "Қайырлы күн",
    evening: "Қайырлы кеш",
    night: "Қайырлы түн",

    // Categories
    food: "Тамақ",
    transportation: "Көлік",
    entertainment: "Ойын-сауық",
    shopping: "Сауда",
    health: "Денсаулық",
    bills: "Төлемдер",
    utilities: "Коммуналдық қызметтер",
    salary: "Жалақы",
    investment: "Инвестиция",
    education: "Білім",
    travel: "Саяхат",
    groceries: "Азық-түлік",
    housing: "Тұрғын үй",
    leisure: "Демалыс",
    gifts: "Сыйлықтар",
    donations: "Қайырымдылық",
    subscriptions: "Жазылымдар",
    pets: "Үй жануарлары",
    insurance: "Сақтандыру",
    other: "Басқа",

    // Days
    today: "Бүгін",
    monday: "ДСН",
    tuesday: "ССБ",
    wednesday: "СРБ",
    thursday: "БСН",
    friday: "ЖМБ",
    saturday: "СНБ",
    sunday: "ЖЕК",

    // Analytics
    statics: "Статистика",
    balance: "Баланс",
    averageExpense: "Орташа шығын",
    maxExpense: "Макс. шығын",
    categoryExpanses: "Санат бойынша шығындар",
    monthlyExpanses: "Айлық шығындар",


    // Schedule


    // Onboarding components
    onboardingNextButton: 'Келесі',
    onboardingSkipButton: 'Откызу',
    onboardingDoneButton: 'Бастау',

    // Onboarding Page 1
    onboardingTitle01: 'Қолданбаға қош келдіңіз',
    onboardingBodyText01: 'Сіздің қаржыларыңызды бақылау үшін қолданбаны пайдалану - бұл ләззат.',
    // Onboarding Page 2
    onboardingTitle02: 'Ыңғайлы.',
    onboardingBodyText02: 'Шығындарды, кірістерді, қарыздарды және аударымдарды оңай және жылдам қосыңыз.',
    // Onboarding Page 3
    onboardingTitle03: 'Көрнекі аналитика',
    onboardingBodyText03: "Қосымша шығындарды табыңыз және оларды қысқартыңыз."
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
