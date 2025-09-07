import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:students/screens/books/components/borrow_form.dart';
import 'package:students/services/routes.dart';
import 'package:students/utils/palettes/app_colors.dart' hide Colors;
import 'package:students/widgets/button.dart';

class ViewDetails extends StatefulWidget {
  final Map details;
  ViewDetails({required this.details});
  @override
  State<ViewDetails> createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
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
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Stack(
                children: [
                  Image(
                    height: 280,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                    image: NetworkImage(widget.details["formats"]["image/jpeg"]),
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
                                  fit: BoxFit.fill,
                                  image: NetworkImage(widget.details["formats"]["image/jpeg"]),
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
                      height: 10,
                    ),
                    Center(child: Text(widget.details["authors"].first["name"],style: TextStyle(fontFamily: "OpenSans",fontSize: 15),textAlign: TextAlign.center,)),
                    SizedBox(
                      height: 5,
                    ),
                    Center(child: Text("${widget.details["authors"].first["birth_year"]} - ${widget.details["authors"].first["death_year"]}",style: TextStyle(fontFamily: "OpenSans",color: Colors.grey),textAlign: TextAlign.center,)),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(color: colors.umber.withOpacity(0.05),),
                    SizedBox(
                      height: 5,
                    ),
                    Wrap(
                      runSpacing: 3,
                      spacing: 5,
                      alignment: WrapAlignment.center,
                      children: [
                        for(int x = 0; x < widget.details["bookshelves"].length; x++)...{
                          FilterChip(
                            label: Text("${widget.details["bookshelves"][x]}"),
                            labelStyle: TextStyle(fontFamily: "OpenSans"),
                            backgroundColor: Colors.white,
                            shape: StadiumBorder(side: BorderSide(color: colors.umber.withOpacity(0.1))),
                            onSelected: (bool value) {
                              print("selected");
                            },
                          ),
                        },
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(color: colors.umber.withOpacity(0.05),),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Summary:",style: TextStyle(fontFamily: "OpenSans",fontSize: 15,fontWeight: FontWeight.w500),),
                    SizedBox(
                      height: 5,
                    ),
                    Text("${widget.details["summaries"].first}",style: TextStyle(fontFamily: "OpenSans",color: Colors.grey.shade900),),
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
                        Expanded(
                          child: materialbutton.materialButton(backColor: Colors.white,textColor: colors.umber,"Add to favorite", (){
                
                          }),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: materialbutton.materialButton(backColor: colors.umber,textColor: Colors.white,"Borrow", (){
                            _routes.navigator_push(context, BorrowForm(details: widget.details,), transitionType: PageTransitionType.bottomToTop);
                          }),
                        )
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
}
