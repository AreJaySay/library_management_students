import 'dart:convert';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:students/screens/books/components/qr_code_scanner.dart';
import 'package:students/screens/books/search_page.dart';
import 'package:students/screens/books/view_details.dart';
import 'package:students/screens/notifications/notification.dart';
import 'package:students/services/routes.dart';
import 'package:students/services/streams/books_streams.dart';
import 'package:students/utils/palettes/app_colors.dart' hide Colors;
import 'package:students/widgets/cache_network_image.dart';

import '../../models/notifications.dart';
import '../../models/users.dart';
import '../profile/components/edit_profile.dart';
import '../profile/profile_page.dart';

class Books extends StatefulWidget {
  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {
  final _booksRef = FirebaseDatabase.instance.ref().child('books');
  final Routes _routes = new Routes();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.8;
    final double itemWidth = size.width / 2;
    return StreamBuilder(
        stream: _booksRef.onValue,
        builder: (context, snapshot) {
          List? _books;
          if(snapshot.hasData){
            if(snapshot.data!.snapshot.value != null){
              _books = (snapshot.data!.snapshot.value as Map).values.toList();
            }
          }

          return !snapshot.hasData ?
          Center(
            child: CircularProgressIndicator(color: colors.umber,),
          ) : Scaffold(
          backgroundColor: Colors.white,
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
            title: Text("Library Books",style: TextStyle(fontFamily: "OpenSans",fontSize: 19,fontWeight: FontWeight.bold),),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: (){
                  _routes.navigator_push(context, SearchPage(books: _books!,));
                },
              ),
              StreamBuilder(
                  stream: notificationModel.subject,
                  builder: (context, notificSnapshot) {
                    return !notificSnapshot.hasData ?
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: colors.umber, strokeWidth: 3,),
                    ) :
                    IconButton(
                      icon: Badge(
                        isLabelVisible: notificSnapshot.data!.where((s) => s["is_read"] == "0").toList().length != 0,
                        label: Text("${notificSnapshot.data!.where((s) => s["is_read"] == "0").toList().length}"),
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
          body: GridView.count(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            crossAxisCount: 3,
            childAspectRatio: (itemWidth / itemHeight),
            controller: new ScrollController(keepScrollOffset: false),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              for(int x = 0; x < _books!.length; x++)...{
                GestureDetector(
                  child: Banner(
                    message: _books[x]["stock"] == "0" ? "Not available" : "",
                    color: _books[x]["stock"] == "0" ? Colors.grey : Colors.transparent,
                    shadow: BoxShadow(
                        color: Colors.transparent
                    ),
                    location: BannerLocation.topEnd,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _books[x]["base64Image"] != "" ?
                          MemoryImage(base64Decode(_books[x]["base64Image"])) :
                          AssetImage("assets/icons/book.png")
                        )
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            )
                          ),
                          child: Text("${_books[x]["title"]}", maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,style: TextStyle(fontFamily: "OpenSans", color: Colors.white, fontSize: 13),),
                        ),
                      ),
                    ),
                  ),
                  onTap: (){
                    _routes.navigator_push(context, ViewDetails(type: "" ,details: _books![x]));
                  },
                )
              }
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _routes .navigator_push(context, QrCodeScanner(books: _books!,));
            },
            backgroundColor: Colors.white,
            shape: CircleBorder(),
            child: Icon(Icons.qr_code_scanner, color: colors.umber,),
          ),

          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      }
    );
  }
}
