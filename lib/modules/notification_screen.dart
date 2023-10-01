import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/models/notification.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cubit/cubit.dart';
import 'package:social_app/shared/network/local/cubit/cubit_states.dart';
import 'package:social_app/shared/style/colors.dart';

class NotificationScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>
      (
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
                "Notifications",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
              centerTitle: true,
            ),
            backgroundColor: superBabyBlue,
            body: SafeArea(
              child: ConditionalBuilder(
                  condition: cubit.notifications.isNotEmpty,
                  builder: (context) {
                    return ConditionalBuilder(
                        condition: state is GetNotificationsLoadingState,
                        builder: (context) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: blue,
                              strokeWidth: 3.sp,
                            ),
                          );
                        },
                        fallback: (context) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(13.5.sp),
                              ),
                              child: ListView.separated(
                                itemBuilder: (context, index) {
                                    return notificationItemBuilder(cubit.notifications[index], cubit);
                                  },
                                separatorBuilder: (context, index) {
                                    return separator;
                                  },
                                itemCount: cubit.notifications.length,
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                              ),
                            ),
                          );
                        },
                    );
                  },
                  fallback: (context) {
                    return Center(child: Text(
                      "You don't have any notifications",
                    ),);
                  },
              )
            ),
          );
        },
    );
  }

  Widget notificationItemBuilder(NotificationModel notification, AppCubit cubit)
  {
    UserModel user = notification.user;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(13.5.sp),
      clipBehavior: Clip.hardEdge,
      child: Container(
        padding: EdgeInsets.all(12.5.sp),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            if (notification.type == "connection_request")
              Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  CircleAvatar(
                    backgroundColor: superBabyBlue,
                    radius: 30.sp,
                    backgroundImage: NetworkImage(user.image),
                  ),

                  SizedBox(
                    width: 15.w,
                  ),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: RichText(
                                  text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: user.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                        overflow: TextOverflow.ellipsis),
                                    ),
                                  TextSpan(
                                    text: " Wants To Connect With You!",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.black,
                                      overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              ),
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),

                        // Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  cubit.acceptConnection(notification);
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
                              ),

                              SizedBox(width: 10.w,),

                              MaterialButton(
                                onPressed: () {
                                  cubit.rejectConnection(notification);
                                },
                                child: Text(
                                  "Reject",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                color: Colors.red,
                                minWidth: 0,
                                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                                splashColor: Colors.red.shade300,
                                highlightColor: Colors.red.shade300,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.sp)
                                ),
                              )
                            ],
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (notification.type == "connection_accept")
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    CircleAvatar(
                      backgroundColor: superBabyBlue,
                      radius: 30.sp,
                      backgroundImage: NetworkImage(user.image),
                    ),

                    SizedBox(
                      width: 15.w,
                    ),

                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: user.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                            color: Colors.black,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      TextSpan(
                                        text: " Has Just Accepted your request, You're Now Friends!",
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.black,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ],
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),

                          // Mark as read Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  cubit.markAsRead(notification);
                                },
                                child: Text(
                                  "Mark as Read",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: blue,
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(width: 10.w,),

          ],
        ),
      ),
    );
  }
}
