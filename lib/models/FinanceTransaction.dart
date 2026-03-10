import 'package:expense_tracker/models/Category.dart';

class FinanceTransaction {
  final int? id;
  final String title;
  final double amount;
  final DateTime date;
  final List<Category> categories;

  const FinanceTransaction(
      {this.id,
      required this.title,
      required this.amount,
      required this.date,
      this.categories = const []});
  // Mapping dal DB
  factory FinanceTransaction.fromMap(Map<String, dynamic> map, {List<Category> categories = const []}) {
    return FinanceTransaction(
      id: map['id'],
      title: map['name'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      categories: categories,
    );
  }

  // Mapping per il DB (escludiamo le categorie perché vanno nella tabella pivot)
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': title,
        'amount': amount,
        'date': date.toIso8601String(),
      };
}
