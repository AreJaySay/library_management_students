import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:students/models/notifications.dart';
import 'package:students/models/users.dart';
import 'package:students/screens/profile/components/change_password.dart';
import 'package:students/screens/profile/components/edit_profile.dart';
import 'package:students/services/routes.dart';
import 'package:students/utils/palettes/app_colors.dart' hide Colors;

import '../../credentials/login.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Routes _routes = new Routes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Profile",style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.w500,fontSize: 21),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          children: [
            Row(
              children: [
                StreamBuilder(
                    stream: uploadPict.subject,
                    builder: (context, profileSnapshot) {
                    return  !profileSnapshot.hasData ?
                    CircularProgressIndicator() :
                    profileSnapshot.data!.isNotEmpty ?
                    Container(
                      width: 50,
                      height: 50,
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
                      width: 50,
                      height:  50,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage("https://cdn-icons-png.freepik.com/512/8742/8742495.png"),
                      ),
                    );
                  }
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome",style: TextStyle(fontFamily: "OpenSans",color: Colors.grey),),
                      Text("${usersModel.loggedUser.value["name"]}",style: TextStyle(fontFamily: "OpenSans",fontSize: 16,fontWeight: FontWeight.w600),),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.logout,color: colors.umber,),
                  onPressed: ()async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.clear();
                    _routes.navigator_pushreplacement(context, Login());
                    },
                )
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Divider(color: Colors.grey.shade200,),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: (){
                _routes.navigator_push(context, EditProfile());
              },
              child: Row(
                children: [
                  Icon(Icons.account_circle_outlined,size: 27,color: Colors.grey,),
                  SizedBox(
                    width: 20,
                  ),
                  Text("User Profile",style: TextStyle(fontFamily: "OpenSans",fontSize: 15,fontWeight: FontWeight.w500),),
                  Spacer(),
                  Icon(Icons.keyboard_arrow_right),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Divider(color: Colors.grey.shade200,),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: (){
                _routes.navigator_pushreplacement(context, ChangePassword());
              },
              child: Row(
                children: [
                  Icon(Icons.lock_outline,size: 27,color: Colors.grey,),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Change Password",style: TextStyle(fontFamily: "OpenSans",fontSize: 15,fontWeight: FontWeight.w500),),
                  Spacer(),
                  Icon(Icons.keyboard_arrow_right),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Divider(color: Colors.grey.shade200,),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Icon(Icons.notifications_none,size: 27,color: Colors.grey,),
                SizedBox(
                  width: 20,
                ),
                Text("Push Notification",style: TextStyle(fontFamily: "OpenSans",fontSize: 15,fontWeight: FontWeight.w500),),
                Spacer(),
                StreamBuilder(
                  stream: notificationModel.controller,
                  builder: (context, snapshot) {
                    return !snapshot.hasData ?
                    Center(
                      child: CircularProgressIndicator(),
                    ) :
                    Switch(
                      activeTrackColor: colors.umber,
                      inactiveTrackColor: Colors.grey.shade300,
                      inactiveThumbColor: Colors.white,
                      value: snapshot.data!,
                      trackOutlineColor: MaterialStateProperty.resolveWith(
                            (final Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return null;
                          }

                          return Colors.transparent;
                        },
                      ),
                      onChanged: (value){
                        notificationModel.updateController(data: value);
                      });
                  }
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
