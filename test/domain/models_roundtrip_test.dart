import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:ledgerly/domain/money.dart';
import 'package:ledgerly/domain/models/backup_envelope.dart';
import 'package:ledgerly/domain/models/client.dart';
import 'package:ledgerly/domain/models/invoice.dart';
import 'package:ledgerly/domain/models/line_item.dart';
import 'package:ledgerly/domain/models/organization.dart';

void main() {
  final now = DateTime.utc(2026, 10, 3, 0, 45);

  OrganizationProfile organization({Uint8List? logoBytes}) {
    return OrganizationProfile(
      id: 1,
      companyName: 'Ledgerly LLC',
      ownerName: 'Ada Lovelace',
      taxId: 'TAX-123',
      email: 'ada@example.com',
      phone: '+1 555 0100',
      address: '1 Main Street',
      logoBytes: logoBytes,
      currencyCode: 'USD',
      defaultTaxRate: 18.0,
      isOnboarded: true,
      createdAt: now,
      updatedAt: now.add(const Duration(hours: 1)),
    );
  }

  Client client({bool populated = true}) {
    return Client(
      id: populated ? 2 : null,
      name: populated ? 'Acme Corp' : 'No Details',
      email: populated ? 'billing@acme.test' : null,
      phone: populated ? '+1 555 0101' : null,
      billingAddress: populated ? '2 Market Street' : null,
      notes: populated ? 'Net 30' : null,
      createdAt: now,
      updatedAt: now,
      deletedAt: populated ? now.add(const Duration(days: 1)) : null,
    );
  }

  LineItem lineItem(int order) {
    return LineItem(
      id: order,
      invoiceId: 7,
      description: 'Service $order',
      quantity: order + 0.5,
      unitPrice: Money(cents: order * 1000, currencyCode: 'USD'),
      sortOrder: order,
    );
  }

  Invoice invoice({bool populated = true}) {
    return Invoice(
      id: populated ? 7 : null,
      invoiceNumber: populated ? 'INV-2026-001' : 'INV-2026-002',
      clientId: 2,
      issueDate: now,
      dueDate: now.add(const Duration(days: 30)),
      currencyCode: 'USD',
      taxRate: populated ? 18.0 : 0.0,
      notes: populated ? 'Thank you' : null,
      terms: populated ? 'Payment due within 30 days' : null,
      status: populated ? InvoiceStatus.paid : InvoiceStatus.draft,
      paidAt: populated ? now.add(const Duration(days: 2)) : null,
      subtotal: Money(cents: populated ? 6000 : 0, currencyCode: 'USD'),
      taxAmount: Money(cents: populated ? 1080 : 0, currencyCode: 'USD'),
      total: Money(cents: populated ? 7080 : 0, currencyCode: 'USD'),
      lineItems: populated ? [lineItem(1), lineItem(2), lineItem(3)] : const [],
      createdAt: now,
      updatedAt: now,
      deletedAt: populated ? now.add(const Duration(days: 3)) : null,
    );
  }

  test('round-trips OrganizationProfile, including logo bytes', () {
    final original = organization(logoBytes: Uint8List.fromList([1, 2, 3]));

    expect(OrganizationProfile.fromJson(original.toJson()), original);
  });

  test('round-trips null-heavy OrganizationProfile', () {
    final original = OrganizationProfile(
      companyName: 'Minimal',
      ownerName: 'Owner',
      createdAt: now,
      updatedAt: now,
    );

    expect(OrganizationProfile.fromJson(original.toJson()), original);
  });

  test('round-trips Client populated and null-heavy instances', () {
    expect(Client.fromJson(client().toJson()), client());
    expect(Client.fromJson(client(populated: false).toJson()),
        client(populated: false));
  });

  test('round-trips LineItem', () {
    final original = lineItem(2);

    expect(LineItem.fromJson(original.toJson()), original);
    expect(original.lineTotal, const Money(cents: 5000, currencyCode: 'USD'));
  });

  test('round-trips Invoice and preserves line item order', () {
    final original = invoice();
    final restored = Invoice.fromJson(original.toJson());

    expect(restored, original);
    expect(restored.lineItems, original.lineItems);
    expect(restored.lineItems.map((item) => item.sortOrder), [1, 2, 3]);
  });

  test('round-trips null-heavy Invoice', () {
    final original = invoice(populated: false);

    expect(Invoice.fromJson(original.toJson()), original);
  });

  test('round-trips BackupEnvelope with optional organization', () {
    final original = BackupEnvelope(
      schemaVersion: BackupEnvelope.currentSchemaVersion,
      appVersion: '0.1.0',
      exportedAt: now,
      organization: organization(),
      clients: [client(), client(populated: false)],
      invoices: [invoice(), invoice(populated: false)],
    );

    expect(BackupEnvelope.fromJson(original.toJson()), original);
  });

  test('round-trips BackupEnvelope without organization', () {
    final original = BackupEnvelope(
      schemaVersion: BackupEnvelope.currentSchemaVersion,
      appVersion: '0.1.0',
      exportedAt: now,
      clients: [],
      invoices: [],
    );

    expect(BackupEnvelope.fromJson(original.toJson()), original);
  });

  test('rejects an unsupported backup schema version', () {
    expect(
      () => BackupEnvelope.fromJson({
        'schemaVersion': 99,
        'appVersion': '0.1.0',
        'exportedAt': now.toIso8601String(),
        'organization': null,
        'clients': [],
        'invoices': [],
      }),
      throwsA(isA<BackupSchemaException>()),
    );
  });
}
