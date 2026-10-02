import '../money.dart';
import 'line_item.dart';

enum InvoiceStatus {
  draft,
  sent,
  paid,
  overdue,
  cancelled;

  static InvoiceStatus fromString(String value) {
    for (final status in values) {
      if (status.jsonName == value) return status;
    }
    throw ArgumentError.value(value, 'value', 'unknown invoice status');
  }

  String get jsonName => name;
}

class Invoice {
  Invoice({
    this.id,
    required this.invoiceNumber,
    required this.clientId,
    required this.issueDate,
    required this.dueDate,
    required this.currencyCode,
    required this.taxRate,
    this.notes,
    this.terms,
    required this.status,
    this.paidAt,
    required this.subtotal,
    required this.taxAmount,
    required this.total,
    required List<LineItem> lineItems,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  }) : lineItems = List.unmodifiable(lineItems);

  final int? id;
  final String invoiceNumber;
  final int clientId;
  final DateTime issueDate;
  final DateTime dueDate;
  final String currencyCode;
  final double taxRate;
  final String? notes;
  final String? terms;
  final InvoiceStatus status;
  final DateTime? paidAt;
  // Totals are passed in by the caller and are never computed in this model.
  final Money subtotal;
  final Money taxAmount;
  final Money total;
  final List<LineItem> lineItems;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Invoice copyWith({
    Object? id = _unset,
    Object? invoiceNumber = _unset,
    Object? clientId = _unset,
    Object? issueDate = _unset,
    Object? dueDate = _unset,
    Object? currencyCode = _unset,
    Object? taxRate = _unset,
    Object? notes = _unset,
    Object? terms = _unset,
    Object? status = _unset,
    Object? paidAt = _unset,
    Object? subtotal = _unset,
    Object? taxAmount = _unset,
    Object? total = _unset,
    Object? lineItems = _unset,
    Object? createdAt = _unset,
    Object? updatedAt = _unset,
    Object? deletedAt = _unset,
  }) {
    return Invoice(
      id: identical(id, _unset) ? this.id : id as int?,
      invoiceNumber: identical(invoiceNumber, _unset)
          ? this.invoiceNumber
          : invoiceNumber as String,
      clientId: identical(clientId, _unset) ? this.clientId : clientId as int,
      issueDate:
          identical(issueDate, _unset) ? this.issueDate : issueDate as DateTime,
      dueDate: identical(dueDate, _unset) ? this.dueDate : dueDate as DateTime,
      currencyCode: identical(currencyCode, _unset)
          ? this.currencyCode
          : currencyCode as String,
      taxRate: identical(taxRate, _unset) ? this.taxRate : taxRate as double,
      notes: identical(notes, _unset) ? this.notes : notes as String?,
      terms: identical(terms, _unset) ? this.terms : terms as String?,
      status: identical(status, _unset) ? this.status : status as InvoiceStatus,
      paidAt: identical(paidAt, _unset) ? this.paidAt : paidAt as DateTime?,
      subtotal: identical(subtotal, _unset) ? this.subtotal : subtotal as Money,
      taxAmount:
          identical(taxAmount, _unset) ? this.taxAmount : taxAmount as Money,
      total: identical(total, _unset) ? this.total : total as Money,
      lineItems: identical(lineItems, _unset)
          ? this.lineItems
          : lineItems as List<LineItem>,
      createdAt:
          identical(createdAt, _unset) ? this.createdAt : createdAt as DateTime,
      updatedAt:
          identical(updatedAt, _unset) ? this.updatedAt : updatedAt as DateTime,
      deletedAt: identical(deletedAt, _unset)
          ? this.deletedAt
          : deletedAt as DateTime?,
    );
  }

