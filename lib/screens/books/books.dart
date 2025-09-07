import 'dart:math';

import 'package:flutter/material.dart';
import 'package:students/screens/books/view_details.dart';
import 'package:students/services/routes.dart';
import 'package:students/services/streams/books_streams.dart';
import 'package:students/utils/palettes/app_colors.dart' hide Colors;
import 'package:students/widgets/cache_network_image.dart';

class Books extends StatefulWidget {
  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {
  final Routes _routes = new Routes();

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // Adjust chunk size as needed
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: booksStreams.subject,
      builder: (context, snapshot) {
        return Scaffold(
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
                  backgroundImage: AssetImage("assets/logos/main_logo.png"),
                ),
              ),
            ),
            title: Text("Library Books",style: TextStyle(fontFamily: "OpenSans",fontSize: 19,fontWeight: FontWeight.bold),),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: (){},
              ),
              SizedBox(
                width: 35,
                height: 35,
                child: CircleAvatar(
                  backgroundImage: NetworkImage("https://img.freepik.com/free-photo/portrait-delighted-hipster-male-student-with-crisp-hair_176532-8157.jpg?semt=ais_hybrid&w=740&q=80"),
                ),
              ),
              SizedBox(
                width: 20,
              )
            ],
          ),
          body: !snapshot.hasData ?
          Center(
            child: CircularProgressIndicator(color: colors.umber,),
          ) :
          ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            itemCount: snapshot.data!.length, // Number of items in your list
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  _routes.navigator_push(context, ViewDetails(details: snapshot.data![index]));
                },
                child: Card(
                  color: colors.umber.withOpacity(0.03),
                  margin: EdgeInsets.only(bottom: 10),
                  elevation: 0,
                  shadowColor: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.0, style: BorderStyle.solid, color: colors.umber.withOpacity(0.08)),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        cacheNetworkImages.cacheNetwork(
                          width: 70,
                          height: 100,
                          url: snapshot.data![index]["formats"]["image/jpeg"]
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(snapshot.data![index]["title"],overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.w700,fontSize: 15,color: colors.umber),),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(snapshot.data![index]["authors"].first["name"],style: TextStyle(fontFamily: "OpenSans"),),
                                Spacer(),
                                Text('${Random().nextInt(100)} Available',style: TextStyle(fontFamily: "OpenSans",color: Colors.grey.shade600),),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        );
      }
    );
  }
}
