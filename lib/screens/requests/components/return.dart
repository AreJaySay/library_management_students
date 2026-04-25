import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:students/services/routes.dart';
import '../../../utils/palettes/app_colors.dart' hide Colors;
import '../../../widgets/cache_network_image.dart';
import '../../books/view_details.dart';

class ReturnBooks extends StatefulWidget {
  final List data;
  ReturnBooks({required this.data});
  @override
  State<ReturnBooks> createState() => _ReturnBooksState();
}

class _ReturnBooksState extends State<ReturnBooks> {
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
        Text("No return book found.",style: TextStyle(fontFamily: "OpenSans", color: Colors.grey),)
      ],
    ) : ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
      itemCount: widget.data.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: (){

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
                          Text(jsonDecode(widget.data[index]["book_information"])["title"],overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.w700,fontSize: 15,color: colors.umber),),
                          Text(jsonDecode(widget.data[index]["book_information"])["summary"],overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(fontFamily: "OpenSans",fontSize: 12,color: Colors.grey),),
                          Text(jsonDecode(widget.data[index]["book_information"])["author"].isEmpty ? "Anonymous" : jsonDecode(widget.data[index]["book_information"])["author"],style: TextStyle(fontFamily: "OpenSans"),),
                          Spacer(),
                          RichText(
                            text: TextSpan(
                              text: 'Returned date: ',
                              style: TextStyle(color: Colors.grey.shade600, fontFamily: "OpenSans"),
                              children: <TextSpan>[
                                TextSpan(
                                  text: DateFormat("yyyy-MM-dd").format(DateTime.parse(widget.data[index]["created_at"])),
                                  style: TextStyle(fontWeight: FontWeight.w600, color: colors.umber,fontFamily: "OpenSans"),
                                ),
                              ],
                            ),
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
