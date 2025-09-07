import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:students/functions/loaders.dart';
import 'package:students/models/users.dart';
import 'package:students/screens/landing.dart';
import 'package:students/services/routes.dart';
import 'package:students/utils/snackbars/snackbar_message.dart';
import 'package:students/widgets/button.dart';

import '../../../utils/palettes/app_colors.dart' hide Colors;

class BorrowForm extends StatefulWidget {
  final Map details;
  BorrowForm({required this.details});
  @override
  State<BorrowForm> createState() => _BorrowFormState();
}

class _BorrowFormState extends State<BorrowForm> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  final Routes _routes = new Routes();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  DateTime? _borrow;
  DateTime? _return;

  Future _submit()async{
    DatabaseReference usersRef = database.ref('requests');
    await usersRef.push().set({
      "borrower": {
        "name": usersModel.valueLogged["name"],
        "age": usersModel.valueLogged["age"],
        "email": usersModel.valueLogged["email"],
        "school_id": usersModel.valueLogged["school_id"],
        "department": usersModel.valueLogged["department"],
        "year": usersModel.valueLogged["year"],
        "section": usersModel.valueLogged["section"],
      },
      "book_information": {
        "title": widget.details["title"],
        "author": widget.details["authors"].first["name"]
      },
      "borrow_details": {
        "borrow_date": "$_borrow",
        "end_date": "$_return",
      }
    });
  }

  Future<void> _selectDate({required bool isBorrow}) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: colors.umber,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: colors.umber,
                ),
              ),
            ),
            child: child!,
          );
        },
    );
    if (picked != null) {
      setState(() {
        if(isBorrow){
          _borrow = picked;
        }else{
          _return = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Borrow Form",style: TextStyle(fontFamily: "OpenSans",fontSize: 19, fontWeight: FontWeight.w600),),
        centerTitle: true,
        shadowColor: Colors.grey.shade100,
        elevation: 1,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        children: [
          Text("Borrower",style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.w600,color: colors.umber,fontSize: 15),),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade100),
              borderRadius: BorderRadius.circular(20)
            ),
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
            child: Text("${usersModel.valueLogged["name"]}",style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade100),
                borderRadius: BorderRadius.circular(20)
            ),
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
            child: Text("${usersModel.valueLogged["age"]}",style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade100),
                borderRadius: BorderRadius.circular(20)
            ),
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
            child: Text("${usersModel.valueLogged["email"]}",style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade100),
                borderRadius: BorderRadius.circular(20)
            ),
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
            child: Text("${usersModel.valueLogged["school_id"]}",style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade100),
                borderRadius: BorderRadius.circular(20)
            ),
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
            child: Text("${usersModel.valueLogged["department"]}",style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                  child: Text("${usersModel.valueLogged["year"]}",style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                  child: Text("${usersModel.valueLogged["section"]}",style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Text("Book Information",style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.w600,color: colors.umber,fontSize: 15),),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade100),
                borderRadius: BorderRadius.circular(20)
            ),
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Text(widget.details["title"],style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade100),
                borderRadius: BorderRadius.circular(20)
            ),
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
            child: Text(widget.details["authors"].first["name"],style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
          ),
          SizedBox(
            height: 15,
          ),
          Text("Borrow Details",style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.w600,color: colors.umber,fontSize: 15),),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: (){
              _selectDate(isBorrow: true);
            },
            child: Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade100),
                  borderRadius: BorderRadius.circular(20)
              ),
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
              child: _borrow != null ?
              Text("${DateFormat("MMMM dd, yyyy").format(_borrow!)}",style: TextStyle(fontFamily: "OpenSans",fontSize: 15),) :
              Text("Borrow Date",style: TextStyle(color: Colors.grey,fontFamily: "OpenSans",fontSize: 15),),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: (){
              _selectDate(isBorrow: false);
            },
            child: Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade100),
                  borderRadius: BorderRadius.circular(20)
              ),
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
              child: _return != null ?
              Text("${DateFormat("MMMM dd, yyyy").format(_return!)}",style: TextStyle(fontFamily: "OpenSans",fontSize: 15),) :
              Text("Return Date",style: TextStyle(color: Colors.grey,fontFamily: "OpenSans",fontSize: 15),),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          materialbutton.materialButton(backColor: colors.umber,"Confirm", (){
            if(_borrow == null || _return == null){
              _snackbarMessage.snackbarMessage(context, message: "Borrow details are required.", is_error: true);
            }else{
              _screenLoaders.functionLoader(context);
              _submit().whenComplete((){
                Navigator.of(context).pop(null);
                _snackbarMessage.snackbarMessage(context, message: "Request successfully submitted!");
                _routes.navigator_pushreplacement(context, Landing(), transitionType: PageTransitionType.leftToRightWithFade);
              });
            }
          }),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
