import 'package:flutter/material.dart';

class showproducts extends StatelessWidget {
  final String productTitle;
  final String productImage;
  final int produtPrice;
  final Function()? onTap;

  const showproducts({
    required this.productTitle,
    required this.productImage,
    required this.produtPrice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        margin: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ✅ Image Container
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(productImage),
                  fit: BoxFit.contain, // 🔥 Same size look
                  onError: (error, stackTrace) {
                    print("Image Load Error: $error");
                  },
                ),
              ),
            ),

            /// ✅ Title + Price Container
            Container(
              width: 150,
              margin: EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Rs $produtPrice",
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
