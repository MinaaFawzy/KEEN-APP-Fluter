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

  Variants({
    this.id,
    this.productId,
    this.title,
    this.price,
    this.position,
    this.inventoryPolicy,
    this.compareAtPrice,
    this.option1,
    this.option2,
    this.option3,
    this.createdAt,
    this.updatedAt,
    this.taxable,
    this.barcode,
    this.fulfillmentService,
    this.grams,
    this.inventoryManagement,
    this.requiresShipping,
    this.sku,
    this.weight,
    this.weightUnit,
    this.inventoryItemId,
    this.inventoryQuantity,
    this.oldInventoryQuantity,
    this.adminGraphqlApiId,
    this.imageId,
  });

  Variants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    title = json['title'];
    price = json['price'];
    position = json['position'];
    inventoryPolicy = json['inventory_policy'];
    compareAtPrice = json['compare_at_price'];
    option1 = json['option1'];
    option2 = json['option2'];
    option3 = json['option3'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    taxable = json['taxable'];
    barcode = json['barcode'];
    fulfillmentService = json['fulfillment_service'];
    grams = json['grams'];
    inventoryManagement = json['inventory_management'];
    requiresShipping = json['requires_shipping'];
    sku = json['sku'];
    weight = json['weight'];
    weightUnit = json['weight_unit'];
    inventoryItemId = json['inventory_item_id'];
    inventoryQuantity = json['inventory_quantity'];
    oldInventoryQuantity = json['old_inventory_quantity'];
    adminGraphqlApiId = json['admin_graphql_api_id'];
    imageId = json['image_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['title'] = this.title;
    data['price'] = this.price;
    data['position'] = this.position;
    data['inventory_policy'] = this.inventoryPolicy;
    data['compare_at_price'] = this.compareAtPrice;
    data['option1'] = this.option1;
    data['option2'] = this.option2;
    data['option3'] = this.option3;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['taxable'] = this.taxable;
    data['barcode'] = this.barcode;
    data['fulfillment_service'] = this.fulfillmentService;
    data['grams'] = this.grams;
    data['inventory_management'] = this.inventoryManagement;
    data['requires_shipping'] = this.requiresShipping;
    data['sku'] = this.sku;
    data['weight'] = this.weight;
    data['weight_unit'] = this.weightUnit;
    data['inventory_item_id'] = this.inventoryItemId;
    data['inventory_quantity'] = this.inventoryQuantity;
    data['old_inventory_quantity'] = this.oldInventoryQuantity;
    data['admin_graphql_api_id'] = this.adminGraphqlApiId;
    data['image_id'] = this.imageId;
    return data;
  }
}
