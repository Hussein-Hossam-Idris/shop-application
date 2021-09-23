import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final _product = Provider.of<Product>(context,listen: false);
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.black,
              style: BorderStyle.solid,
                width: 0.2
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                splashColor: Theme.of(context).primaryColor,
                onTap: ()=>Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: _product.id
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                      child: Image.network(
                        _product.imageUrl,
                        width: double.infinity,
                        height: constraints.maxHeight * 0.7,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Consumer<Product>(builder: (context, product, child) => IconButton(
                          onPressed: () {
                            _product.toggleFavoriteStatus();
                          },
                          icon: Icon(product.isFavorite? Icons.favorite:Icons.favorite_border),
                          color: Colors.red),),
                    ),

                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  _product.title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: constraints.maxHeight*0.07, color: Colors.black),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 7,right: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("\$${_product.price.toStringAsFixed(2)}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: constraints.maxWidth * 0.1
                      ),
                    ),
                    IconButton(onPressed: (){},icon: Icon(Icons.shopping_cart), color: Theme.of(context).accentColor,),
                    // TextButton(onPressed: (){},
                    //   child: Text(
                    //   'add to cart',
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: constraints.maxWidth * 0.1
                    //   ),
                    // ),
                    //   style: ButtonStyle(
                    //   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    //       RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(18.0),
                    //       side: BorderSide(color: Colors.black, width: 0.7),
                    //       )
                    //   ),
                    // )
                    // ),
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
