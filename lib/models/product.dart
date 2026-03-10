class Product {
  final int? id;
  final String name;
  final double price;

  Product({this.id, required this.name, required this.price});

  factory Product.fromMap(Map<String, dynamic> map) =>
      Product(id: map['id'], name: map['name'], price: map['price']);

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'price': price};
}
