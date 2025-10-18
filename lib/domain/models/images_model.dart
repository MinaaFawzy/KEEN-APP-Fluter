class Images {
  int? id;
  double? alt;
  int? position;
  int? productId;
  String? createdAt;
  String? updatedAt;
  String? adminGraphqlApiId;
  int? width;
  int? height;
  String? src;
  List<int>? variantIds;

  Images({
    this.id,
    this.alt,
    this.position,
    this.productId,
    this.createdAt,
    this.updatedAt,
    this.adminGraphqlApiId,
    this.width,
    this.height,
    this.src,
    this.variantIds,
  });

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    alt = json['alt'];
    position = json['position'];
    productId = json['product_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    adminGraphqlApiId = json['admin_graphql_api_id'];
    width = json['width'];
    height = json['height'];
    src = json['src'];
    variantIds = json['variant_ids'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['alt'] = this.alt;
    data['position'] = this.position;
    data['product_id'] = this.productId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['admin_graphql_api_id'] = this.adminGraphqlApiId;
    data['width'] = this.width;
    data['height'] = this.height;
    data['src'] = this.src;
    data['variant_ids'] = this.variantIds;
    return data;
  }
}
