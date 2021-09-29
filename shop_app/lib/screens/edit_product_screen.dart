import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  var _isInit = true;
  final _formKey = GlobalKey<FormState>();
  var product =
      Product(id: "", title: "", description: "", price: 0, imageUrl: "");
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateWidget);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      try {
        final argProduct =
            ModalRoute.of(context)!.settings.arguments as Product;
        product = argProduct;
        _imageUrlController.text = product.imageUrl;
      } catch (e) {
        return;
      }
    }
    _isInit = !_isInit;
    super.didChangeDependencies();
  }

  void _updateWidget() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          !_imageUrlController.text.startsWith('http') ||
          !_imageUrlController.text.startsWith('https')) {
        return null;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateWidget);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    ///this fires of all the validation functions in the formfields
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (product.id != "") {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(product.id, product);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(product);
      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('An error has occurred'),
                content: Text('Something went wrong'),
                actions: [
                  FlatButton(onPressed: () {
                    Navigator.of(context).pop();
                  }, child: Text('ok'))
                ],
              );
            });
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        initialValue: "${product.title}",
                        validator: (value) {
                          ///returning null means there's no error and the input is correct
                          if (value!.isEmpty) {
                            return "please provide a value";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          product = Product(
                              title: value as String,
                              price: product.price,
                              description: product.description,
                              imageUrl: product.imageUrl,
                              id: product.id,
                              isFavorite: product.isFavorite);
                        },
                        decoration: InputDecoration(
                          labelText: "Title",
                          suffixIcon: Icon(Icons.shopping_cart),
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                      ),
                      TextFormField(
                        initialValue: "${product.price}",
                        onSaved: (value) {
                          product = Product(
                              title: product.title,
                              price: double.parse(value as String),
                              description: product.description,
                              imageUrl: product.imageUrl,
                              id: product.id,
                              isFavorite: product.isFavorite);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a price';
                          }
                          if (double.tryParse(value) == null) {
                            return "Please enter a valid number";
                          }
                          if (double.parse(value) <= 0) {
                            return "please enter a positive number";
                          }
                          return null;
                        },
                        focusNode: _priceFocusNode,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Price",
                          suffixIcon: Icon(Icons.attach_money),
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) => FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode),
                      ),
                      TextFormField(
                        initialValue: "${product.description}",
                        onSaved: (value) {
                          product = Product(
                              title: product.title,
                              price: product.price,
                              description: value as String,
                              imageUrl: product.imageUrl,
                              id: product.id,
                              isFavorite: product.isFavorite);
                        },
                        focusNode: _descriptionFocusNode,
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          ///returning null means there's no error and the input is correct
                          if (value!.isEmpty) {
                            return "please provide a description";
                          }
                          if (value.length < 10) {
                            return "description should be more than 10 characters";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Description",
                          suffixIcon: Icon(Icons.description),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Center(child: Text('Enter a URL'))
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              onSaved: (value) {
                                product = Product(
                                    title: product.title,
                                    price: product.price,
                                    description: product.description,
                                    imageUrl: value as String,
                                    id: product.id,
                                    isFavorite: product.isFavorite);
                              },
                              onFieldSubmitted: (value) {
                                _updateWidget();
                              },
                              validator: (value) {
                                if (value!.isEmpty)
                                  return "please enter an image URL";
                                if (!value.startsWith('http') ||
                                    !value.startsWith('https'))
                                  return 'please enter a valid URL';

                                return null;
                              },
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                labelText: "Image Url",
                              ),
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveForm,
                          child: Text('Submit Product'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
