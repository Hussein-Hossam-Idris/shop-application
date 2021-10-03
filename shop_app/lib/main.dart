import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

import './providers/product_provider.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import './helpers/custom_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Auth(),),
          ///the proucts provider has a constructor argument that depends on the token provider by the Auth provider
          ChangeNotifierProxyProvider <Auth, Products>(create: (context) => Products('','',[]),
              update: (context, auth, previous) => previous!..updateUser(auth.token, auth.userId),
              // update: (context, auth, previous) => Products(auth.token,auth.userId, previous!.items==[] ? [] : previous.items),
          ),
          ChangeNotifierProxyProvider <Auth, Orders>(create: (context) => Orders('','',[]),
            update: (context, auth, previous) => Orders(auth.token,auth.userId,previous!.orders==[] ? [] : previous.orders),
          ),
          ChangeNotifierProvider(create: (context) => Cart(),),
        ],
        child: Consumer<Auth>(builder: (context, auth, child) {
          return MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CustomePageTranstionBuilder(),
                  TargetPlatform.iOS:CustomePageTranstionBuilder(),
                }
              ),
                fontFamily: "Lato",
                primarySwatch: Colors.purple,
                accentColor: Colors.lightGreenAccent),
            home: auth.isAuth? ProductsOverViewScreen() :
            FutureBuilder(builder: (context, snapshot)
            => snapshot.connectionState == ConnectionState.waiting?
                SplashScreen()
                :
                AuthScreen(),
              future: auth.tryAutoLogin(),),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName:(ctx) => CartScreen(),
              OrdersScreen.routeName:(ctx) => OrdersScreen(),
              UserProductsScreen.routeName:(ctx)=>UserProductsScreen(),
              EditProductScreen.routeName:(ctx) => EditProductScreen(),
            },
          );
        },)
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      body: Center(
        child: Text('Let\'s build a shop!'),
      ),
    );
  }
}
