import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/notifications.dart';
import '../../models/users.dart';
import '../../services/routes.dart';
import '../../utils/palettes/app_colors.dart' hide Colors;
import '../books/search_page.dart';
import '../notifications/notification.dart';
import '../profile/components/edit_profile.dart';
import '../profile/profile_page.dart';

class Logbooks extends StatefulWidget {
  @override
  State<Logbooks> createState() => _LogbooksState();
}

class _LogbooksState extends State<Logbooks> {
  final _logbooks = FirebaseDatabase.instance.ref().child('attendances');
  final Routes _routes = new Routes();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _logbooks.onValue,
        builder: (context, snapshot) {
          List? _attendances;
          if(snapshot.hasData){
            if(snapshot.data!.snapshot.value != null){
              _attendances = (snapshot.data!.snapshot.value as Map).values.toList().where((s) => s["school_id"] == usersModel.loggedUser.value["school_id"]).toList();
              _attendances.sort((a,b) {
                return DateTime.parse(a["date_time"]).compareTo(DateTime.parse(b["date_time"]));
              });
            }
          }
          return !snapshot.hasData ?
          Center(
            child: CircularProgressIndicator(color: colors.umber,),
          ) : Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 1,
            shadowColor: Colors.grey.shade50,
            leading: Center(
              child: SizedBox(
                width: 35,
                height: 35,
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/logos/ssu_logo.png"),
                ),
              ),
            ),
            title: Text("Logbooks",style: TextStyle(fontFamily: "OpenSans",fontSize: 19,fontWeight: FontWeight.bold),),
            actions: [
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
          ),
          body: _attendances!.isEmpty ?
          Center(
            child: Text("NO DATA FOUND"),
          ) :
          ListView.builder(
                itemCount: _attendances!.length,
                padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 20),
                itemBuilder: (context, index){
                  return Container(
                    width: double.infinity,
                    height: 70,
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Container(
                          height: 70,
                          width: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10)
                            ),
                            color: Color.fromARGB(
                              255,
                              Random().nextInt(256),
                              Random().nextInt(256),
                              Random().nextInt(256),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Container(
                              width: double.infinity,
                                padding: EdgeInsetsGeometry.symmetric(horizontal: 15,vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Logged Time",style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w600),),
                                        Text("${DateFormat.yMMMd().format(DateTime.parse(_attendances![_attendances.length - 1 - index]["date_time"]))}",style: TextStyle(color: Colors.grey.shade700),)
                                      ],
                                    ),
                                    Spacer(),
                                    Text("${DateFormat("h:mm a").format(DateTime.parse(_attendances[_attendances.length - 1 - index]["date_time"]))}",style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w800, fontSize: 15),)
                                  ],
                                )
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              )
        );
      }
    );
  }
}
