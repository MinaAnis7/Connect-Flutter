import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/shared/network/local/cubit/cubit.dart';
import 'package:social_app/shared/network/local/cubit/cubit_states.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../shared/style/colors.dart';

class PostLoves extends StatelessWidget {

  final PostModel post;

  PostLoves(this.post);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {

      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        return ConditionalBuilder(
          condition: cubit.postLoves.isNotEmpty,
          builder: (context) {
            return Container(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height / 2,
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) =>
                    loveItemBuilder(cubit.postLoves[index], context, cubit),
                separatorBuilder: (context, index) {return Container();},
                itemCount: cubit.postLoves.length,
                shrinkWrap: true,
              ),
            );
          },
          fallback: (context) {
            return Center(
              child: Text(
                "No loves yet",
                style: TextStyle(
                    fontSize: 14.sp,
                  color: cubit.isDark ? Colors.grey : Colors.grey.shade700
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget loveItemBuilder(UserModel user, BuildContext context, AppCubit cubit) {
    return Container(
      padding: EdgeInsets.all(13.5.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: cubit.isDark ? DarkBackground : superBabyBlue,
            radius: 25.sp,
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
                      fontSize: 13.sp,
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
                    fontSize: 12.5.sp,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
