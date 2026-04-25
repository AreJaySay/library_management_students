import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:students/screens/books/view_details.dart';

import '../../services/routes.dart';

class SearchPage extends StatefulWidget {
  List books;
  SearchPage({required this.books});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final Routes _routes = new Routes();
  final TextEditingController _controller = new TextEditingController();
  String _value = "";
  List? _toSearch;

  @override
  void initState() {
    // TODO: implement initState
    _toSearch = widget.books;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.shade100,
        title: Text("Search Books",style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w500,fontSize: 20),),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onChanged: (v){
                setState(() {
                  _value = v;
                  widget.books = _toSearch!.where((s) =>
                      s["isbn"].toString().toLowerCase().contains(v.toLowerCase())  ||
                      s["title"].toString().toLowerCase().contains(v.toLowerCase())  ||
                      s["author"].toString().toLowerCase().contains(v.toLowerCase())  ||
                      s["summary"].toString().toLowerCase().contains(v.toLowerCase()) ||
                      s["year"].toString().toLowerCase().contains(v.toLowerCase())
                  ).toList();
                });
              },
              decoration: InputDecoration(
                hintText: "Search by title, author, published year etc ...",
                prefixIcon: Icon(Icons.search),
                suffixIcon: _value != ""
                    ? IconButton(
                  icon: Icon(Icons.close, color: Colors.grey,),
                  onPressed: () {
                    _controller.clear();
                    setState(() {
                      _value = "";
                      widget.books = _toSearch!;
                    });
                  },
                )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: widget.books.isEmpty ?
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.search,size: 50, color: Colors.grey,),
                  SizedBox(
                    height: 5,
                  ),
                  Text("No result found.",style: TextStyle(fontFamily: "OpenSans", color: Colors.grey),)
                ],
              ) :
              ListView(
                children: [
                  for(int x = 0; x < widget.books.length; x++)...{
                    GestureDetector(
                      onTap: (){
                        print(widget.books[x]);
                        // _routes.navigator_push(context, ViewDetails(type: "" ,details: widget.books[x]));
                      },
                      child: Container(
                        height: 100,
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)
                                  ),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: widget.books[x]["base64Image"] != "" ?
                                      MemoryImage(base64Decode(widget.books[x]["base64Image"])) :
                                      AssetImage("assets/icons/book.png")
                                  )
                              ),
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
                                    height: 5,
                                  ),
                                  Text("${widget.books[x]["title"]}",style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w600),),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text("${widget.books[x]["summary"]}",style: TextStyle(fontFamily: "OpenSans", color: Colors.grey),overflow: TextOverflow.ellipsis, maxLines: 2,),
                                  Spacer(),
                                  Row(
                                    children: [
                                      Text("Author:",style: TextStyle(fontFamily: "OpenSans", color: Colors.grey),),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("${widget.books[x]["author"]}",style: TextStyle(fontFamily: "OpenSans"),),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              )
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  }
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
