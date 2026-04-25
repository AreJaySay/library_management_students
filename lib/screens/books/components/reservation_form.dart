import 'dart:convert';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:students/functions/loaders.dart';
import 'package:students/models/users.dart';
import 'package:students/screens/landing.dart';
import 'package:students/services/apis/borrows.dart';
import 'package:students/services/apis/notifications.dart';
import 'package:students/services/apis/reservations.dart';
import 'package:students/services/routes.dart';
import 'package:students/utils/snackbars/snackbar_message.dart';
import 'package:students/widgets/button.dart';

import '../../../utils/palettes/app_colors.dart' hide Colors;

class ReservationForm extends StatefulWidget {
  final bool isReserved;
  final Map details;
  ReservationForm({required this.isReserved, required this.details});
  @override
  State<ReservationForm> createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
  final ReservationApis _reservationApis = new ReservationApis();
  final BorrowsApis _borrowsApis = new BorrowsApis();
  final Routes _routes = new Routes();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  final NotificationApis _notificationApis = new NotificationApis();
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  DateTime? _from;
  DateTime? _return;

  Future<void> _selectDate({required bool isFrom}) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: isFrom ? DateTime.now() : _from,
        firstDate: isFrom ? DateTime.now() : _from!,
        lastDate: isFrom ? DateTime(2101) : _from!.add(const Duration(days: 2)),
        // firstDate: DateTime(2024),
        // lastDate: DateTime(2100),
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
        if(isFrom){
          _from = picked;
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
        title: Text("Reservation Form",style: TextStyle(fontFamily: "OpenSans",fontSize: 19, fontWeight: FontWeight.w600),),
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
          if(widget.details["author"].isNotEmpty)...{
            Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade100),
                  borderRadius: BorderRadius.circular(20)
              ),
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
              child: Text(widget.details["author"],style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
            ),
          },
          if(widget.isReserved)...{
            SizedBox(
              height: 15,
            ),
            Text("Reservation Details",style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.w600,color: colors.umber,fontSize: 15),),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: (){
                _selectDate(isFrom: true);
              },
              child: Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(20)
                ),
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                child: _from != null ?
                Text("${DateFormat("MMMM dd, yyyy").format(_from!)}",style: TextStyle(fontFamily: "OpenSans",fontSize: 15),) :
                Text("Borrow Date",style: TextStyle(color: Colors.grey,fontFamily: "OpenSans",fontSize: 15),),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: (){
                if(_from != null){
                  _selectDate(isFrom: false);
                }else{
                  _snackbarMessage.snackbarMessage(context, message: "Pick borrow start date first!",is_error: true);
                }
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
          },
          SizedBox(
            height: widget.isReserved ? 50 : 80,
          ),
          materialbutton.materialButton(backColor: colors.umber,"Confirm", (){
            if(widget.isReserved){
              _reserve();
            }else{
              _borrow();
            }
          }),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
  void _reserve(){
    if(_from == null || _return == null){
      _snackbarMessage.snackbarMessage(context, message: "Borrow details are required.", is_error: true);
    }else{
      String _content = "${usersModel.loggedUser.value["name"]} request a reservation to borrow ${widget.details["title"]} on ${DateFormat("MMM dd, yyyy").format(_return!)}.";
      print(_content);
      _screenLoaders.functionLoader(context);
      _reservationApis.add(details: widget.details, start: _from!, end: _return!).whenComplete((){
        _notificationApis.add(type: "book_reservation", content: _content);
        _reservationApis.get().whenComplete((){
          Navigator.of(context).pop(null);
          _snackbarMessage.snackbarMessage(context, message: "Request successfully submitted!");
          _routes.navigator_pushreplacement(context, Landing(), transitionType: PageTransitionType.leftToRightWithFade);
        });
      });
    }
  }

  void _borrow(){
    String _content = "${usersModel.loggedUser.value["name"]} request a reservation to borrow ${widget.details["title"]}.";
    print(_content);
    _screenLoaders.functionLoader(context);
    _borrowsApis.borrow(details: widget.details, status: "Accepted").whenComplete((){
      Navigator.of(context).pop(null);
      Navigator.of(context).pop(null);
      _snackbarMessage.snackbarMessage(context, message: "Borrow book successfully submitted!");
    });
  }
}
