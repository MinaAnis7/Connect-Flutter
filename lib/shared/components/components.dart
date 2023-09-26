import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:social_app/shared/network/local/cubit/cubit.dart';
import 'package:social_app/shared/network/local/cubit/cubit_states.dart';

import '../style/colors.dart';

//#region Connect logo
Widget logo = Center(
  child:   Text(
    'Connect',
    style: TextStyle(
      fontFamily: 'Pacifico',
      color: blue,
      fontSize: 22.0.sp,
      fontWeight: FontWeight.w700,
    ),
  ),
);

//#endregion

//#region My Text Form Field
Widget defaultTFF({
  required String hintText,
  required TextInputType keyboardType,
  Widget? prefixIcon,
  bool isObscure = false,
  IconData? suffixIcon,
  Function()? suffixOnPressed,
  TextEditingController? controller,
  String? Function(String?)? validator,
  Color? color,
  FocusNode? focus,
  int? maxLines,
  int? minLines,
  Function(String)? onChanged,
}) {
  return BlocConsumer<AppCubit, AppStates>(
    listener: (context, state) {},
    builder: (context, state) {
      return TextFormField(
        keyboardType: keyboardType,
        controller: controller,
        focusNode: focus,
        maxLines: maxLines,
        minLines: minLines,
        onChanged: onChanged,
        validator: validator,
        obscureText: isObscure,
        style: TextStyle(color: black),
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: IconButton(
            icon: Icon(suffixIcon),
            onPressed: suffixOnPressed,
          ),
          fillColor: color ?? superBabyBlue,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black54),
          focusColor: blue,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0.sp),
            borderSide: BorderSide(color: babyBlue, width: 0.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(style: BorderStyle.none),
            borderRadius: BorderRadius.circular(20.0.sp),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(style: BorderStyle.none),
            borderRadius: BorderRadius.circular(20.0.sp),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(style: BorderStyle.none),
            borderRadius: BorderRadius.circular(20.0.sp),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(style: BorderStyle.none),
            borderRadius: BorderRadius.circular(20.0.sp),
          ),
        ),
      );
    },
  );
}

//#endregion

//#region My Button
Widget defaultButton({
  required Function() onPressed,
  required Widget child,
  required Color color,
  Color? highlightColor,
}) {
  return MaterialButton(
    onPressed: onPressed,
    color: color,
    highlightColor: highlightColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0.sp),
    ),
    minWidth: double.infinity,
    padding: EdgeInsets.all(10.0.sp),
    child: child,
  );
}

//#endregion

//#region Navigation
void navigateTo({context, widget}) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ));
}

void navigateAndFinish({context, widget}) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
    (route) => false,
  );
}

//#endregion

//#region MyToast

void toastDF({
  context,
  required String title,
  required String describtion,
  required Color color,
  required IconData icon,
}) {
  MotionToast(
    title: Text(
      title,
      style: TextStyle(
        fontSize: 14.sp,
        color: color,
        fontWeight: FontWeight.bold,
      ),
    ),
    description: Text(
      describtion,
      style: TextStyle(
        fontSize: 12.sp,
        color: Colors.white,
      ),
    ),
    icon: icon,
    primaryColor: color,
    toastDuration: Duration(seconds: 5),
    padding: EdgeInsets.all(20.0.sp),
    enableAnimation: false,
    displaySideBar: false,
    constraints: BoxConstraints(),
    animationCurve: Curves.fastLinearToSlowEaseIn,
  ).show(context);
}

//#endregion

//#region Error Toast

void errorMsg(String error) {
  Fluttertoast.showToast(
    msg: error,
    backgroundColor: Colors.red,
    fontSize: 14.sp,
    timeInSecForIosWeb: 3,
  );
}

//#endregion

//#region Separator

Widget separator = Padding(
  padding: EdgeInsets.symmetric(horizontal: 10.0),
  child: Container(
    height: 1.0.h,
    width: double.infinity,
    color: Colors.grey[300],
  ),
);

//#endregion

