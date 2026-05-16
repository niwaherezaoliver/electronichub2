import 'package:flutter/material.dart';
import 'cart_provider.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime dateTime;
  final String status;
  final String shippingAddress;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.dateTime,
    this.status = 'Processing',
    required this.shippingAddress,
  });
}

class OrdersProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  Order? get latestOrder {
    if (_orders.isEmpty) return null;
    return _orders.first;
  }

  void addOrder(
    List<CartItem> items,
    double totalAmount,
    String shippingAddress,
  ) {
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: items
          .map(
            (item) => CartItem(product: item.product, quantity: item.quantity),
          )
          .toList(),
      totalAmount: totalAmount,
      dateTime: DateTime.now(),
      shippingAddress: shippingAddress,
    );
    _orders.insert(0, order);
    notifyListeners();
  }

  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }

  int get orderCount => _orders.length;
}
