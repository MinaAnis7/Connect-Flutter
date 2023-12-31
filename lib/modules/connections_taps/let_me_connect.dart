import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/shared/network/local/cubit/cubit.dart';
import 'package:social_app/shared/network/local/cubit/cubit_states.dart';

import '../../models/user_model.dart';
import '../../shared/components/components.dart';
import '../../shared/style/colors.dart';

class LetMeConnect extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        return Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              children: [
                SizedBox(height: 15.h,),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15.sp),
                  decoration: BoxDecoration(
                    color: cubit.isDark ? DarkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Intro Text
                        Text(
                          "Build New Connections!",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: cubit.isDark ? Colors.white : Colors.black,
                          ),
                        ),

                        SizedBox(height: 5.h,),

                        ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => connectionItemBuilder(cubit.allUsers[index], context),
                          separatorBuilder:(context, index) => separator(context),
                          itemCount: cubit.allUsers.length,
                          shrinkWrap: true,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget connectionItemBuilder(UserModel user, BuildContext context) {
    AppCubit cubit = AppCubit.get(context);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(13.5.sp),
      clipBehavior: Clip.hardEdge,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.5.sp),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // Image and Info
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  CircleAvatar(
                    backgroundColor: cubit.isDark ? DarkBackground : superBabyBlue,
                    radius: 30.sp,
                    backgroundImage: NetworkImage(user.image),
                  ),

                  SizedBox(
                    width: 15.w,
                  ),

                  // Info
                  Flexible(
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                              color: cubit.isDark ? Colors.white : Colors.black,
                              overflow: TextOverflow.ellipsis),
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          user.bio,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13.5.sp,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 10.w,),

            // Connect Button
            MaterialButton(
              onPressed: () {
                cubit.sendConnectionRequest(user);
                msg("Connection request was sent Successfully!");
              },
              child: Text(
                "Connect",
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
              color: blue,
              minWidth: 0,
              padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
              splashColor: Colors.blue.shade400,
              highlightColor: Colors.blue.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.sp)
              ),
            )
          ],
        ),
      ),
    );
  }
}
