import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductApi extends StatefulWidget {
  const ProductApi({super.key});

  @override
  State<ProductApi> createState() => _ProductApiState();
}

class _ProductApiState extends State<ProductApi> {
  getProduct()async{
var url = Uri.parse('https://dummyjson.com/products');
var response = await http.get(url);
return jsonDecode(response.body); 
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products from API"),
      ),
      body:
       Padding(
         padding: EdgeInsets.symmetric(horizontal: 20),
         child: FutureBuilder(future: getProduct(), builder: (context,snapshot){
         if(snapshot.connectionState == ConnectionState.waiting){
         return Center(child: CircularProgressIndicator());
         }
         else if(snapshot.hasError){
         return Center(child: Text("Error: ${snapshot.error}"));
         }
         else if(snapshot.hasData){
          var data =snapshot.data as Map<String,dynamic>;
          var products = data["products"] as List<dynamic>;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context,index){
var product = products[index];
return ListTile(
title: Text(product['title'].toString()),
subtitle:Text(product['price'].toString()),
leading: Image.network(product['thumbnail']),
);
          }
          );
         
         } else{
            return Center(child: Text("No data Availabe "));
          }
               },
               ),
       ),
    );
  }
}