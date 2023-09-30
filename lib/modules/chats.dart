import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chat_room.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cubit/cubit.dart';
import 'package:social_app/shared/network/local/cubit/cubit_states.dart';
import 'package:social_app/shared/style/colors.dart';

class Chats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
          body: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
            child: ConditionalBuilder(
              condition: cubit.allUsers.length != 0,
              builder: (context) => ConditionalBuilder(
                condition: state is! GetAllUsersLoadingState,
                builder: (context) => SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 15.h,),

                      // Search for chats
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.sp),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade400,
                                blurRadius: 7,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 14.sp,
                            ),
                            decoration: InputDecoration(
                              // This is giving me the responsive property,
                              // based on text and Icon size
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.sp),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Search',
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: Icon(CupertinoIcons.search, size: 20.sp,),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 15.h,),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13.sp),
                          ),
                          child: ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => chatItemBuilder(cubit.allUsers[index], context),
                            separatorBuilder:(context, index) => separator,
                            itemCount: cubit.allUsers.length,
                            shrinkWrap: true,
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h,),
                    ],
                  ),
                ),
                fallback: (context) => Center(child: CircularProgressIndicator(color: blue,),),
              ),
              fallback: (context) => Center(
                child: Text(
                  'No Users.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget chatItemBuilder(UserModel user, BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(13.5.sp),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              PageTransition(type: PageTransitionType.rightToLeft,
                  child: ChatRoom(user)));
        },
        splashColor: Colors.grey.shade50,
        highlightColor: Colors.grey.shade50,
        child: Container(
          padding: EdgeInsets.all(12.5.sp),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: superBabyBlue,
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
                          color: Colors.black,
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
