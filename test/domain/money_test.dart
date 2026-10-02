import 'package:flutter_test/flutter_test.dart';
import 'package:ledgerly/domain/money.dart';

void main() {
  group('Money', () {
    test('supports addition, subtraction, and multiplication', () {
      const usd = Money(cents: 1250, currencyCode: 'USD');

      expect(usd + const Money(cents: 250, currencyCode: 'USD'),
          const Money(cents: 1500, currencyCode: 'USD'));
      expect(usd - const Money(cents: 250, currencyCode: 'USD'),
          const Money(cents: 1000, currencyCode: 'USD'));
      expect(usd * 2, const Money(cents: 2500, currencyCode: 'USD'));
      expect(usd * 1.5, const Money(cents: 1875, currencyCode: 'USD'));
    });

    test('rounds multiplication half away from zero', () {
      const usd = Money(cents: 1, currencyCode: 'USD');

      expect(usd * 0.5, const Money(cents: 1, currencyCode: 'USD'));
      expect(const Money(cents: -1, currencyCode: 'USD') * 0.5,
          const Money(cents: -1, currencyCode: 'USD'));
    });

    test('rejects currency mismatches', () {
      const usd = Money(cents: 100, currencyCode: 'USD');
      const eur = Money(cents: 100, currencyCode: 'EUR');

      expect(() => usd + eur, throwsArgumentError);
      expect(() => usd - eur, throwsArgumentError);
      expect(() => usd.compareTo(eur), throwsArgumentError);
    });

    test('rejects non-finite amounts', () {
      expect(() => Money.fromDouble(double.nan, 'USD'), throwsArgumentError);
      expect(
          () => Money.fromDouble(double.infinity, 'USD'), throwsArgumentError);
    });

    test('formats supported currencies', () {
      expect(const Money(cents: 123456, currencyCode: 'USD').format(),
          r'$1,234.56');
      expect(const Money(cents: 123456, currencyCode: 'EUR').format(),
          '€1,234.56');
      expect(const Money(cents: 123456, currencyCode: 'INR').format(),
          '₹1,234.56');
      expect(const Money(cents: 123456, currencyCode: 'JPY').format(),
          '¥1,234.56');
    });

    test('reports sign and zero state', () {
      expect(const Money.zero('USD').isZero, isTrue);
      expect(const Money(cents: -1, currencyCode: 'USD').isNegative, isTrue);
      expect(const Money(cents: 1, currencyCode: 'USD').isNegative, isFalse);
    });

    test('round-trips JSON', () {
      const original = Money(cents: 9876, currencyCode: 'GBP');

      expect(Money.fromJson(original.toJson()), original);
    });
  });
}
