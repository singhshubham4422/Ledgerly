import 'client.dart';
import 'invoice.dart';
import 'organization.dart';

class BackupSchemaException implements Exception {
  const BackupSchemaException({required this.found, required this.expected});

  final int found;
  final int expected;

  @override
  String toString() {
    return 'BackupSchemaException: schema version $found is unsupported; '
        'expected $expected';
  }
}

class BackupEnvelope {
  static const int currentSchemaVersion = 1;

  BackupEnvelope({
    required this.schemaVersion,
    required this.appVersion,
    required this.exportedAt,
    this.organization,
    required List<Client> clients,
    required List<Invoice> invoices,
  })  : clients = List.unmodifiable(clients),
        invoices = List.unmodifiable(invoices);

  final int schemaVersion;
  final String appVersion;
  final DateTime exportedAt;
  final OrganizationProfile? organization;
  final List<Client> clients;
  final List<Invoice> invoices;

  BackupEnvelope copyWith({
    Object? schemaVersion = _unset,
    Object? appVersion = _unset,
    Object? exportedAt = _unset,
    Object? organization = _unset,
    Object? clients = _unset,
    Object? invoices = _unset,
  }) {
    return BackupEnvelope(
      schemaVersion: identical(schemaVersion, _unset)
          ? this.schemaVersion
          : schemaVersion as int,
      appVersion: identical(appVersion, _unset)
          ? this.appVersion
          : appVersion as String,
      exportedAt: identical(exportedAt, _unset)
          ? this.exportedAt
          : exportedAt as DateTime,
      organization: identical(organization, _unset)
          ? this.organization
          : organization as OrganizationProfile?,
      clients:
          identical(clients, _unset) ? this.clients : clients as List<Client>,
      invoices: identical(invoices, _unset)
          ? this.invoices
          : invoices as List<Invoice>,
    );
  }

  Map<String, dynamic> toJson() => {
        'schemaVersion': schemaVersion,
        'appVersion': appVersion,
        'exportedAt': exportedAt.toIso8601String(),
        'organization': organization?.toJson(),
        'clients': clients.map((client) => client.toJson()).toList(),
        'invoices': invoices.map((invoice) => invoice.toJson()).toList(),
      };

  factory BackupEnvelope.fromJson(Map<String, dynamic> json) {
    final schemaVersion = _requiredInt(json, 'schemaVersion');
    if (schemaVersion != currentSchemaVersion) {
      throw BackupSchemaException(
        found: schemaVersion,
        expected: currentSchemaVersion,
      );
    }
    final organizationValue = json['organization'];
    final clientsValue = json['clients'];
    final invoicesValue = json['invoices'];
    if (organizationValue != null && organizationValue is! Map) {
      throw FormatException('organization must be a JSON object or null');
    }
    if (clientsValue is! List) {
      throw FormatException('clients must be a JSON array');
    }
    if (invoicesValue is! List) {
      throw FormatException('invoices must be a JSON array');
    }
    return BackupEnvelope(
      schemaVersion: schemaVersion,
      appVersion: _requiredString(json, 'appVersion'),
      exportedAt: _requiredDateTime(json, 'exportedAt'),
      organization: organizationValue == null
          ? null
          : OrganizationProfile.fromJson(
              Map<String, dynamic>.from(organizationValue),
            ),
      clients: clientsValue.map((client) {
        if (client is! Map) {
          throw FormatException('clients must contain objects');
        }
        return Client.fromJson(Map<String, dynamic>.from(client));
      }).toList(),
      invoices: invoicesValue.map((invoice) {
        if (invoice is! Map) {
          throw FormatException('invoices must contain objects');
        }
        return Invoice.fromJson(Map<String, dynamic>.from(invoice));
      }).toList(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! BackupEnvelope ||
        other.schemaVersion != schemaVersion ||
        other.appVersion != appVersion ||
        other.exportedAt != exportedAt ||
        other.organization != organization ||
        other.clients.length != clients.length ||
        other.invoices.length != invoices.length) {
      return false;
    }
    for (var index = 0; index < clients.length; index++) {
      if (other.clients[index] != clients[index]) return false;
    }
    for (var index = 0; index < invoices.length; index++) {
      if (other.invoices[index] != invoices[index]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
        schemaVersion,
        appVersion,
        exportedAt,
        organization,
        Object.hashAll(clients),
        Object.hashAll(invoices),
      );
}

const _unset = Object();

int _requiredInt(Map<String, dynamic> json, String field) {
  final value = json[field];
  if (value is! int) throw FormatException('$field must be an integer');
  return value;
}

String _requiredString(Map<String, dynamic> json, String field) {
  final value = json[field];
  if (value is! String || value.isEmpty) {
    throw FormatException('$field must be a non-empty string');
  }
  return value;
}

DateTime _requiredDateTime(Map<String, dynamic> json, String field) {
  final value = json[field];
  if (value is! String) throw FormatException('$field must be an ISO date');
  try {
    return DateTime.parse(value);
  } on FormatException {
    throw FormatException('$field must be a valid ISO date');
  }
}
