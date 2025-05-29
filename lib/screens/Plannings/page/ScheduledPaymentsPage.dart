import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../db/sembast_database_helper.dart';
import '../../../localization/locales.dart';
import '../../../models/ScheduledPayment.dart';

class ScheduledPaymentsPage extends StatefulWidget {
  final int userId;
  const ScheduledPaymentsPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ScheduledPaymentsPage> createState() => _ScheduledPaymentsPageState();
}

class _ScheduledPaymentsPageState extends State<ScheduledPaymentsPage> {
  final dbHelper = SembastDatabaseHelper.instance;
  late Future<List<ScheduledPayment>> _paymentsFuture;
  String _currencySymbol = '₸';

  @override
  void initState() {
    super.initState();
    _loadCurrency();
    _loadScheduledPayments();
  }

  Future<void> _loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    final currency = prefs.getString('currency') ?? 'KZT';
    setState(() {
      _currencySymbol = _getCurrencySymbol(currency);
    });
  }

  String _getCurrencySymbol(String code) {
    switch (code) {
      case 'USD': return '\$';
      case 'EUR': return '€';
      case 'RUB': return '₽';
      case 'KZT':
      default: return '₸';
    }
  }

  void _loadScheduledPayments() {
    setState(() {
      _paymentsFuture = dbHelper.getScheduledPayments(widget.userId);
    });
  }

  Future<void> _addScheduledPayment() async {
    final newPayment = await showDialog<ScheduledPayment>(
      context: context,
      builder: (context) => AddScheduledPaymentDialog(userId: widget.userId),
    );
    if (newPayment != null) {
      await dbHelper.insertScheduledPayment(newPayment);
      _loadScheduledPayments();
    }
  }

  Future<void> _deleteScheduledPayment(int id) async {
    await dbHelper.deleteScheduledPayment(id);
    _loadScheduledPayments();
  }

  IconData _getIconFromCategory(String? category) {
    if (category == null) return Icons.payment;
    try {
      final codePoint = int.parse(category);
      return IconData(codePoint, fontFamily: 'MaterialIcons');
    } catch (_) {
      return Icons.payment;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocalData.scheduledPaymentTitle.getString(context)),
      ),
      body: FutureBuilder<List<ScheduledPayment>>(
        future: _paymentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(LocalData.errorSchedule.getString(context)));
          }
          final payments = snapshot.data ?? [];
          if (payments.isEmpty) {
            return Center(child: Text(LocalData.noScheduledPayments.getString(context)));
          }
          return ListView.builder(
            itemCount: payments.length,
            itemBuilder: (context, index) {
              final payment = payments[index];
              final iconData = _getIconFromCategory(payment.category);
              return Dismissible(
                key: Key(payment.id.toString()),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.startToEnd,
                onDismissed: (_) => _deleteScheduledPayment(payment.id!),
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      child: Icon(iconData, color: Theme.of(context).colorScheme.primary),
                    ),
                    title: Text(payment.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(payment.date.toLocal().toString().split(' ')[0]),
                    trailing: Text(
                      '$_currencySymbol ${payment.amount.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addScheduledPayment,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddScheduledPaymentDialog extends StatefulWidget {
  final int userId;
  const AddScheduledPaymentDialog({Key? key, required this.userId}) : super(key: key);

  @override
  _AddScheduledPaymentDialogState createState() => _AddScheduledPaymentDialogState();
}

class _AddScheduledPaymentDialogState extends State<AddScheduledPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  double? _amount;
  String? _title;
  DateTime _date = DateTime.now();
  IconData? _selectedIcon;

  final List<IconData> _icons = [
    Icons.restaurant,
    Icons.shopping_cart,
    Icons.receipt_long,
    Icons.local_gas_station,
    Icons.home,
    Icons.phone_android,
    Icons.movie,
    Icons.directions_car,
  ];

  @override
  void initState() {
    super.initState();
    _selectedIcon = _icons[0];
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _date = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedIcon == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocalData.selectScheduleIcon.getString(context))),
        );
        return;
      }
      _formKey.currentState?.save();
      final payment = ScheduledPayment(
        id: null,
        title: _title!,
        amount: _amount!,
        date: _date,
        category: _selectedIcon!.codePoint.toString(),
        userId: widget.userId,
        type: '',
      );
      Navigator.of(context).pop(payment);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(LocalData.addScheduledPayment.getString(context), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: LocalData.scheduledPaymentTitle.getString(context)),
                    validator: (val) => val == null || val.isEmpty ? LocalData.invalidTitle.getString(context) : null,
                    onSaved: (val) => _title = val,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: InputDecoration(labelText: LocalData.scheduledPaymentAmount.getString(context)),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (val) {
                      if (val == null || val.isEmpty || double.tryParse(val) == null) {
                        return LocalData.invalidAmount.getString(context);
                      }
                      return null;
                    },
                    onSaved: (val) => _amount = double.parse(val!),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(LocalData.selectScheduleIcon.getString(context), style: Theme.of(context).textTheme.labelLarge),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 70,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _icons.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, index) {
                        final icon = _icons[index];
                        final selected = icon == _selectedIcon;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedIcon = icon),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: selected ? Theme.of(context).colorScheme.primary.withOpacity(0.2) : null,
                              border: Border.all(
                                color: selected ? Theme.of(context).colorScheme.primary : Colors.grey,
                                width: selected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(icon, size: 28, color: selected ? Theme.of(context).colorScheme.primary : Colors.black45),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(_date.toLocal().toString().split(' ')[0]),
                      const Spacer(),
                      TextButton(
                        onPressed: _pickDate,
                        child: Text(LocalData.pickDate.getString(context)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(LocalData.cancel.getString(context)),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(LocalData.add.getString(context)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
