import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:students/functions/loaders.dart';
import 'package:students/models/borrows.dart';
import 'package:students/models/reservations.dart';
import 'package:students/models/users.dart';
import 'package:students/screens/books/components/reservation_form.dart';
import 'package:students/services/routes.dart';
import 'package:students/utils/palettes/app_colors.dart' hide Colors;
import 'package:students/utils/snackbars/snackbar_message.dart';
import 'package:students/widgets/button.dart';

class ViewDetails extends StatefulWidget {
  final String type;
  final Map details;
  final int daysPenalty;
  ViewDetails({required this.type,required this.details, this.daysPenalty = 0});
  @override
  State<ViewDetails> createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  final Routes _routes = new Routes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Book Details",style: TextStyle(fontFamily: "OpenSans",fontSize: 19, fontWeight: FontWeight.w600),),
        centerTitle: true,
        shadowColor: Colors.grey.shade100,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_outlined),
            onPressed: (){},
          )
        ],
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Stack(
                children: [
                  widget.details["base64Image"] != "" ?
                  Image.memory(
                    base64Decode(widget.details["base64Image"]),
                    height: 280,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ) :
                  Image(
                    image: AssetImage("assets/icons/book.png"),
                    height: 280,
                    width: double.infinity,
                    color: Colors.grey.shade400,
                  ),
                  Container(
                    width: double.infinity,
                    height: 300,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)
                                )
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 220,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                border: Border.all(color: colors.umber.withOpacity(0.1)),
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: widget.details["base64Image"] != "" ?
                                    MemoryImage(base64Decode(widget.details["base64Image"])) :
                                    AssetImage("assets/icons/book.png")
                                )
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Text(widget.details["title"],style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.w700,fontSize: 16,color: colors.umber),textAlign: TextAlign.center,)),
                    SizedBox(
                      height: 5,
                    ),
                    Center(child: Text("by: ${widget.details["author"]}",style: TextStyle(fontFamily: "OpenSans",fontSize: 15),textAlign: TextAlign.center,)),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(color: colors.umber.withOpacity(0.03),),
                    SizedBox(
                      height: 10,
                    ),
                    // Wrap(
                    //   spacing: 5,
                    //   alignment: WrapAlignment.center,
                    //   children: [
                    //     for(int x = 0; x < widget.details["bookshelves"].length; x++)...{
                    //       FilterChip(
                    //         label: Text("${widget.details["bookshelves"][x]}"),
                    //         labelStyle: TextStyle(fontFamily: "OpenSans"),
                    //         backgroundColor: Colors.white,
                    //         shape: StadiumBorder(side: BorderSide(color: colors.umber.withOpacity(0.1))),
                    //         onSelected: (bool value) {
                    //           print("selected");
                    //         },
                    //       ),
                    //     },
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    Text("Summary:",style: TextStyle(fontFamily: "OpenSans",fontSize: 15,fontWeight: FontWeight.w500),),
                    SizedBox(
                      height: 5,
                    ),
                    Text("${widget.details["summary"]}",style: TextStyle(fontFamily: "OpenSans",color: Colors.grey.shade900),),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(color: colors.umber.withOpacity(0.03),),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Stocks:",style: TextStyle(fontFamily: "OpenSans",fontSize: 15,fontWeight: FontWeight.w500),),
                    SizedBox(
                      height: 5,
                    ),
                    Text("${widget.details["stock"]} Available",style: TextStyle(fontFamily: "OpenSans",color: Colors.grey.shade900),),
                  ],
                ),
              ),
              SizedBox(
                height: 120,
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 90,
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 5.0, // has the effect of softening the shadow
                    spreadRadius: 0.0, // has the effect of extending the shadow
                    offset: Offset(
                      0.0, // horizontal, move right 10
                      0.0, // vertical, move down 10
                    ),
                  )
                ],
              ),
              child: SafeArea(
                child: Center(
                  child: SizedBox(
                    height: 55,
                    child: Row(
                      children: [
                        StreamBuilder(
                            stream: reservationsModel.reservation,
                            builder: (context, snapshot) {
                              bool _ifReserved = false;
                              if(snapshot.hasData){
                                if(snapshot.data!.isNotEmpty){
                                  List _res = snapshot.data!.where((s) => jsonDecode(s["book_information"])["title"] == widget.details["title"]).toList();
                                  if(_res.isNotEmpty){
                                    print("RESEVE ${_res}");
                                    _ifReserved = _res.first["borrower"]["school_id"] == usersModel.loggedUser.value["school_id"];
                                  }
                                }
                              }

                              return Expanded(
                                  child: !snapshot.hasData ?
                                  IgnorePointer(
                                    ignoring: true,
                                    child: MaterialButton(
                                      height: 55,
                                      color: Colors.grey.shade300,
                                      child: Center(
                                          child: SizedBox(
                                            width: 25,
                                            height: 25,
                                            child: CircularProgressIndicator(strokeWidth: 3, color: colors.umber,),
                                          )
                                      ),
                                      onPressed: (){},
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(1000),
                                      ),
                                    ),
                                  ) :
                                  IgnorePointer(
                                    ignoring: _ifReserved,
                                    child: materialbutton.materialButton(backColor: _ifReserved ? colors.umber.withOpacity(0.3) : colors.umber,textColor: Colors.white, _ifReserved ? "Reserved" : "Reserve", () async{
                                      if(!_ifReserved){
                                        _routes.navigator_push(context, ReservationForm(details: widget.details, isReserved: true,), transitionType: PageTransitionType.bottomToTop);
                                      }
                                    }),
                                  )
                              );
                            }
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        StreamBuilder(
                            stream: borrowsModel.subject,
                            builder: (context, snapshot) {
                              bool _ifBorrowed = false;
                              if(snapshot.hasData){
                                if(snapshot.data!.isNotEmpty){
                                  List _res = snapshot.data!.where((s) => jsonDecode(s["book_information"])["title"] == widget.details["title"]).toList();
                                  if(_res.isNotEmpty){
                                    _ifBorrowed = _res.first["borrower"]["school_id"] == usersModel.loggedUser.value["school_id"] && _res.first["status"] != "Returned";
                                  }
                                }
                              }

                              return Expanded(
                                  child: !snapshot.hasData ?
                                  IgnorePointer(
                                    ignoring: true,
                                    child: MaterialButton(
                                      height: 55,
                                      color: Colors.grey.shade300,
                                      child: Center(
                                          child: SizedBox(
                                            width: 25,
                                            height: 25,
                                            child: CircularProgressIndicator(strokeWidth: 3, color: colors.umber,),
                                          )
                                      ),
                                      onPressed: (){},
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(1000),
                                      ),
                                    ),
                                  ) :
                                  IgnorePointer(
                                    ignoring: _ifBorrowed,
                                    child: materialbutton.materialButton(backColor: Colors.white,textColor: _ifBorrowed ? Colors.grey : colors.umber, _ifBorrowed ? "Borrowed" : "Borrow", () async{
                                      if(!_ifBorrowed){
                                        _routes.navigator_push(context, ReservationForm(details: widget.details, isReserved: false,), transitionType: PageTransitionType.bottomToTop);
                                      }
                                    }),
                                  )
                              );
                            }
                        ),
                        SizedBox(
                          width: 10,
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget _dueDatePopup(){
    return Container(
      height: 310,
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: (){
                Navigator.of(context).pop(null);
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade50
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Note:",style: TextStyle(fontFamily: "OpenSans",color: Colors.black54),),
                Text("Please return the book early before its due date, to avoid paying its penalty!",style: TextStyle(fontFamily: "OpenSans",color: Colors.black45),),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      Text("Penalty per day:",style: TextStyle(fontSize: 12,color: Colors.grey.shade600,fontFamily: "OpenSans"),),
                      Text("P10,00",style: TextStyle(fontFamily: "OpenSans",fontSize: 35,fontWeight: FontWeight.w600,color: Colors.grey),)
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
              ),
              SizedBox(
                height: 80,
                child: VerticalDivider(color: Colors.grey.shade100,),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Current due date:",style: TextStyle(fontSize: 12,color: Colors.grey.shade600,fontFamily: "OpenSans"),),
                      Text("P${(10 * widget.daysPenalty).abs()},00",style: TextStyle(fontFamily: "OpenSans",fontSize: 30,fontWeight: FontWeight.w600,color: widget.daysPenalty == 0 ? colors.umber : Colors.redAccent),)
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
