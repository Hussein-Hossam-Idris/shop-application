import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

import './providers/product_provider.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (BuildContext context) => Products(),
          ),
          ChangeNotifierProvider(create: (context) => Cart(),)
        ],
        child: MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
              fontFamily: "Lato",
              primarySwatch: Colors.purple,
              accentColor: Colors.lightGreenAccent),
          home: ProductsOverViewScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          },
        )
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
