import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:students/credentials/login.dart';
import 'package:students/models/users.dart';
import 'package:students/services/apis/users.dart';
import 'package:students/services/routes.dart';
import 'package:students/utils/palettes/app_colors.dart' hide Colors;
import 'package:students/widgets/button.dart';
import '../../../functions/loaders.dart';
import '../../../utils/snackbars/snackbar_message.dart';

class ChangePassword extends StatefulWidget {
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final UsersApi _usersApi = new UsersApi();
  final Materialbutton _materialbutton = new Materialbutton();
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  final TextEditingController _old = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  bool _isOldPassVisible = false;
  bool _isPassVisible = false;
  bool _isConfirmPassVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.grey.shade300,
        elevation: 1,
        centerTitle: true,
        title: Text("Change Password",style: TextStyle(fontFamily: "OpenSans", fontSize: 18, fontWeight: FontWeight.w600),),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            TextField(
              controller: _old,
              style: TextStyle(fontFamily: "OpenSans"),
              keyboardType: TextInputType.text,
              obscureText: !_isOldPassVisible,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                  hintText: 'Old Password',
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
                      icon: _isOldPassVisible ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                      onPressed: (){
                        setState(() {
                          _isOldPassVisible = !_isOldPassVisible;
                        });
                      },
                    ),
                  )
              ),
              onChanged: (text) {

              },
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: _pass,
              style: TextStyle(fontFamily: "OpenSans"),
              keyboardType: TextInputType.text,
              obscureText: !_isPassVisible,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                  hintText: 'New Password',
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
              height: 15,
            ),
            TextField(
              controller: _confirmPass,
              style: TextStyle(fontFamily: "OpenSans"),
              keyboardType: TextInputType.text,
              obscureText: !_isConfirmPassVisible,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                  hintText: 'Confirm New Password',
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
            _materialbutton.materialButton("Save", ()async{
              if(_old.text.isEmpty || _pass.text.isEmpty || _confirmPass.text.isEmpty){
                _snackbarMessage.snackbarMessage(context, message: "All fields are required.", is_error: true);
              }else if(_old.text != usersModel.valueLogged["password"]){
                _snackbarMessage.snackbarMessage(context, message: "Old password did not match!.", is_error: true);
              }else if(_old.text == _pass.text){
                _snackbarMessage.snackbarMessage(context, message: "New password must be different from previous one!", is_error: true);
              }else{
                _screenLoaders.functionLoader(context);
                _usersApi.changePassword(id: usersModel.loggedUser.value["id"], password: _pass.text).whenComplete((){
                  Navigator.of(context).pop(null);
                  Navigator.of(context).pop(null);
                  _snackbarMessage  .snackbarMessage(context, message: "Successfully updated!");
                });
                print(usersModel.loggedUser.value);
              }
            }, backColor: colors.umber),
          ],
        ),
      ),
    );
  }
}
