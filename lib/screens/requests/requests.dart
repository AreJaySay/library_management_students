import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:students/screens/requests/components/borrow.dart';
import 'package:students/screens/requests/components/return.dart';
import 'package:students/screens/requests/search_page.dart';
import 'package:students/utils/palettes/app_colors.dart' hide Colors;
import '../../models/borrows.dart';
import '../../models/notifications.dart';
import '../../models/users.dart';
import '../../services/routes.dart';
import '../notifications/notification.dart';
import '../profile/components/edit_profile.dart';
import '../profile/profile_page.dart';

class Requests extends StatefulWidget {
  final List borrowBooks, returnBooks;
  Requests({required this.borrowBooks, required this.returnBooks});
  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> with TickerProviderStateMixin {
  late TabController _controller;
  final Routes _routes = new Routes();

  @override
  void initState() {
    // TODO: implement initState
    _controller = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    borrowsModel.checkers.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        body: NestedScrollView(
          // Header slivers (e.g., SliverAppBar with a TabBar)
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                leading: Center(
                  child: SizedBox(
                    width: 35,
                    height: 35,
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/logos/ssu_logo.png"),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: (){
                      print(widget.borrowBooks);
                      _routes.navigator_push(context, SearchPage(books: widget.borrowBooks));
                    },
                  ),
                  StreamBuilder(
                      stream: notificationModel.subject,
                      builder: (context, snapshot) {
                        return !snapshot.hasData ?
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: colors.umber, strokeWidth: 3,),
                        ) :
                        IconButton(
                          icon: Badge(
                            label: Text("${snapshot.data!.where((s) => s["is_read"] == "0").toList().length}"),
                            child: Icon(Icons.notifications_none,size: 27, color: colors.umber,),
                          ),
                          onPressed: (){
                            _routes.navigator_push(context, Notifications());
                          },
                        );
                      }
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: (){
                      _routes.navigator_push(context, ProfilePage());
                    },
                    child: StreamBuilder(
                        stream: uploadPict.subject,
                        builder: (context, profileSnapshot) {
                          return  !profileSnapshot.hasData ?
                          CircularProgressIndicator() :
                          profileSnapshot.data!.isNotEmpty ?
                          Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(1000),
                                image: DecorationImage(
                                    image: MemoryImage(profileSnapshot.data!),
                                    fit: BoxFit.cover
                                )
                            ),
                          ) :
                          SizedBox(
                            width: 35,
                            height: 35,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage("https://cdn-icons-png.freepik.com/512/8742/8742495.png"),
                            ),
                          );
                        }
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  )
                ],
                pinned: true, // App bar remains visible
                floating: true,
                forceElevated: innerBoxIsScrolled, // Adds shadow when scrolled
                bottom: TabBar( // Tabs remain at the bottom of the app bar
                  dividerColor: Colors.grey.shade50,
                  indicatorColor: colors.umber,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: colors.umber,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: TextStyle(fontFamily: "OpenSans", fontSize: 15,fontWeight: FontWeight.w700),
                  unselectedLabelStyle: TextStyle(fontFamily: "OpenSans", fontSize: 15,fontWeight: FontWeight.w500),
                  controller: _controller,
                  padding: EdgeInsets.zero,
                  tabs: [
                    Tab(text: 'Borrowed'),
                    Tab(text: 'Returned'),
                  ],
                ),
              ),
            ];
          },
          // Body content (e.g., TabBarView with ListViews)
          body: TabBarView(
            controller: _controller,
            children: [
              BorrowBooks(data: widget.borrowBooks),
              ReturnBooks(data: widget.returnBooks),
            ],
          )
        ),
      ),
    );
  }
  }