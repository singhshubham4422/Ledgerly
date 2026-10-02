class Client {
  Client({
    this.id,
    required this.name,
    this.email,
    this.phone,
    this.billingAddress,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  final int? id;
  final String name;
  final String? email;
  final String? phone;
  final String? billingAddress;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Client copyWith({
    Object? id = _unset,
    Object? name = _unset,
    Object? email = _unset,
    Object? phone = _unset,
    Object? billingAddress = _unset,
    Object? notes = _unset,
    Object? createdAt = _unset,
    Object? updatedAt = _unset,
    Object? deletedAt = _unset,
  }) {
    return Client(
      id: identical(id, _unset) ? this.id : id as int?,
      name: identical(name, _unset) ? this.name : name as String,
      email: identical(email, _unset) ? this.email : email as String?,
      phone: identical(phone, _unset) ? this.phone : phone as String?,
      billingAddress: identical(billingAddress, _unset)
          ? this.billingAddress
          : billingAddress as String?,
      notes: identical(notes, _unset) ? this.notes : notes as String?,
      createdAt:
          identical(createdAt, _unset) ? this.createdAt : createdAt as DateTime,
      updatedAt:
          identical(updatedAt, _unset) ? this.updatedAt : updatedAt as DateTime,
      deletedAt: identical(deletedAt, _unset)
          ? this.deletedAt
          : deletedAt as DateTime?,
    );
  }

  // deletedAt is explicit because null means the record is active.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
    if (id != null) json['id'] = id;
    if (email != null) json['email'] = email;
    if (phone != null) json['phone'] = phone;
    if (billingAddress != null) json['billingAddress'] = billingAddress;
    if (notes != null) json['notes'] = notes;
    return json;
  }

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: _optionalInt(json, 'id'),
      name: _requiredString(json, 'name'),
      email: _optionalString(json, 'email'),
      phone: _optionalString(json, 'phone'),
      billingAddress: _optionalString(json, 'billingAddress'),
      notes: _optionalString(json, 'notes'),
      createdAt: _requiredDateTime(json, 'createdAt'),
      updatedAt: _requiredDateTime(json, 'updatedAt'),
      deletedAt: _optionalDateTime(json, 'deletedAt'),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Client &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.billingAddress == billingAddress &&
        other.notes == notes &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.deletedAt == deletedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        email,
        phone,
        billingAddress,
        notes,
        createdAt,
        updatedAt,
        deletedAt,
      );
}

const _unset = Object();

int? _optionalInt(Map<String, dynamic> json, String field) {
  final value = json[field];
  if (value == null) return null;
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
