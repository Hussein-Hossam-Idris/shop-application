import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_item_widget.dart';
class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final scaffoldMas = ScaffoldMessenger.of(context);
    final cart = Provider.of<Cart>(context);
    final order = Provider.of<Orders>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Total',
                        style: TextStyle(
                          fontSize: 20,
                        ),),
                      SizedBox(width: 10,),
                      Chip(
                        label: Text("\$${cart.totalAmount.toStringAsFixed(2)}"),
                        backgroundColor: Theme.of(context).accentColor,
                      ),
                    ],
                  ),
                  ElevatedButton(
                    child:_isLoading? CircularProgressIndicator():  Text('Place Order'),
                    onPressed:(cart.totalAmount<=0 || _isLoading)? null : () async{
                      setState(() {
                        _isLoading = true;
                      });
                      try{
                        await order.addOrder(cart.items.values.toList(), cart.totalAmount);
                        cart.clearCart();
                        setState(() {
                          _isLoading = false;
                        });
                      }catch(error){
                        scaffoldMas.showSnackBar(SnackBar(content: Text('order was not added')));
                      }
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    )
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20,),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (context, index) {
                return CartItemWidget(
                  title: cart.items.values.toList()[index].title,
                  id:  cart.items.values.toList()[index].id,
                  price:  cart.items.values.toList()[index].price,
                  productId:  cart.items.values.toList()[index].productId,
                  quantity:  cart.items.values.toList()[index].quantity,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}


