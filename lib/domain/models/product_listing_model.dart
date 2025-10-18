import 'package:keen_official_app/domain/models/variants_model.dart';

import 'images_model.dart';
import 'options_model.dart';

class ProductListings {
  int? productId;
  String? createdAt;
  String? updatedAt;
  String? bodyHtml;
  String? handle;
  String? productType;
  String? title;
  String? vendor;
  bool? available;
  String? tags;
  String? publishedAt;
  List<Variants>? variants;
  List<Images>? images;
  List<Options>? options;

  ProductListings(
      {this.productId,
        this.createdAt,
        this.updatedAt,
        this.bodyHtml,
        this.handle,
        this.productType,
        this.title,
        this.vendor,
        this.available,
        this.tags,
        this.publishedAt,
        this.variants,
        this.images,
        this.options});

  ProductListings.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bodyHtml = json['body_html'];
    handle = json['handle'];
    productType = json['product_type'];
    title = json['title'];
    vendor = json['vendor'];
    available = json['available'];
    tags = json['tags'];
    publishedAt = json['published_at'];
    if (json['variants'] != null) {
      variants = <Variants>[];
      json['variants'].forEach((v) {
        variants!.add(new Variants.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['body_html'] = this.bodyHtml;
    data['handle'] = this.handle;
    data['product_type'] = this.productType;
    data['title'] = this.title;
    data['vendor'] = this.vendor;
    data['available'] = this.available;
    data['tags'] = this.tags;
    data['published_at'] = this.publishedAt;
    if (this.variants != null) {
      data['variants'] = this.variants!.map((v) => v.toJson()).toList();
    }
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}