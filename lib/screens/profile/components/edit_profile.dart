import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:students/credentials/login.dart';
import 'package:students/models/users.dart';
import 'package:students/services/apis/users.dart';
import 'package:students/services/routes.dart';
import 'package:students/utils/palettes/app_colors.dart' hide Colors;
import 'package:students/widgets/button.dart';

import '../../../functions/loaders.dart';
import '../../../utils/snackbars/snackbar_message.dart';

class EditProfile extends StatefulWidget {
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  final Routes _routes = new Routes();
  final UsersApi _usersApi = new UsersApi();
  final Materialbutton _materialbutton = new Materialbutton();
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _schoolid = TextEditingController();
  String _base64 = "";
  String _department = "";
  String _course = "";
  String _year = "";
  String _section = "";
  List? _filters;

  @override
  void initState() {
    super.initState();
    _loadJson();
    _name.text = usersModel.loggedUser.value["name"];
    _age.text = usersModel.loggedUser.value["age"];
    _email.text = usersModel.loggedUser.value["email"];
    _schoolid.text = usersModel.loggedUser.value["school_id"];
    _department = usersModel.loggedUser.value["department"] ?? "";
    _course = usersModel.loggedUser.value["course"] ?? "";
    _year = usersModel.loggedUser.value["year"] ?? "";
    _section = usersModel.loggedUser.value["section"] ?? "";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.grey.shade300,
        elevation: 1,
        centerTitle: true,
        title: Text("Profile",style: TextStyle(fontFamily: "OpenSans", fontSize: 18, fontWeight: FontWeight.w600),),
      ),
      body: StreamBuilder(
          stream: usersModel.loggedUser,
          builder: (context, snapshot) {
            return !snapshot.hasData ?
            Center(
              child: CircularProgressIndicator(),
            ) :
            Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 25, horizontal: 20),
              child: Column(
                children: [
                  StreamBuilder(
                      stream: uploadPict.subject,
                      builder: (context, profileSnapshot) {
                        return Center(
                          child: CircleAvatar(
                              minRadius: 45,
                              maxRadius: 65,
                              child: !profileSnapshot.hasData ?
                              CircularProgressIndicator() :
                              Stack(
                                children: [
                                  Center(
                                    child:  profileSnapshot.data!.isNotEmpty ?
                                    Container(
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
                                      child: CircleAvatar(
                                        minRadius: 45,
                                        maxRadius: 65,
                                        backgroundImage: NetworkImage("https://cdn-icons-png.freepik.com/512/8742/8742495.png"),
                                      ),
                                    ),
                                  ),
                                  Align(
                                      alignment: Alignment.bottomRight,
                                      child: GestureDetector(
                                        onTap: () async{
                                          _convertBase64();
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.grey.shade200,
                                          child: Icon(Icons.edit,color: colors.umber,),
                                        ),
                                      )
                                  ),
                                ],
                              )
                          ),
                        );
                      }
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _name,
                    style: TextStyle(fontFamily: "OpenSans"),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                      hintText: 'Name',
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
                    controller: _age,
                    style: TextStyle(fontFamily: "OpenSans"),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                      hintText: 'Age',
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
                  TextField(
                    controller: _schoolid,
                    style: TextStyle(fontFamily: "OpenSans"),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                      hintText: 'School ID',
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
                        if(_course.isNotEmpty)...{
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
                  Row(
                    children: [
                      Expanded(
                        child: Container(
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
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
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
                              'A',
                              'B',
                              'C',
                              'D',
                              'E',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style: TextStyle(fontFamily: "OpenSans",fontSize: 15),),
                              );
                            }).toList(),
                            hint: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(_section.isEmpty
                                  ? 'Section'
                                  : _section,style: TextStyle(fontFamily: "OpenSans",fontSize: 16,color: _department.isEmpty ? Colors.grey : Colors.black),),
                            ),
                            borderRadius: BorderRadius.circular(10),
                            underline: SizedBox(),
                            isExpanded: true,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _section = value;
                                });
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  _materialbutton.materialButton("Update", ()async{
                    Map _payload = {
                      "name": _name.text,
                      "age": _age.text,
                      "email": _email.text,
                      "school_id": _schoolid.text,
                      "department": _department,
                      "course": _course,
                      "year": _year,
                      "section": _section,
                      "base64Image": _base64,
                    };
                    _screenLoaders.functionLoader(context);
                    _usersApi.edit(id: usersModel.loggedUser.value["id"], payload: _payload).whenComplete((){
                      Navigator.of(context).pop(null);
                      Navigator.of(context).pop(null);
                      _snackbarMessage  .snackbarMessage(context, message: "Successfully updated!");
                    });
                    print(usersModel.loggedUser.value);
                  }, backColor: colors.umber),
                  SizedBox(
                    height: 25,
                  )
                ],
              ),
            );
          }
      ),
    );
  }
  Future<String?> _convertBase64() async {
    try{
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        withData: true,
      );
      if (result != null) {
        Uint8List? fileBytes = result.files.first.bytes;
        print("3434343434343434  ${fileBytes}");
        if (fileBytes != null) {
          setState(() {
            _base64 = base64Encode(fileBytes);
            uploadPict.update(data: result.files.first.bytes!);
          });
        }
      }
    }catch(e){
      print("1212121 $e");
    }

    return null;
  }

  Future<void> _loadJson() async {
    final String response = await rootBundle.loadString('assets/jsons/filter_students.json');
    final data = json.decode(response);
    setState(() {
      _filters = data;
    });
    print("FILTERS $data");
  }
}

class UploadPict{
  BehaviorSubject<Uint8List> subject = new BehaviorSubject();
  Stream get stream => subject.stream;
  Uint8List get current => subject.value;

  update({required Uint8List data}){
    subject.add(data);
  }
}
final UploadPict uploadPict = new UploadPict();
