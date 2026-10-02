import 'package:intl/intl.dart';

class Money implements Comparable<Money> {
  const Money({required this.cents, required this.currencyCode});

  const Money.zero(this.currencyCode) : cents = 0;

  factory Money.fromDouble(double amount, String currencyCode) {
    if (amount.isNaN || amount.isInfinite) {
      throw ArgumentError.value(amount, 'amount', 'must be finite');
    }
    return Money(
      cents: (amount * 100).round(),
      currencyCode: currencyCode,
    );
  }

  final int cents;
  final String currencyCode;

  double toDouble() => cents / 100.0;

  Money operator +(Money other) {
    _checkCurrency(other);
    return Money(cents: cents + other.cents, currencyCode: currencyCode);
  }

  Money operator -(Money other) {
    _checkCurrency(other);
    return Money(cents: cents - other.cents, currencyCode: currencyCode);
  }

  Money operator *(num multiplier) {
    final multiplied = cents * multiplier;
    return Money(
      cents: _roundHalfAwayFromZero(multiplied),
      currencyCode: currencyCode,
    );
  }

  bool get isZero => cents == 0;

  bool get isNegative => cents < 0;

  @override
  int compareTo(Money other) {
    _checkCurrency(other);
    return cents.compareTo(other.cents);
  }

  String format({String? locale}) {
    return NumberFormat.currency(
      locale: locale ?? 'en_US',
      symbol: _symbolFor(currencyCode),
      decimalDigits: 2,
    ).format(toDouble());
  }

  Map<String, dynamic> toJson() => {
        'cents': cents,
        'currencyCode': currencyCode,
      };

  factory Money.fromJson(Map<String, dynamic> json) {
    final cents = _requiredInt(json, 'cents');
    final currencyCode = _requiredString(json, 'currencyCode');
    return Money(cents: cents, currencyCode: currencyCode);
  }

  @override
  String toString() => 'Money($cents, $currencyCode)';

  @override
  bool operator ==(Object other) {
    return other is Money &&
        other.cents == cents &&
        other.currencyCode == currencyCode;
  }

  @override
  int get hashCode => Object.hash(cents, currencyCode);

  void _checkCurrency(Money other) {
    if (currencyCode != other.currencyCode) {
      throw ArgumentError(
        'Currency mismatch: $currencyCode and ${other.currencyCode}',
      );
    }
  }

  static int _roundHalfAwayFromZero(num value) {
    return value >= 0 ? value.round() : -value.abs().round();
  }

  static String _symbolFor(String currencyCode) {
    const symbols = {
      'USD': r'$',
      'EUR': '€',
      'GBP': '£',
      'INR': '₹',
      'JPY': '¥',
      'CAD': r'$',
      'AUD': r'$',
    };
    return symbols[currencyCode] ?? '$currencyCode ';
  }
}

int _requiredInt(Map<String, dynamic> json, String field) {
  final value = json[field];
  if (value is! int) {
    throw FormatException('$field must be an integer');
  }
  return value;
}

String _requiredString(Map<String, dynamic> json, String field) {
  final value = json[field];
  if (value is! String || value.isEmpty) {
    throw FormatException('$field must be a non-empty string');
  }
  return value;
}
