import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductsGridView extends StatelessWidget {
  bool _showOnlyFavs;
  ProductsGridView(this._showOnlyFavs);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = _showOnlyFavs?productsData.favItems:productsData.items;
    return GridView.builder(
      itemCount: products.length,
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 2 / 3,
      ),
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(),
        );
      },
    );
  }
}
