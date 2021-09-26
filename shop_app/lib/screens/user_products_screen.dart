import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user_products';
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [IconButton(onPressed: () {
          Navigator.of(context).pushNamed(EditProductScreen.routeName);
        }, icon: Icon(Icons.add))],
      ),
      body: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: products.items.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              return UserProductItem(products.items[index]);
            },
          )),
    );
  }
}
