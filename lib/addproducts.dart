import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
   CollectionReference products = FirebaseFirestore.instance.collection("products");
  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  // TextEditingController imageController = TextEditingController();

  //byte64img work

final ImagePicker picker = ImagePicker();
String imgUrl ="";
getImage()async{
  
final XFile? image = await picker.pickImage(source: ImageSource.gallery);

final Uint8List byteImage = await image!.readAsBytes();
//image ---> [12,132,3235,775,.....]
print(byteImage);
//base 64 algorithem
final String base64img = base64Encode(byteImage);
print(base64img);
setState(() {
  imgUrl =base64img;
});
}






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new product"),
        actions: [
          IconButton(onPressed: (){
            Navigator.pushNamed(context, "/add");
          }, icon: Icon(Icons.add))
        ],
      ),
      body:
       Padding(
         padding: const EdgeInsets.all(8.0),
         child: Center(
          child: ListView(
         children: [
        TextField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: "Title",
            hintText: "Enter the title of the product"
          ),
        ),
        TextField(
          controller: desController,
          decoration: InputDecoration(
           labelText: "Description",
            hintText: "Enter the description of the product"
          ),
        ),
        TextField(
          controller: priceController,
          decoration: InputDecoration(
            labelText: "Price",
            hintText: "Enter the price of the product"
          ),
        ),
        // TextField(
        //    controller: imageController,
        //   decoration: InputDecoration(
        //     labelText: "Image Url",
        //     hintText: "Enter the Image Url of the product"
        //   ),
        // ),
      ElevatedButton(onPressed: (){
getImage();
      }, child: Text("Choose File")),

        ElevatedButton(onPressed: 
        (){
          //Add product in database
          products.add({
            'title': titleController.text,
'description': desController.text,
'price': double.parse(priceController.text),
'image': imgUrl,

        }).then((value) =>{
         titleController.clear(),
         desController.clear(),
         priceController.clear(),
        //  imageController.clear(),
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("products added succesfully"),
         ))}).catchError((error)=>{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("products added succesfully")), )
         });
        }, 
         child: Text("Add Product")),
         ],
          ),
               ),
       ),
    );
  }
}