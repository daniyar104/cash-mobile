import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../../../db/sembast_database_helper.dart';
import '../../../localization/locales.dart';
import '../../../models/ScheduledPayment.dart';

class ScheduledPaymentsPage extends StatefulWidget {
  final int userId;

  const ScheduledPaymentsPage({Key? key, required this.userId}) : super(key: key);

  @override
  _ScheduledPaymentsPageState createState() => _ScheduledPaymentsPageState();
}

class _ScheduledPaymentsPageState extends State<ScheduledPaymentsPage> {
  final dbHelper = SembastDatabaseHelper.instance;
  late Future<List<ScheduledPayment>> _paymentsFuture;

  @override
  void initState() {
    super.initState();
    _loadScheduledPayments();
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
            return Center(child: CircularProgressIndicator());
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
                  padding: EdgeInsets.only(left: 16),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.startToEnd,
                onDismissed: (_) => _deleteScheduledPayment(payment.id!),
                child: ListTile(
                  leading: Icon(iconData),
                  title: Text(payment.title),
                  subtitle: Text(payment.date.toLocal().toString().split(' ')[0]),
                  trailing: Text(payment.amount.toStringAsFixed(0), style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  )),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addScheduledPayment,
        child: Icon(Icons.add),
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
  DateTime? _date;
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
    _date = DateTime.now();
    _selectedIcon = _icons[0]; // По умолчанию первая иконка выбрана
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
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
        date: _date!,
        category: _selectedIcon!.codePoint.toString(), // Сохраняем код иконки как строку
        userId: widget.userId,
        type: '',
      );
      Navigator.of(context).pop(payment);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(LocalData.addScheduledPayment.getString(context)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: LocalData.scheduledPaymentTitle.getString(context)),
                validator: (val) => val == null || val.isEmpty ? LocalData.invalidTitle.getString(context) : null,
                onSaved: (val) => _title = val,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: LocalData.scheduledPaymentAmount.getString(context)),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (val) {
                  if (val == null || val.isEmpty) return LocalData.invalidAmount.getString(context);
                  if (double.tryParse(val) == null) return LocalData.invalidAmount.getString(context);
                  return null;
                },
                onSaved: (val) => _amount = double.parse(val!),
              ),
              SizedBox(height: 12),
              Text(LocalData.selectScheduleIcon.getString(context)),
              SizedBox(height: 8),
              Container(
                height: 80,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_icons.length, (index) {
                      final icon = _icons[index];
                      final selected = icon == _selectedIcon;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedIcon = icon),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: selected ? Colors.blueAccent.withOpacity(0.3) : null,
                            border: Border.all(
                              color: selected ? Colors.blue : Colors.grey,
                              width: selected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.all(8),
                          child: Icon(icon, size: 30, color: selected ? Colors.blue : Colors.black54),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Text(_date != null ? _date!.toLocal().toString().split(' ')[0] : LocalData.pickDate.getString(context)),
                  Spacer(),
                  TextButton(onPressed: _pickDate, child: Text(LocalData.pickDate.getString(context))),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(LocalData.cancel.getString(context))),
        ElevatedButton(onPressed: _submit, child: Text(LocalData.add.getString(context))),
      ],
    );
  }
}
