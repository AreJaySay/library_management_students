import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:students/services/routes.dart';

import '../../../utils/palettes/app_colors.dart' hide Colors;
import '../../../widgets/cache_network_image.dart';
import '../../books/view_details.dart';

class BorrowBooks extends StatefulWidget {
  final List data;
  BorrowBooks({required this.data});
  @override
  State<BorrowBooks> createState() => _BorrowBooksState();
}

class _BorrowBooksState extends State<BorrowBooks> {
  final Routes _routes = new Routes();

  @override
  Widget build(BuildContext context) {
    return widget.data.isEmpty ?
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.search,size: 50, color: Colors.grey,),
        SizedBox(
          height: 5,
        ),
        Text("No borrow book found.",style: TextStyle(fontFamily: "OpenSans", color: Colors.grey),)
      ],
    ) :
    ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
      itemCount: widget.data.length,
      itemBuilder: (context, index) {
        // Date duration
        int _duration = DateTime.parse(widget.data[index]["borrow_details"]["end_date"]).difference(DateTime.now()).inDays;

        return GestureDetector(
            onTap: (){
              _routes.navigator_push(context, ViewDetails(type: "borrowing" ,details: jsonDecode(widget.data[index]["book_information"]), daysPenalty: _duration > 0 ? 0 : _duration,));
            },
            child: Card(
              color: Colors.white30,
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
                    jsonDecode(widget.data[index]["book_information"])["base64Image"] != "" ?
                    Image.memory(
                      base64Decode(jsonDecode(widget.data[index]["book_information"])["base64Image"]),
                      width: 35,
                      height: 55,
                      fit: BoxFit.fill,
                    ) :
                    Image(
                      image: AssetImage("assets/icons/book.png"),
                      width: 50,
                      height: 50,
                      color: Colors.grey.shade400,
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
                            Text(jsonDecode(widget.data[index]["book_information"])["title"],overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.w700,fontSize: 15,color: colors.umber),),
                            SizedBox(
                              height: 5,
                            ),
                            Text(jsonDecode(widget.data[index]["book_information"])["author"].isEmpty ? "Anonymous" : jsonDecode(widget.data[index]["book_information"])["author"],style: TextStyle(fontFamily: "OpenSans"),),
                            Spacer(),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: 'Borrowed at: ',
                                          style: TextStyle(color: Colors.grey.shade600, fontFamily: "OpenSans"),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: DateFormat("yyyy-MM-dd").format(DateTime.parse(widget.data[index]["borrow_details"]["borrow_date"])),
                                              style: TextStyle(fontWeight: FontWeight.w600, color: colors.umber,fontFamily: "OpenSans"),
                                            ),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Return at: ',
                                          style: TextStyle(color: Colors.grey.shade600, fontFamily: "OpenSans"),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: DateFormat("yyyy-MM-dd").format(DateTime.parse(widget.data[index]["borrow_details"]["end_date"])),
                                              style: TextStyle(fontWeight: FontWeight.w600, color: colors.umber,fontFamily: "OpenSans"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _duration == 0 ?
                                Text("Due is today",style: TextStyle(fontFamily: "OpenSans", color: Colors.red.shade400,fontSize: 12.5),textAlign: TextAlign.end,) :
                                _duration > 0 ?
                                Text("$_duration days \nbefore due date",style: TextStyle(fontFamily: "OpenSans", color: Colors.grey.shade400,fontSize: 12.5),textAlign: TextAlign.end,) :
                                Text("${_duration.abs()} days \noverdue",style: TextStyle(fontFamily: "OpenSans", color: Colors.red.shade200,fontSize: 12.5),textAlign: TextAlign.end,)
                              ],
                            ),
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
    );
  }
}
