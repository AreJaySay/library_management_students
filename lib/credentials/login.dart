import 'package:flutter/material.dart';
import 'package:students/credentials/register.dart';
import 'package:students/functions/loaders.dart';
import 'package:students/models/users.dart';
import 'package:students/screens/landing.dart';
import 'package:students/services/apis/users.dart';
import 'package:students/services/routes.dart';
import 'package:students/utils/snackbars/snackbar_message.dart';
import 'package:students/widgets/button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/palettes/app_colors.dart' hide Colors;

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  final Routes _routes = new Routes();
  final UsersApi _usersApi = new UsersApi();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _pass = new TextEditingController();
  bool _isPassVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    _usersApi.getUsers();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              width: 250,
              height: 250,
              image: AssetImage("assets/logos/main_logo.png"),
            ),
           Column(
             children: [
               TextField(
                 controller: _email,
                 style: TextStyle(fontFamily: "OpenSans"),
                 keyboardType: TextInputType.text,
                 decoration: InputDecoration(
                   hintText: 'Email',
                   prefixIcon: Icon(Icons.person,color: colors.umber,),
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
                 height: 15,
               ),
               TextField(
                 controller: _pass,
                 style: TextStyle(fontFamily: "OpenSans"),
                 keyboardType: TextInputType.text,
                 obscureText: !_isPassVisible,
                 decoration: InputDecoration(
                     hintText: 'Password',
                     prefixIcon: Icon(Icons.lock,color: colors.umber,),
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
                 height: 50,
               ),
               materialbutton.materialButton(fontsize: 15,backColor: colors.umber,"LOGIN", ()async{
                 SharedPreferences prefs = await SharedPreferences.getInstance();
                 if(_email.text.isEmpty || _pass.text.isEmpty){
                   _snackbarMessage.snackbarMessage(context, message: "Email and password are required.", is_error: true);
                 }else{
                   _screenLoaders.functionLoader(context);
                   List _user = usersModel.value.where((s) => s["email"] == _email.text && s["password"] == _pass.text).toList();
                   print("USER RETURN ${_user}");
                   if(_user.isEmpty){
                     Navigator.of(context).pop(null);
                     _snackbarMessage.snackbarMessage(context, message: "Invalid credentials!" ,is_error: true);
                   }else{
                     usersModel.updateUser(data: _user.first);
                     prefs.setString('email', _email.text);
                     prefs.setString('password', _pass.text.toString());
                     _routes.navigator_pushreplacement(context, Landing());
                   }
                 }
               }),
               SizedBox(
                 height: 20,
               ),
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   Text("Don't have an account?",style: TextStyle(color: Colors.black,fontFamily: "OpenSans"),),
                   InkWell(
                     onTap: (){
                       _routes.navigator_push(context, Register());
                     },
                     child: Text(" CREATE ACCOUNT",style: TextStyle(color: colors.umber,fontWeight: FontWeight.bold,fontFamily: "OpenSans"),),
                   )
                 ],
               )
             ],
           ),
          ],
        ),
      ),
    );
  }
}
