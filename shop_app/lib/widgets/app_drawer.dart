import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/custom_route.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: Row(
                children: [
                  Icon(Icons.shopping_basket_rounded,size: 24, color: Colors.white,),
                  SizedBox(width: 10,),
                  Text('Your Shop', style: TextStyle(
                    fontSize: 24,
                    color: Colors.white
                  ),),
                ],
              ),
            ),
            SizedBox(height: 30,),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Shop'),
              onTap: (){
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Orders'),
              onTap: (){
                // Navigator.of(context).pushReplacement(CustomRoute(builder: (context) => OrdersScreen()));
                Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Manage Products'),
              onTap: (){
                Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log out'),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
