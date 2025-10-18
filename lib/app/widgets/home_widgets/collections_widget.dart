import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keen_official_app/app/methods/download_resize_image.dart';
import 'package:keen_official_app/app/providers/home/home_providers.dart';
import 'package:keen_official_app/app/providers/home/products_provider.dart';
import 'package:keen_official_app/domain/models/product_model.dart';

class CollectionsWidget extends ConsumerWidget {
  const CollectionsWidget({
    super.key,
    required this.products,
  });

  final List<List<Products>> products;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height:((MediaQuery.of(context).size.width - 40 ) / 3) * 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,

          itemCount: products.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              child: GestureDetector(
                onTap: () {
                  ref.read(bottomIndexProvider.notifier).state = 2;
                  index == 0
                      ? ref.read(productsTitleProvider.notifier).state =
                  'T-Shirts'
                      : index == 1
                      ? ref.read(productsTitleProvider.notifier).state = 'Sets'
                      : ref.read(productsTitleProvider.notifier).state = 'Pants';
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: (MediaQuery.of(context).size.width - 40 ) / 3,
                      height:((MediaQuery.of(context).size.width - 40 ) / 3) * 2 ,
                      child: CachedNetworkImage(
                        imageUrl: getResizedImageUrl(
                          products[index][0].images![0].src!,
                          800,
                          800,
                        ),
                        placeholder:
                            (context, url) => Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: Text(
                        index == 0
                            ? 'T-SHIRTS'
                            : index == 1
                            ? 'SETS'
                            : 'PANTS',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
