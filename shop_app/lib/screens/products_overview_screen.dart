import 'package:flutter/material.dart';
import 'package:shop_app/providers/product_provider.dart';
import '../widgets/products_grid.dart';
import 'package:provider/provider.dart';

enum filterOptions{
  Favorites,
  All,
}

class ProductsOverViewScreen extends StatefulWidget {
  @override
  _ProductsOverViewScreenState createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  var _showOnlyFavorites = false;
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products Overview'),
        actions: [
          PopupMenuButton(
            onSelected: (filterOptions selectedValue){
              setState(() {
                if(selectedValue == filterOptions.Favorites){
                  _showOnlyFavorites = true;
                }else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) {
              return [
                PopupMenuItem(child: Text('show favorites'), value: filterOptions.Favorites,),
                PopupMenuItem(child: Text('show all'), value: filterOptions.All,),
              ];
            },
          )
        ],
      ),
      body: ProductsGridView(_showOnlyFavorites)
    );
  }
}

