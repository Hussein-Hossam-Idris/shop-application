import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import '../providers/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final _product = Provider.of<Product>(context, listen: false);
        final _cart = Provider.of<Cart>(context, listen: false);
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: Colors.black, style: BorderStyle.solid, width: 0.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                splashColor: Theme.of(context).primaryColor,
                onTap: () => Navigator.of(context).pushNamed(
                    ProductDetailScreen.routeName,
                    arguments: _product.id),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child: Image.network(
                        _product.imageUrl,
                        width: double.infinity,
                        height: constraints.maxHeight * 0.7,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Consumer<Product>(
                        builder: (context, product, child) => IconButton(
                            onPressed: () async{
                              try{
                               await _product.toggleFavoriteStatus();
                              }catch(e){
                                scaffoldMessenger.showSnackBar(SnackBar(content: Text(e.toString())));
                              }
                            },
                            icon: Icon(product.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border),
                            color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  _product.title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: constraints.maxHeight * 0.07,
                      color: Colors.black),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 7, right: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${_product.price.toStringAsFixed(2)}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: constraints.maxWidth * 0.1),
                    ),
                    IconButton(
                      onPressed: () {
                        _cart.addItem(
                            _product.id, _product.price, _product.title);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Item added to your cart'),
                          duration: Duration(seconds: 3),
                          action: SnackBarAction(
                            label: "UNDO",
                            onPressed: () {
                              _cart.removeItem(_product.id);
                            },
                          ),
                        ));
                      },
                      icon: Icon(Icons.shopping_cart),
                      color: Theme.of(context).accentColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
