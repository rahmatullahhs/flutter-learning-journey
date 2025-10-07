import 'package:flutter/material.dart';


class Loginpage extends StatelessWidget{
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();



  @override
  Widget build(BuildContext context) {
 return Scaffold(
   body: Padding(
       padding: EdgeInsets.all(16.00),

     child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         TextField(
           controller:email,
           decoration: InputDecoration(
             labelText: "Email",
               hintText: "hankipanki@gmail.com",
             border: OutlineInputBorder(),
             prefixIcon: Icon(Icons.email)

           ),
         )
       ],
     ),

   ),



 );
  }



}