  // paidAt and deletedAt are explicit because null represents an unpaid or active invoice.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'invoiceNumber': invoiceNumber,
      'clientId': clientId,
      'issueDate': issueDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'currencyCode': currencyCode,
      'taxRate': taxRate,
      'status': status.jsonName,
      'paidAt': paidAt?.toIso8601String(),
      'subtotal': subtotal.toJson(),
      'taxAmount': taxAmount.toJson(),
      'total': total.toJson(),
      'lineItems': lineItems.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
    if (id != null) json['id'] = id;
    if (notes != null) json['notes'] = notes;
    if (terms != null) json['terms'] = terms;
    return json;
  }

  factory Invoice.fromJson(Map<String, dynamic> json) {
    final subtotal = _moneyObject(json, 'subtotal');
    final taxAmount = _moneyObject(json, 'taxAmount');
    final total = _moneyObject(json, 'total');
    final lineItems = json['lineItems'];
    if (lineItems is! List) {
      throw FormatException('lineItems must be a JSON array');
    }
    return Invoice(
      id: _optionalInt(json, 'id'),
      invoiceNumber: _requiredString(json, 'invoiceNumber'),
      clientId: _requiredInt(json, 'clientId'),
      issueDate: _requiredDateTime(json, 'issueDate'),
      dueDate: _requiredDateTime(json, 'dueDate'),
      currencyCode: _requiredString(json, 'currencyCode'),
      taxRate: _requiredNum(json, 'taxRate').toDouble(),
      notes: _optionalString(json, 'notes'),
      terms: _optionalString(json, 'terms'),
      status: InvoiceStatus.fromString(_requiredString(json, 'status')),
      paidAt: _optionalDateTime(json, 'paidAt'),
      subtotal: subtotal,
      taxAmount: taxAmount,
      total: total,
      lineItems: lineItems.map((item) {
        if (item is! Map) {
          throw FormatException('lineItems must contain JSON objects');
        }
        return LineItem.fromJson(Map<String, dynamic>.from(item));
      }).toList(),
      createdAt: _requiredDateTime(json, 'createdAt'),
      updatedAt: _requiredDateTime(json, 'updatedAt'),
      deletedAt: _optionalDateTime(json, 'deletedAt'),
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! Invoice ||
        other.id != id ||
        other.invoiceNumber != invoiceNumber ||
        other.clientId != clientId ||
        other.issueDate != issueDate ||
        other.dueDate != dueDate ||
        other.currencyCode != currencyCode ||
        other.taxRate != taxRate ||
        other.notes != notes ||
        other.terms != terms ||
        other.status != status ||
        other.paidAt != paidAt ||
        other.subtotal != subtotal ||
        other.taxAmount != taxAmount ||
        other.total != total ||
        other.createdAt != createdAt ||
        other.updatedAt != updatedAt ||
        other.deletedAt != deletedAt ||
        other.lineItems.length != lineItems.length) {
      return false;
    }
    for (var index = 0; index < lineItems.length; index++) {
      if (other.lineItems[index] != lineItems[index]) return false;
    }
    return true;
  }

  @override
  int get hashCode => _hash;

  late final int _hash = Object.hash(
    id,
    invoiceNumber,
    clientId,
    issueDate,
    dueDate,
    currencyCode,
    taxRate,
    notes,
    terms,
    status,
    paidAt,
    subtotal,
    taxAmount,
    total,
    Object.hashAll(lineItems),
    createdAt,
    updatedAt,
    deletedAt,
  );
}

const _unset = Object();

Money _moneyObject(Map<String, dynamic> json, String field) {
  final value = json[field];
  if (value is! Map) throw FormatException('$field must be a JSON object');
  return Money.fromJson(Map<String, dynamic>.from(value));
}

int? _optionalInt(Map<String, dynamic> json, String field) {
  final value = json[field];
  if (value == null) return null;
  if (value is! int) throw FormatException('$field must be an integer');
  return value;
}

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

String? _optionalString(Map<String, dynamic> json, String field) {
  final value = json[field];
  if (value == null) return null;
  if (value is! String) throw FormatException('$field must be a string');
  return value;
}

num _requiredNum(Map<String, dynamic> json, String field) {
  final value = json[field];
  if (value is! num || !value.isFinite) {
    throw FormatException('$field must be a finite number');
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

DateTime? _optionalDateTime(Map<String, dynamic> json, String field) {
  if (json[field] == null) return null;
  return _requiredDateTime(json, field);
}
