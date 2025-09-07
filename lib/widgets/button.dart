import 'package:flutter/material.dart';
import '../../../utils/palettes/app_colors.dart' hide Colors;

class Materialbutton{
  Widget materialButton(String? text,void Function()? function,{ Color backColor = Colors.white,double spacing = 5,Color textColor = Colors.white, String icon = "", double radius = 1000, double fontsize = 16}){
    return MaterialButton(
      height: 55,
      color: backColor,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           icon == "" ? Container() : Image(
              width: 25,
              image: AssetImage(icon),
            ),
            SizedBox(
              width: spacing,
            ),
            Text(text!,style: TextStyle(fontSize: fontsize,fontFamily: "AppFontStyle",color: textColor,),textAlign: TextAlign.center,),
          ],
        ),
      ),
      onPressed: function,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
final Materialbutton materialbutton = new Materialbutton();