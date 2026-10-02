import '../money.dart';

class LineItem {
  LineItem({
    this.id,
    this.invoiceId,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.sortOrder,
  });

  final int? id;
  final int? invoiceId;
  final String description;
  final double quantity;
  final Money unitPrice;
  final int sortOrder;

  Money get lineTotal => unitPrice * quantity;

  LineItem copyWith({
    Object? id = _unset,
    Object? invoiceId = _unset,
    Object? description = _unset,
    Object? quantity = _unset,
    Object? unitPrice = _unset,
    Object? sortOrder = _unset,
  }) {
    return LineItem(
      id: identical(id, _unset) ? this.id : id as int?,
      invoiceId:
          identical(invoiceId, _unset) ? this.invoiceId : invoiceId as int?,
      description: identical(description, _unset)
          ? this.description
          : description as String,
      quantity:
          identical(quantity, _unset) ? this.quantity : quantity as double,
      unitPrice:
          identical(unitPrice, _unset) ? this.unitPrice : unitPrice as Money,
      sortOrder:
          identical(sortOrder, _unset) ? this.sortOrder : sortOrder as int,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'description': description,
      'quantity': quantity,
      'unitPrice': unitPrice.toJson(),
      'sortOrder': sortOrder,
    };
    if (id != null) json['id'] = id;
    if (invoiceId != null) json['invoiceId'] = invoiceId;
    return json;
  }

  factory LineItem.fromJson(Map<String, dynamic> json) {
    final unitPrice = json['unitPrice'];
    if (unitPrice is! Map) {
      throw FormatException('unitPrice must be a JSON object');
    }
    return LineItem(
      id: _optionalInt(json, 'id'),
      invoiceId: _optionalInt(json, 'invoiceId'),
      description: _requiredString(json, 'description'),
      quantity: _requiredNum(json, 'quantity').toDouble(),
      unitPrice: Money.fromJson(Map<String, dynamic>.from(unitPrice)),
      sortOrder: _requiredInt(json, 'sortOrder'),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LineItem &&
        other.id == id &&
        other.invoiceId == invoiceId &&
        other.description == description &&
        other.quantity == quantity &&
        other.unitPrice == unitPrice &&
        other.sortOrder == sortOrder;
  }

  @override
  int get hashCode => Object.hash(
        id,
        invoiceId,
        description,
        quantity,
        unitPrice,
        sortOrder,
      );
}

const _unset = Object();

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

num _requiredNum(Map<String, dynamic> json, String field) {
  final value = json[field];
  if (value is! num || !value.isFinite) {
    throw FormatException('$field must be a finite number');
  }
  return value;
}
