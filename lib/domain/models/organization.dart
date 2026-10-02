import 'dart:convert';
import 'dart:typed_data';

class OrganizationProfile {
  OrganizationProfile({
    this.id,
    required this.companyName,
    required this.ownerName,
    this.taxId,
    this.email,
    this.phone,
    this.address,
    this.logoBytes,
    this.currencyCode = 'USD',
    this.defaultTaxRate = 0.0,
    this.isOnboarded = false,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String companyName;
  final String ownerName;
  final String? taxId;
  final String? email;
  final String? phone;
  final String? address;
  final Uint8List? logoBytes;
  final String currencyCode;
  final double defaultTaxRate;
  final bool isOnboarded;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrganizationProfile copyWith({
    Object? id = _unset,
    Object? companyName = _unset,
    Object? ownerName = _unset,
    Object? taxId = _unset,
    Object? email = _unset,
    Object? phone = _unset,
    Object? address = _unset,
    Object? logoBytes = _unset,
    Object? currencyCode = _unset,
    Object? defaultTaxRate = _unset,
    Object? isOnboarded = _unset,
    Object? createdAt = _unset,
    Object? updatedAt = _unset,
  }) {
    return OrganizationProfile(
      id: identical(id, _unset) ? this.id : id as int?,
      companyName: identical(companyName, _unset)
          ? this.companyName
          : companyName as String,
      ownerName:
          identical(ownerName, _unset) ? this.ownerName : ownerName as String,
      taxId: identical(taxId, _unset) ? this.taxId : taxId as String?,
      email: identical(email, _unset) ? this.email : email as String?,
      phone: identical(phone, _unset) ? this.phone : phone as String?,
      address: identical(address, _unset) ? this.address : address as String?,
      logoBytes: identical(logoBytes, _unset)
          ? this.logoBytes
          : logoBytes as Uint8List?,
      currencyCode: identical(currencyCode, _unset)
          ? this.currencyCode
          : currencyCode as String,
      defaultTaxRate: identical(defaultTaxRate, _unset)
          ? this.defaultTaxRate
          : defaultTaxRate as double,
      isOnboarded: identical(isOnboarded, _unset)
          ? this.isOnboarded
          : isOnboarded as bool,
      createdAt:
          identical(createdAt, _unset) ? this.createdAt : createdAt as DateTime,
      updatedAt:
          identical(updatedAt, _unset) ? this.updatedAt : updatedAt as DateTime,
    );
  }

  // Optional profile fields are omitted when null; logoBytes follows the same rule.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'companyName': companyName,
      'ownerName': ownerName,
      'currencyCode': currencyCode,
      'defaultTaxRate': defaultTaxRate,
      'isOnboarded': isOnboarded,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
    if (id != null) json['id'] = id;
    if (taxId != null) json['taxId'] = taxId;
    if (email != null) json['email'] = email;
    if (phone != null) json['phone'] = phone;
    if (address != null) json['address'] = address;
    if (logoBytes != null) json['logoBytes'] = base64Encode(logoBytes!);
    return json;
  }

  factory OrganizationProfile.fromJson(Map<String, dynamic> json) {
    return OrganizationProfile(
      id: _optionalInt(json, 'id'),
      companyName: _requiredString(json, 'companyName'),
      ownerName: _requiredString(json, 'ownerName'),
      taxId: _optionalString(json, 'taxId'),
      email: _optionalString(json, 'email'),
      phone: _optionalString(json, 'phone'),
      address: _optionalString(json, 'address'),
      logoBytes: _optionalBase64(json, 'logoBytes'),
      currencyCode: json['currencyCode'] == null
          ? 'USD'
          : _requiredString(json, 'currencyCode'),
      defaultTaxRate: json['defaultTaxRate'] == null
          ? 0.0
          : _requiredNum(json, 'defaultTaxRate').toDouble(),
      isOnboarded: json['isOnboarded'] == null
          ? false
          : _requiredBool(json, 'isOnboarded'),
      createdAt: _requiredDateTime(json, 'createdAt'),
      updatedAt: _requiredDateTime(json, 'updatedAt'),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is OrganizationProfile &&
        other.id == id &&
        other.companyName == companyName &&
        other.ownerName == ownerName &&
        other.taxId == taxId &&
        other.email == email &&
        other.phone == phone &&
        other.address == address &&
        _bytesEqual(other.logoBytes, logoBytes) &&
        other.currencyCode == currencyCode &&
        other.defaultTaxRate == defaultTaxRate &&
        other.isOnboarded == isOnboarded &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => _hash;

  late final int _hash = Object.hash(
    id,
    companyName,
    ownerName,
    taxId,
    email,
    phone,
    address,
    logoBytes == null ? null : base64Encode(logoBytes!),
    currencyCode,
    defaultTaxRate,
    isOnboarded,
    createdAt,
    updatedAt,
  );
}

const _unset = Object();

Uint8List? _optionalBase64(Map<String, dynamic> json, String field) {
  final value = json[field];
  if (value == null) return null;
  if (value is! String) throw FormatException('$field must be a base64 string');
  try {
    return Uint8List.fromList(base64Decode(value));
  } on FormatException {
    throw FormatException('$field must be valid base64');
  }
}

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

num _requiredNum(Map<String, dynamic> json, String field) {
  final value = json[field];
  if (value is! num || !value.isFinite) {
    throw FormatException('$field must be a finite number');
  }
  return value;
}

bool _requiredBool(Map<String, dynamic> json, String field) {
  final value = json[field];
  if (value is! bool) throw FormatException('$field must be a boolean');
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

bool _bytesEqual(Uint8List? left, Uint8List? right) {
  if (left == null || right == null) return left == null && right == null;
  if (left.length != right.length) return false;
  for (var index = 0; index < left.length; index++) {
    if (left[index] != right[index]) return false;
  }
  return true;
}
