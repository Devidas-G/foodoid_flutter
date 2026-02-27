class AuthException implements Exception {
  final String code;
  final String? message;

  AuthException({this.code = 'unknown', this.message});
  @override
  String toString() => 'AuthException($code): $message';
}

class CartException implements Exception {
  final String message;
  final String code;

  CartException({required this.message, this.code = 'unknown'});

  @override
  String toString() => 'CartException($code): $message';
}

class OrdersException implements Exception {
  final String message;
  final String code;

  OrdersException({required this.message, this.code = 'unknown'});

  @override
  String toString() => 'OrdersException($code): $message';
}

class WishlistException implements Exception {
  final String message;
  final String code;

  WishlistException({required this.message, this.code = 'unknown'});

  @override
  String toString() => 'WishlistException($code): $message';
}
