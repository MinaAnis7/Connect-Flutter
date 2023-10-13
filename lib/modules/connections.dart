import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/modules/user_profile.dart';
import 'package:social_app/shared/network/local/cubit/cubit.dart';
import 'package:social_app/shared/network/local/cubit/cubit_states.dart';

import '../models/user_model.dart';
import '../shared/components/components.dart';
import '../shared/style/colors.dart';

class Connections extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {

      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);


        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.chevron_left, size: 25.sp,),
            ),
            title: Text(
              "My Connections",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
            centerTitle: true,
          ),

          body: Container(
            child: ConditionalBuilder(
              condition: cubit.myConnections.isNotEmpty,
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: cubit.isDark ? DarkSurface : Colors.white,
                          borderRadius: BorderRadius.circular(13.sp),
                        ),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) =>
                                    connectionItemBuilder(cubit.myConnections[index], context, cubit),
                                separatorBuilder: (context, index) => separator(context),
                                itemCount: cubit.myConnections.length,
                                shrinkWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              fallback: (context) {
                return Center(
                  child: Text(
                    "No Connections",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget connectionItemBuilder(UserModel user, BuildContext context, AppCubit cubit) {
    return InkWell(
      onTap: () {
        navigateTo(context: context, widget: UserProfile(user));
        cubit.getUserPosts(user);
      },
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(13.5.sp),
        clipBehavior: Clip.hardEdge,
        child: Container(
          padding: EdgeInsets.all(12.5.sp),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: cubit.isDark ? DarkBackground : superBabyBlue,
                radius: 30.sp,
                backgroundImage: NetworkImage(user.image),
              ),
              SizedBox(
                width: 15.w,
              ),
              Flexible(
                fit: FlexFit.loose,
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
      ),
    );
  }
}
