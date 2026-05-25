import 'package:flutter/material.dart';
import 'package:keen_official_app/domain/models/variants_model.dart';

class TotalPriceWidget extends StatelessWidget {
  const TotalPriceWidget({
    super.key,
    required this.cartItems,
    required this.totalPrice,
  });

  final List<Variants> cartItems;
  final double totalPrice;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          Container(
            padding: const EdgeInsets.all(12),
            width: MediaQuery.of(context).size.width - 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Total:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),), Spacer(), Text("LE ${totalPrice.toStringAsFixed(2)}")],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width ,
            height: 50,
            child: TextButton(
              onPressed: () {
                print('CheckOut Button pressed');
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: Text('Checkout'),

            ),
          ),
        ],
      ),
    );
  }
}
