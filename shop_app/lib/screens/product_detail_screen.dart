import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = 'product-detail-screen';
  @override
  Widget build(BuildContext context) {
    // final mediaQuery = MediaQuery.of(context);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final product =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 300,
              child: Hero(
                tag: productId,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(Icons.star,color: Colors.orangeAccent,),
                  Icon(Icons.star,color: Colors.orangeAccent),
                  Icon(Icons.star,color: Colors.orangeAccent),
                  Icon(Icons.star_border,color: Colors.orangeAccent),
                  Icon(Icons.star_border,color: Colors.orangeAccent),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                "\$${product.price}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              width: double.infinity,
              child: Text(
                product.description,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ElevatedButton(
                onPressed: (){},
                child: Container(
                  height: 40,
                  width: double.infinity,
                    alignment: Alignment.center,
                    child: Text('Add to Cart', style: TextStyle(fontSize: 18),)),
              ),
            ),
            SizedBox(height: 40)
          ],
        ),
      ),
    );
  }
}
