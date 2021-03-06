import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import 'package:provider/provider.dart';
import '../widgets/badge.dart';
import 'package:http/http.dart' as http;

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
  var _isloading = false;


  @override
  void initState() {
    setState(() {
      _isloading = true;
    });
    Provider.of<Products>(context, listen: false).fetchAndSetProduct().then((value) {
      setState(() {
        _isloading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
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
          ),
          Consumer<Cart>(
            builder: (_, value, child) => Badge(
              child: child!,
              value: value.itemCount.toString(),
              color: Colors.red,
            ),
            child: IconButton(icon: Icon(Icons.shopping_cart),
            onPressed: (){
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
          )
        ],
      ),
      body: _isloading?Center(child: CircularProgressIndicator()) : ProductsGridView(_showOnlyFavorites)
    );
  }
}

