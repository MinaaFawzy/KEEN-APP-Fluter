/// Represents the customer access token returned by Shopify.
class CustomerAccessToken {
  final String accessToken;
  final DateTime expiresAt;

  const CustomerAccessToken({
    required this.accessToken,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  factory CustomerAccessToken.fromJson(Map<String, dynamic> json) {
    return CustomerAccessToken(
      accessToken: json['accessToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'expiresAt': expiresAt.toIso8601String(),
  };
}

/// Represents a Shopify customer address.
class CustomerAddress {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? address1;
  final String? address2;
  final String? city;
  final String? country;
  final String? province;
  final String? zip;
  final String? phone;

  const CustomerAddress({
    this.id,
    this.firstName,
    this.lastName,
    this.address1,
    this.address2,
    this.city,
    this.country,
    this.province,
    this.zip,
    this.phone,
  });

  factory CustomerAddress.fromJson(Map<String, dynamic> json) {
    return CustomerAddress(
      id: json['id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      address1: json['address1'] as String?,
      address2: json['address2'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      province: json['province'] as String?,
      zip: json['zip'] as String?,
      phone: json['phone'] as String?,
    );
  }
}

/// Represents a Shopify customer order summary.
class CustomerOrder {
  final String id;
  final String name;
  final int orderNumber;
  final String totalAmount;
  final String currencyCode;
  final DateTime processedAt;
  final String fulfillmentStatus;
  final String financialStatus;

  const CustomerOrder({
    required this.id,
    required this.name,
    required this.orderNumber,
    required this.totalAmount,
    required this.currencyCode,
    required this.processedAt,
    required this.fulfillmentStatus,
    required this.financialStatus,
  });

  factory CustomerOrder.fromJson(Map<String, dynamic> json) {
    return CustomerOrder(
      id: json['id'] as String,
      name: json['name'] as String,
      orderNumber: json['orderNumber'] as int,
      totalAmount: json['totalPrice']['amount'] as String,
      currencyCode: json['totalPrice']['currencyCode'] as String,
      processedAt: DateTime.parse(json['processedAt'] as String),
      fulfillmentStatus: json['fulfillmentStatus'] as String? ?? '',
      financialStatus: json['financialStatus'] as String? ?? '',
    );
  }
}

/// Full Shopify customer model.
class CustomerModel {
  final String id;
  final String? firstName;
  final String? lastName;
  final String email;
  final String? phone;
  final bool acceptsMarketing;
  final DateTime createdAt;
  final List<CustomerOrder> orders;
  final CustomerAddress? defaultAddress;

  const CustomerModel({
    required this.id,
    this.firstName,
    this.lastName,
    required this.email,
    this.phone,
    required this.acceptsMarketing,
    required this.createdAt,
    this.orders = const [],
    this.defaultAddress,
  });

  String get displayName {
    final parts = [firstName, lastName].where((p) => p != null && p.isNotEmpty);
    return parts.isNotEmpty ? parts.join(' ') : email;
  }

  String get initials {
    final first = firstName?.isNotEmpty == true ? firstName![0] : '';
    final last = lastName?.isNotEmpty == true ? lastName![0] : '';
    return (first + last).toUpperCase().trim().isNotEmpty
        ? (first + last).toUpperCase()
        : email[0].toUpperCase();
  }

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    final ordersData = json['orders']?['edges'] as List<dynamic>? ?? [];
    final orders = ordersData
        .map((e) => CustomerOrder.fromJson(e['node'] as Map<String, dynamic>))
        .toList();

    return CustomerModel(
      id: json['id'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      acceptsMarketing: json['acceptsMarketing'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      orders: orders,
      defaultAddress: json['defaultAddress'] != null
          ? CustomerAddress.fromJson(
              json['defaultAddress'] as Map<String, dynamic>)
          : null,
    );
  }
}
