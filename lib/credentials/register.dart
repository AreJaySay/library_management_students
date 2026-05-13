import 'dart:convert';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:students/credentials/login.dart';
import 'package:students/functions/loaders.dart';
import 'package:students/utils/snackbars/snackbar_message.dart';

import '../services/routes.dart';
import '../utils/palettes/app_colors.dart' hide Colors;
import '../widgets/button.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  final Routes _routes = new Routes();
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  final TextEditingController _fname = TextEditingController();
  final TextEditingController _lname = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  String _year = "";
  String _course = "";
  String _department = "";
  bool _isPassVisible = false;
  bool _isConfirmPassVisible = false;
  List? _filters;

  @override
  void initState() {
    // TODO: implement initState
    _loadJson();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _fname.dispose();
    _lname.dispose();
    _phone.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        children: [
          SizedBox(
            height: 70,
          ),
          Center(child: Text("Create Account",style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.bold, fontSize: 25),)),
          Center(child: Text("Create an account so you can explore library available books you can borrow ",style: TextStyle(fontFamily: "OpenSans"),textAlign: TextAlign.center,)),
          SizedBox(
            height: 50,
          ),
          TextField(
            controller: _fname  ,
            style: TextStyle(fontFamily: "OpenSans"),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
              hintText: 'Firstname',
              hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1000)
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1000),
                borderSide: BorderSide(color: colors.umber.withOpacity(0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1000),
                borderSide: BorderSide(color: colors.umber.withOpacity(0.4)),
              ),
            ),
            onChanged: (text) {

            },
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: _lname  ,
            style: TextStyle(fontFamily: "OpenSans"),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
              hintText: 'Lastname',
              hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1000)
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1000),
                borderSide: BorderSide(color: colors.umber.withOpacity(0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1000),
                borderSide: BorderSide(color: colors.umber.withOpacity(0.4)),
              ),
            ),
            onChanged: (text) {

            },
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: _phone  ,
            style: TextStyle(fontFamily: "OpenSans"),
            keyboardType: TextInputType.number,
            maxLength: 11,
            decoration: InputDecoration(
              counterText: "",
              contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
              hintText: 'Phone',
              hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1000)
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1000),
                borderSide: BorderSide(color: colors.umber.withOpacity(0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1000),
                borderSide: BorderSide(color: colors.umber.withOpacity(0.4)),
              ),
            ),
            onChanged: (text) {

            },
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: _email,
            style: TextStyle(fontFamily: "OpenSans"),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
              hintText: 'Email',
              hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1000)
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1000),
                borderSide: BorderSide(color: colors.umber.withOpacity(0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1000),
                borderSide: BorderSide(color: colors.umber.withOpacity(0.4)),
              ),
            ),
            onChanged: (text) {

            },
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.0, style: BorderStyle.solid, color: colors.umber.withOpacity(0.1)),
                borderRadius: BorderRadius.all(Radius.circular(1000)),
              ),
            ),
            child: DropdownButton<String>(
              focusColor: Colors.white,
              style: TextStyle(fontFamily: "OpenSans",fontSize: 16,color: Colors.black),
              padding: EdgeInsets.symmetric(horizontal: 10),
              items: <String>[
                '1st year',
                '2nd year',
                '3rd year',
                '4th year'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
                );
              }).toList(),
              hint: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(_year.isEmpty
                    ? 'Year'
                    : _year,style: TextStyle(fontFamily: "OpenSans",fontSize: 16,color: _department.isEmpty ? Colors.grey : Colors.black),),
              ),
              borderRadius: BorderRadius.circular(10),
              underline: SizedBox(),
              isExpanded: true,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _year = value;
                  });
                }
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.0, style: BorderStyle.solid, color: colors.umber.withOpacity(0.1)),
                borderRadius: BorderRadius.all(Radius.circular(1000)),
              ),
            ),
            child: DropdownButton<String>(
              focusColor: Colors.white,
              style: TextStyle(fontFamily: "OpenSans",fontSize: 16,color: Colors.black),
              padding: EdgeInsets.symmetric(horizontal: 10),
              items: <String>[
                for(int x = 0; x < _filters!.length; x++)...{
                  "${_filters![x]["department"]}"
                }
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
                );
              }).toList(),
              hint: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(_department.isEmpty
                    ? 'Department'
                    : _department,style: TextStyle(fontFamily: "OpenSans",fontSize: 16,color: _department.isEmpty ? Colors.grey : Colors.black),),
              ),
              borderRadius: BorderRadius.circular(10),
              underline: SizedBox(),
              isExpanded: true,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _department = value;
                  });
                }
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.0, style: BorderStyle.solid, color: colors.umber.withOpacity(0.1)),
                borderRadius: BorderRadius.all(Radius.circular(1000)),
              ),
            ),
            child: DropdownButton<String>(
              focusColor: Colors.white,
              style: TextStyle(fontFamily: "OpenSans",fontSize: 16,color: Colors.black),
              padding: EdgeInsets.symmetric(horizontal: 10),
              items: <String>[
                if(_department.isNotEmpty)...{
                  for(int x = 0; x < _filters!.where((s) => s["department"] == _department).toList().first["courses"].length; x++)...{
                    "${_filters!.where((s) => s["department"] == _department).toList().first["courses"][x]}"
                  }
                }
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
                );
              }).toList(),
              hint: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(_course.isEmpty
                    ? 'Course'
                    : _course,style: TextStyle(fontFamily: "OpenSans",fontSize: 16,color: _course.isEmpty ? Colors.grey : Colors.black),),
              ),
              borderRadius: BorderRadius.circular(10),
              underline: SizedBox(),
              isExpanded: true,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _course = value;
                  });
                }
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: _pass,
            style: TextStyle(fontFamily: "OpenSans"),
            keyboardType: TextInputType.text,
            obscureText: !_isPassVisible,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                hintText: 'Password',
                hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(1000)
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1000),
                  borderSide: BorderSide(color: colors.umber.withOpacity(0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1000),
                  borderSide: BorderSide(color: colors.umber.withOpacity(0.4)),
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: IconButton(
                    icon: _isPassVisible ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                    onPressed: (){
                      setState(() {
                        _isPassVisible = !_isPassVisible;
                      });
                    },
                  ),
                )
            ),
            onChanged: (text) {

            },
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: _confirmPass,
            style: TextStyle(fontFamily: "OpenSans"),
            keyboardType: TextInputType.text,
            obscureText: !_isConfirmPassVisible,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                hintText: 'Confirm Password',
                hintStyle: TextStyle(fontFamily: "OpenSans",color: Colors.grey),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(1000)
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1000),
                  borderSide: BorderSide(color: colors.umber.withOpacity(0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1000),
                  borderSide: BorderSide(color: colors.umber.withOpacity(0.4)),
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: IconButton(
                    icon: _isConfirmPassVisible ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                    onPressed: (){
                      setState(() {
                        _isConfirmPassVisible = !_isConfirmPassVisible;
                      });
                    },
                  ),
                )
            ),
            onChanged: (text) {

            },
          ),
          SizedBox(
            height: 50,
          ),
          materialbutton.materialButton(fontsize: 15,backColor: _fname.text.isEmpty || _lname.text.isEmpty || _phone.text.isEmpty || _email.text.isEmpty || _year == "" || _department == "" || _course == "" || _pass.text.isEmpty || _confirmPass.text.isEmpty ? Colors.grey : colors.umber,"REGISTER", (){
            if(_fname.text.isEmpty || _lname.text.isEmpty || _phone.text.isEmpty || _email.text.isEmpty || _year == "" || _department == "" || _course == "" || _pass.text.isEmpty || _confirmPass.text.isEmpty){
              _snackbarMessage.snackbarMessage(context, message: "All fields are required.", is_error: true);
            }else if(_pass.text != _confirmPass.text){
              _snackbarMessage.snackbarMessage(context, message: "Password and confirm password did not match.", is_error: true);
            }else{
              _screenLoaders.functionLoader(context);
              _register().whenComplete((){
                Navigator.of(context).pop(null);
                _snackbarMessage.snackbarMessage(context, message: "New account successfully created!");
                _routes.navigator_push(context, Login(), transitionType: PageTransitionType.leftToRightWithFade);
              });
            }
          }),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Already have an account?",style: TextStyle(color: Colors.black,fontFamily: "OpenSans"),),
              InkWell(
                onTap: (){
                  _routes.navigator_push(context, Login(), transitionType: PageTransitionType.leftToRightWithFade);
                },
                child: Text(" LOGIN",style: TextStyle(color: colors.umber,fontWeight: FontWeight.bold,fontFamily: "OpenSans"),),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<void> _loadJson() async {
    final String response = await rootBundle.loadString('assets/jsons/filter_students.json');
    final data = json.decode(response);
    setState(() {
      _filters = data;
    });
    print("FILTERS $data");
  }

  Future _register()async{
    DatabaseReference usersRef = database.ref('users');
    await usersRef.push().set({
      "id": "${10000 + Random().nextInt(90000)}",
      "firstname": _fname.text,
      "lastname": _lname.text,
      "phone": _phone.text,
      "email": _email.text,
      "year": _year,
      "department": _department,
      "course": _course,
      "base64Image": "",
      "password": _pass.text,
      "created_at": "${DateTime.now()}"
    });
  }
}

