import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:students/models/notifications.dart';
import 'package:students/services/apis/notifications.dart';
import 'package:students/utils/palettes/app_colors.dart' hide Colors;

import '../../models/borrows.dart';

class Notifications extends StatefulWidget {
  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final NotificationApis _notificationApis = new NotificationApis();

  @override
  void initState() {
    // TODO: implement initState
    _notificationApis.get().whenComplete((){
      setState(() {
        borrowsModel.checkers.clear();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: notificationModel.subject,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            shadowColor: Colors.grey.shade100,
            title: Text("Notifications",style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w500,fontSize: 20),),
          ),
          body: !snapshot.hasData ?
          Center(
            child: CircularProgressIndicator(),
          ) :
          Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 15),
            child: GroupedListView<dynamic, String>(
              elements: snapshot.data!,
              groupBy: (element) => DateFormat.yMMMd().format(DateTime.parse(element['created_at'])),
              groupSeparatorBuilder: (String groupByValue) => Container(
                width: double.infinity,
                margin: EdgeInsetsGeometry.symmetric(horizontal: 20,vertical: 15),
                height: 35,
                decoration: BoxDecoration(
                  color: colors.coffee,
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Center(child: Text(groupByValue,style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w600),)),
              ),
              itemBuilder: (context, dynamic element) => GestureDetector(
                onTap: (){
                  _notificationApis.seen(id: element["id"]);
                },
                child: Container(
                    width: double.infinity,
                    height: 90,
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: element["is_read"] == "1" ? Colors.transparent : Colors.white,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: element["type"] == "book_added" ?
                    _addedBookUi() : element["type"] == "borrow_accepted" ? _borrowAcceptedUi() : element["type"] == "borrow_declined" ? _borrowDeclinedUi() : SizedBox()
                ),
              ),
              itemComparator: (item1, item2) => item1['created_at'].compareTo(item2['created_at']), // optional
              useStickyGroupSeparators: true,
              floatingHeader: true,
              order: GroupedListOrder.ASC,
            ),
          ),
        );
      }
    );
  }
  Widget _addedBookUi(){
    return Row(
      children: [
        CircleAvatar(
            maxRadius: 27,
            minRadius: 27,
            backgroundColor: Color.fromARGB(
              255,
              Random().nextInt(256),
              Random().nextInt(256),
              Random().nextInt(256),
            ).withOpacity(0.2),
            child: Image(
              width: 28,
              height: 28,
              color: colors.clay,
              image: AssetImage("assets/icons/add_book.png"),
            )
            // Image(
            //   width: 28,
            //   height: 28,
            //   color: Colors.green,
            //   image: AssetImage("assets/icons/request_accepted.png"),
            // )
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text( "New book is available!",style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w600),),
              SizedBox(
                height: 5,
              ),
              Text("You can now read or borrow the latest book added to the library.",style: TextStyle(color: Colors.grey),)
            ],
          ),
        )
      ],
    );
  }

  Widget _borrowAcceptedUi(){
    return Row(
      children: [
        CircleAvatar(
            maxRadius: 27,
            minRadius: 27,
            backgroundColor: Color.fromARGB(
              255,
              Random().nextInt(256),
              Random().nextInt(256),
              Random().nextInt(256),
            ).withOpacity(0.2),
            child: Image(
            width: 28,
            height: 28,
            color: Colors.green,
            image: AssetImage("assets/icons/request_accepted.png"),
          )
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text( "Request to borrow approved!",style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w600),),
              SizedBox(
                height: 5,
              ),
              Text("Your request to borrow the book has been approved.",style: TextStyle(color: Colors.grey),)
            ],
          ),
        )
      ],
    );
  }

  Widget _borrowDeclinedUi(){
    return Row(
      children: [
        CircleAvatar(
            maxRadius: 27,
            minRadius: 27,
            backgroundColor: Color.fromARGB(
              255,
              Random().nextInt(256),
              Random().nextInt(256),
              Random().nextInt(256),
            ).withOpacity(0.2),
            child: Image(
              width: 40,
              height: 40,
              image: AssetImage("assets/icons/request_declined.png"),
            )
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text( "Request to borrow declined!",style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w600),),
              SizedBox(
                height: 5,
              ),
              Text("Your request to borrow the book has been declined.",style: TextStyle(color: Colors.grey),)
            ],
          ),
        )
      ],
    );
  }
}
