import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/modules/login_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cubit/cubit.dart';
import 'package:social_app/shared/network/local/cubit/cubit_states.dart';
import 'package:social_app/shared/style/colors.dart';

class Settings extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.chevron_left, size: 26.sp,),
              ),
              title: Text(
                "Settings",
                style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: cubit.isDark ? Colors.white : Colors.black,
                ),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Preferences
                      Container(
                        color: cubit.isDark? DarkBackground : superBabyBlue,
                        width: double.infinity,
                        padding: EdgeInsets.only(
                            left: 20.0.w, top: 7.5.h, bottom: 7.5.h),
                        child: Text(
                          'Preferences'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0.sp,
                          ),
                        ),
                      ),

                      // Dark Mode
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(5.sp),
                          decoration: BoxDecoration(
                            color: cubit.isDark? DarkSurface : Colors.white,
                            borderRadius: BorderRadius.circular(14.sp),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              //dark mode
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.w),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.dark_mode_outlined,
                                      size: 28.sp,
                                      color: cubit.isDark ? Colors.white : Colors.black,
                                    ),
                                    SizedBox(
                                      width: 10.0.w,
                                    ),
                                    Text(
                                      'Dark Mode',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.0.sp,
                                        color: cubit.isDark ? Colors.white : Colors.black,
                                      ),
                                    ),
                                    Spacer(),
                                    Transform.scale(
                                      scale: 0.95.h,
                                      child: CupertinoSwitch(
                                        value: cubit.isDark,
                                        activeColor: blue,
                                        thumbColor: cubit.isDark ? DarkSurface : Colors.white,
                                        onChanged: (state) {
                                          cubit.changeThemeMode(state);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Logout
                      Container(
                        color: cubit.isDark? DarkBackground : superBabyBlue,
                        width: double.infinity,
                        padding: EdgeInsets.only(
                            left: 20.0.w, top: 7.5.h, bottom: 7.5.h),
                        child: Text(
                          'Logout'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0.sp),
                        ),
                      ),

                      // Logout Button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                        child: Container(
                          decoration: BoxDecoration(
                            color: cubit.isDark ? DarkSurface : Colors.white,
                            borderRadius: BorderRadius.circular(14.sp),
                          ),
                          padding: EdgeInsets.all(10.sp),
                          child: Row(
                            children: [
                              SizedBox(width: 5.w,),
                              Icon(
                                Icons.logout,
                                size: 28.sp,
                                color: cubit.isDark ? Colors.white : Colors.black,
                              ),
                              SizedBox(
                                width: 10.0.w,
                              ),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0.sp,
                                  color: cubit.isDark ? Colors.white : Colors.black,
                                ),
                              ),

                              Spacer(),

                              InkWell(
                                borderRadius: BorderRadius.circular(10.0.sp),
                                onTap: () {
                                  cubit.signOut();
                                  navigateAndFinish(context: context, widget: LoginScreen());
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10.0.sp),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Logout',
                                        style: TextStyle(
                                          color: blue,
                                          fontSize: 14.0.sp,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 18.0.sp,
                                        color: blue,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ),
        );
      }
    );
  }
}
