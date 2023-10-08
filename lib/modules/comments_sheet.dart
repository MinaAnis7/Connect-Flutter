import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/comment_model.dart';
import '../models/post_model.dart';
import '../shared/components/components.dart';
import '../shared/network/local/cubit/cubit.dart';
import '../shared/network/local/cubit/cubit_states.dart';
import '../shared/style/colors.dart';
import '../shared/style/icons/my_icons_icons.dart';

class CommentsSheet extends StatelessWidget
{
  static var formKey = GlobalKey<FormState>();
  static TextEditingController commentController = TextEditingController();
  static FocusNode commentFocus = FocusNode();
  late PostModel post;

  CommentsSheet(this.post);

  Widget build(BuildContext context)
  {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          commentFocus.addListener(() {
            cubit.changeCommentImageState();
          });
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: cubit.isDark ? DarkSurface : superBabyBlue),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: cubit.isDark ? Colors.white : Colors.black,
                ),
              ),
              title: Text(
                'Leave a Comment',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: cubit.isDark ? Colors.white : Colors.black,
                ),
              ),
              centerTitle: true,
            ),
            backgroundColor: cubit.isDark ? DarkSurface : superBabyBlue,
            body: GestureDetector(
              onTap: () {
                commentFocus.unfocus();
                cubit.changeCommentImageState();
              },
              child: StatefulBuilder(
                builder: (context, setState) => Container(
                  width: double.infinity,
                  padding:
                  EdgeInsets.symmetric(horizontal: 10.w),
                  child: SafeArea(
                    child: Column(
                      children: [

                        separator(context),

                        SizedBox(
                          height: 10.h,
                        ),

                        // Comments
                        Expanded(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Container(
                              width: double.infinity,
                              child: ConditionalBuilder(
                                condition: state is! GetCommentsLoadingState,
                                builder:(context) => ConditionalBuilder(
                                  condition: cubit.comments.length != 0,
                                  builder: (context) => ListView.separated(
                                    itemBuilder: (context, index) => commentBuilder(cubit, cubit.comments[index]),
                                    separatorBuilder: (context, index) => SizedBox(
                                          height: 25.h,
                                        ),
                                    itemCount: cubit.comments.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                  ),
                                  fallback: (context) => Center(
                                        child: Text(
                                          'No Comments yet.',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                      )
                                ),
                                fallback: (context) => Center(child: CircularProgressIndicator(color: blue,),),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 10.h,
                        ),

                        // Writing
                        Form(
                          key: formKey,
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery
                                    .of(context)
                                    .viewInsets
                                    .bottom,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Image
                                if (!commentFocus.hasFocus)
                                  CircleAvatar(
                                    radius: 23.sp,
                                    backgroundColor: cubit.isDark ? DarkBackground : Colors.white,
                                    backgroundImage: NetworkImage(
                                        cubit.userModel!.image),
                                  ),
                                SizedBox(width: 10.h),

                                // TFF
                                Expanded(
                                  child: TFF_NoSuffix(
                                      hintText:
                                      'Write a comment...',
                                      hintColor: cubit.isDark? Colors.white : Colors.black,
                                      keyboardType:
                                      TextInputType.text,
                                      controller:
                                      commentController,
                                      inputColor: cubit.isDark ? Colors.white : Colors.black,
                                      borderColor: cubit.isDark ? DarkBlue : blue,
                                      color: cubit.isDark ? DarkBackground : Colors.white,
                                      focus: commentFocus,
                                      maxLines: 3,
                                      minLines: 1,
                                      validator: (value) {
                                        if (value != null &&
                                            value == '') {
                                          return 'Please, Type Something';
                                        }
                                        return null;
                                      }),
                                ),

                                SizedBox(width: 10.w),

                                // Post a Comment
                                TextButton(
                                  onPressed: () {
                                    if (formKey.currentState!
                                        .validate()) {
                                      cubit.comment(post,
                                          commentController.text);
                                      commentController.text = '';
                                    }

                                  },
                                  child: Icon(
                                    MyIcons.paper_plane,
                                    color: blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

  static Widget commentBuilder(AppCubit cubit, CommentModel comment) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
            comment.user!.image,
          ),
          backgroundColor: Colors.white,
          radius: 23.sp,
        ),
        SizedBox(
          width: 10.w,
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Container(
            decoration: BoxDecoration(
              color: cubit.isDark ? DarkBackground : Colors.white,
              borderRadius: BorderRadius.circular(10.sp),
            ),
            padding: EdgeInsets.all(10.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  comment.user!.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: cubit.isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),

                Text(
                  comment.comment,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: cubit.isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}