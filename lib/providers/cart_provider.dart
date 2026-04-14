
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  CART ITEM MODEL
// ─────────────────────────────────────────────

class CartItem {
  final String id;
  final String name;
  final String category;
  final String detail;
  final String imageUrl;
  final double unitPrice;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.category,
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
        detail: detail,
        imageUrl: imageUrl,
        unitPrice: unitPrice,
        quantity: quantity ?? this.quantity,
      );
}

// ─────────────────────────────────────────────
//  CART NOTIFIER  (ChangeNotifier)
// ─────────────────────────────────────────────

class CartNotifier extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalCount => _items.fold(0, (sum, i) => sum + i.quantity);

  double get subtotal => _items.fold(0.0, (sum, i) => sum + i.total);

  double get service => subtotal * 0.15;

  double get grandTotal => subtotal + service;

  // ── Add or increment ──────────────────────
  void addItem(CartItem item) {
    final idx = _items.indexWhere((e) => e.id == item.id);
    if (idx >= 0) {
      _items[idx].quantity++;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  // ── Increment qty ─────────────────────────
  void increment(String id) {
    final idx = _items.indexWhere((e) => e.id == id);
    if (idx >= 0) {
      _items[idx].quantity++;
      notifyListeners();
    }
  }

  // ── Decrement qty (min 1) ─────────────────
  void decrement(String id) {
    final idx = _items.indexWhere((e) => e.id == id);
    if (idx >= 0 && _items[idx].quantity > 1) {
      _items[idx].quantity--;
      notifyListeners();
    }
  }

  // ── Remove item ───────────────────────────
  void removeItem(String id) {
    _items.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // ── Clear all ─────────────────────────────
  void clear() {
    _items.clear();
    notifyListeners();
  }
}

// ─────────────────────────────────────────────
//  INHERITED WIDGET  (passes notifier down tree)
// ─────────────────────────────────────────────

class CartProvider extends InheritedNotifier<CartNotifier> {
  const CartProvider({
    super.key,
    required CartNotifier notifier,
    required super.child,
  }) : super(notifier: notifier);

  /// Access the cart from any widget in the tree.
  static CartNotifier of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<CartProvider>();
    assert(provider != null, 'CartProvider not found in widget tree');
    return provider!.notifier!;
  }

  /// Access without rebuilding on changes.
  static CartNotifier read(BuildContext context) {
    final provider =
        context.getInheritedWidgetOfExactType<CartProvider>();
    assert(provider != null, 'CartProvider not found in widget tree');
    return provider!.notifier!;
  }
}
