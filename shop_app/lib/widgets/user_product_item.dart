import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final Product _product;
  UserProductItem(this._product);
  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return Container(
      height: 150,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (ctx,constraints){
          return Card(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10,top: 10,bottom: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      _product.imageUrl,
                      fit: BoxFit.cover,
                      width: constraints.maxWidth*0.4,
                      height: double.infinity,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  width: constraints.maxWidth*0.4,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_product.title, style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),),
                        Text("\$${_product.price.toStringAsFixed(2)}", style: TextStyle(color: Colors.grey),),
                        SizedBox(height: 10,),
                        Text(_product.description, softWrap: true,),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      IconButton(onPressed: (){
                        Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: _product);
                      }, icon: Icon(Icons.edit), color: Theme.of(context).primaryColor,),
                      IconButton(onPressed: () async{
                          try{
                            await Provider.of<Products>(context, listen: false).deleteProduct(_product.id);
                          }catch(error){
                            scaffold.showSnackBar(SnackBar(content: Text('deleting failed')));
                          }
                      }, icon: Icon(Icons.delete), color: Colors.red,),
                    ],
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}
