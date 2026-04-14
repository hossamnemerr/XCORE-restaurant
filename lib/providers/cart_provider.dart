import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  CART ITEM MODEL
// ─────────────────────────────────────────────

class CartItem {
  final String id;
  final String name;
  final String category;
  final String description;
  final String detail;
  final String imageUrl;
  final double unitPrice;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.category,
    this.description = '',
    required this.detail,
    required this.imageUrl,
    required this.unitPrice,
    this.quantity = 1,
  });

  double get total => unitPrice * quantity;

  CartItem copyWith({int? quantity}) => CartItem(
        id: id,
        name: name,
        category: category,
        description: description,
        detail: detail,
        imageUrl: imageUrl,
        unitPrice: unitPrice,
        quantity: quantity ?? this.quantity,
      );
}

// ─────────────────────────────────────────────
//  CART NOTIFIER
// ─────────────────────────────────────────────

class CartNotifier extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get totalCount => _items.fold(0, (sum, i) => sum + i.quantity);
  double get subtotal => _items.fold(0.0, (sum, i) => sum + i.total);
  double get service => subtotal * 0.15;
  double get grandTotal => subtotal + service;

  void addItem(CartItem item) {
    final idx = _items.indexWhere((e) => e.id == item.id);
    if (idx >= 0) {
      _items[idx].quantity++;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void increment(String id) {
    final idx = _items.indexWhere((e) => e.id == id);
    if (idx >= 0) {
      _items[idx].quantity++;
      notifyListeners();
    }
  }

  void decrement(String id) {
    final idx = _items.indexWhere((e) => e.id == id);
    if (idx >= 0 && _items[idx].quantity > 1) {
      _items[idx].quantity--;
      notifyListeners();
    }
  }

  void removeItem(String id) {
    _items.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

// ─────────────────────────────────────────────
//  CART PROVIDER
// ─────────────────────────────────────────────

class CartProvider extends InheritedNotifier<CartNotifier> {
  const CartProvider({
    super.key,
    required CartNotifier notifier,
    required super.child,
  }) : super(notifier: notifier);

  static CartNotifier of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<CartProvider>();
    assert(provider != null, 'CartProvider not found');
    return provider!.notifier!;
  }

  static CartNotifier read(BuildContext context) {
    final provider = context.getInheritedWidgetOfExactType<CartProvider>();
    assert(provider != null, 'CartProvider not found');
    return provider!.notifier!;
  }
}
