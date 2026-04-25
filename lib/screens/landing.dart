import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:students/models/borrows.dart';
import 'package:students/models/reservations.dart';
import 'package:students/screens/books/books.dart';
import 'package:students/screens/logbooks/logbooks.dart';
import 'package:students/screens/profile/components/edit_profile.dart';
import 'package:students/screens/requests/requests.dart';
import 'package:students/services/apis/borrows.dart';
import 'package:students/services/apis/reservations.dart';
import 'package:students/utils/palettes/app_colors.dart' hide Colors;
import 'package:students/utils/snackbars/snackbar_message.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../models/notifications.dart';
import '../models/users.dart';
import '../services/apis/notifications.dart';
import '../utils/snackbars/notification_modal.dart';

class Landing extends StatefulWidget {
  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  final ReservationApis _reservationApis = new ReservationApis();
  final NotificationApis _notificationApis = new NotificationApis();
  final BorrowsApis _borrowsApis = new BorrowsApis();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  final _borrow = FirebaseDatabase.instance.ref().child('borrow');
  // final _return = FirebaseDatabase.instance.ref().child('return');
  final _controller = PageController();
  int _selected = 0;

  @override
  void initState() {
    // TODO: implement initState
    _borrowsApis.get();
    _reservationApis.get();
    _notificationApis.get();
    _notificationChecker();
    uploadPict.update(data: base64Decode(usersModel.loggedUser.value["base64Image"] ?? null));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _controller,
        children: [
          Books(),
          StreamBuilder(
              stream: _borrow.onValue,
              builder: (context, snapshotBorrow) {
                List? _borrows;
                List? _returns;
                if(snapshotBorrow.hasData){
                  if(snapshotBorrow.data!.snapshot.value != null){
                    _borrows = (snapshotBorrow.data!.snapshot.value as Map).values.toList().where((s) => s["borrower"]["email"] == usersModel.loggedUser.value["email"] && s["status"] == "Accepted").toList();
                    _returns = (snapshotBorrow.data!.snapshot.value as Map).values.toList().where((s) => s["borrower"]["email"] == usersModel.loggedUser.value["email"] && s["status"] == "Returned").toList();
                  }
                }
                return !snapshotBorrow.hasData ?
                Center(
                  child: CircularProgressIndicator(color: colors.umber,),
                ) : Requests(borrowBooks: _borrows ?? [], returnBooks: _returns ?? [],);
              }
          ),
          Logbooks()
        ],
      ),
      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(
          iconStyle: IconStyle.animated,
        ),
        items: [
          BottomBarItem(
            icon: Icon(Icons.book_outlined,size: 28,),
            title: const Text('Books',style: TextStyle(fontFamily: "OpenSans"),),
            backgroundColor: colors.umber,
            selectedIcon: Icon(Icons.book),
          ),
          BottomBarItem(
            icon: Icon(Icons.collections_bookmark_outlined,size: 28,),
            title: const Text('Requests',style: TextStyle(fontFamily: "OpenSans"),),
            backgroundColor: colors.umber,
            selectedIcon: Icon(Icons.collections_bookmark),
          ),
          BottomBarItem(
            icon: Icon(Icons.calendar_today_outlined,size: 25,),
            title: const Text('Logbooks',style: TextStyle(fontFamily: "OpenSans"),),
            backgroundColor: colors.umber,
            selectedIcon: Icon(Icons.calendar_today),
          ),
        ],
        hasNotch: false,
        currentIndex: _selected,
        onTap: (index) {
          setState(() {
            _selected = index;
            _controller.jumpToPage(index);
          });
        },
      )
    );
  }

  void _notificationChecker(){
    Future.delayed(const Duration(seconds: 10), () {
      _notificationApis.get().whenComplete((){
        List _res = notificationModel.current.where((s) => s["is_showed"] == "0").toList();
        if(_res.isNotEmpty){
          if(_res.first["payload"]["borrower"]["email"] == usersModel.loggedUser.value["email"]){
            _snackbarMessage.snackbarMessage(context);
            _showTopSnackBar(context, content: _res.first["content"], isDuedate: false);
            _notificationApis.showed(id: _res.first["id"]);
          }
        }
        _notificationChecker();
      });
      List _res2 = borrowsModel.current.where((s) => DateTime.parse(s["borrow_details"]["end_date"]).difference(DateTime.now()).inDays == 1).toList();
      if(!borrowsModel.checkers.toString().contains("${_res2.first["id"]}")){
        setState(() {
          borrowsModel.checkers.add("${_res2.first["id"]}");
        });
        _showTopSnackBar(context, content: "One borrowed book is due date by tomorrrow, see requests page for more details!", isDuedate: true);
      }
    });
  }

  void _showTopSnackBar(BuildContext context,{required String content, required bool isDuedate}) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          if(isDuedate)...{
            Icon(Icons.info_outline, color: Colors.white,),
          }else...{
            Icon(Icons.notifications_active_outlined, color: Colors.white,),
          },
          SizedBox(width: 10),
          Expanded(
            child: Text(content),
          )
        ],
      ),
      behavior: SnackBarBehavior.floating, // Makes it a floating widget
      margin: EdgeInsets.only(
        // Calculate the bottom margin to push it to the top
        bottom: MediaQuery.of(context).size.height - 150,
        left: 10,
        right: 10,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
