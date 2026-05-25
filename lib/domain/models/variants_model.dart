class Variants {
  int? id;
  int? productId;
  String? title;
  String? price;
  int? position;
  String? inventoryPolicy;
  String? compareAtPrice;
  String? option1;
  String? option2;
  String? option3;
  String? createdAt;
  String? updatedAt;
  bool? taxable;
  String? barcode;
  String? fulfillmentService;
  int? grams;
  String? inventoryManagement;
  bool? requiresShipping;
  String? sku;
  double? weight;
  String? weightUnit;
  int? inventoryItemId;
  int? inventoryQuantity;
  int? oldInventoryQuantity;
  String? adminGraphqlApiId;
  int? imageId;
  String? imageSrc;
  String? productTitle;
  int? cartQuantity;

  Variants( {
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.position,
    required this.inventoryPolicy,
    required this.compareAtPrice,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.createdAt,
    required this.updatedAt,
    required this.taxable,
    required this.barcode,
    required this.fulfillmentService,
    required this.grams,
    required this.inventoryManagement,
    required this.requiresShipping,
    required this.sku,
    required this.weight,
    required this.weightUnit,
    required this.inventoryItemId,
    required this.inventoryQuantity,
    required this.oldInventoryQuantity,
    required this.adminGraphqlApiId,
    required this.imageId,
    required this.imageSrc,
    required this.productTitle,
    required this.cartQuantity,
  });

  factory Variants.fromJson(Map<String, dynamic> json) {
    return Variants(
      id: json['id'],
      productId: json['product_id'],
      title: json['title'],
      price: json['price'],
      position: json['position'],
      inventoryPolicy: json['inventory_policy'],
      compareAtPrice: json['compare_at_price'],
      option1: json['option1'],
      option2: json['option2'],
      option3: json['option3'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      taxable: json['taxable'],
      barcode: json['barcode'],
      fulfillmentService: json['fulfillment_service'],
      grams: json['grams'],
      inventoryManagement: json['inventory_management'],
      requiresShipping: json['requires_shipping'],
      sku: json['sku'],
      weight: json['weight'] == null ? null : (json['weight'] is String ? double.tryParse(json['weight']) : (json['weight'] as num?)?.toDouble()),
      weightUnit: json['weight_unit'],
      inventoryItemId: json['inventory_item_id'],
      inventoryQuantity: json['inventory_quantity'],
      oldInventoryQuantity: json['old_inventory_quantity'],
      adminGraphqlApiId: json['admin_graphql_api_id'],
      imageId: json['image_id'],
      imageSrc: json['image_src'] ?? '',
      productTitle: json['product_title'] ?? '',
      cartQuantity: json['cart_quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['product_id'] = productId;
    data['title'] = title;
    data['price'] = price;
    data['position'] = position;
    data['inventory_policy'] = inventoryPolicy;
    data['compare_at_price'] = compareAtPrice;
    data['option1'] = option1;
    data['option2'] = option2;
    data['option3'] = option3;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['taxable'] = taxable;
    data['barcode'] = barcode;
    data['fulfillment_service'] = fulfillmentService;
    data['grams'] = grams;
    data['inventory_management'] = inventoryManagement;
    data['requires_shipping'] = requiresShipping;
    data['sku'] = sku;
    data['weight'] = weight;
    data['weight_unit'] = weightUnit;
    data['inventory_item_id'] = inventoryItemId;
    data['inventory_quantity'] = inventoryQuantity;
    data['old_inventory_quantity'] = oldInventoryQuantity;
    data['admin_graphql_api_id'] = adminGraphqlApiId;
    data['image_id'] = imageId;
    data['image_src'] = imageSrc;
    data['product_title'] = productTitle;
    data['cart_quantity'] = cartQuantity;
    return data;
  }
}
