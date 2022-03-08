import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

Widget defaultButton({
  Color color: Colors.blue,
  double width: double.infinity,
  Function? function,
  required String text,
}) =>
    Container(
      width: width,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(25)),
      child: MaterialButton(
        onPressed: () {
          function!();
        },
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );

Widget defaultTextFormField({
  bool isOutLine = false,
  bool showPassword: false,
  required TextInputType type,
  required TextEditingController controller,
  onFieldSubmitted,
  onChanged,
  onTap,
  /*
Function ? onChang;
Onchange:(value){
onChang!(value)
}
 */

  Function? validator,
  required String label,
  required IconData prefix,
  IconData? suffix,
  suffixPress,
}) =>
    Center(
      child: Container(
        height: 60,
        width: isOutLine ? 380 : 350,
        child: TextFormField(
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          obscureText: showPassword,
          keyboardType: type,
          controller: controller,
          onTap: onTap,
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChanged,
          validator: (value) => validator!(value),
          decoration: InputDecoration(
            errorStyle: TextStyle(fontSize: 12, fontStyle: FontStyle.normal),
            labelText: '$label',
            border: isOutLine ? OutlineInputBorder() : null,
            labelStyle: TextStyle(height: 0.7),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Icon(prefix),
            ),
            suffix: IconButton(
              onPressed: suffixPress,
              icon: Icon(suffix),
            ),
          ),
        ),
      ),
    );

void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
void navigateToAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => widget), (route) {
      return false;
    });
void showToast({required String text, required ToastStates state}) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0);
}

enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.yellow;
      break;
  }
  return color;
}
