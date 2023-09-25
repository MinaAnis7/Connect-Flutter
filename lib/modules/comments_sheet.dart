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

          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: superBabyBlue),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
              backgroundColor: superBabyBlue,
              title: Text(
                'Leave a Comment',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
            ),
            backgroundColor: superBabyBlue,
            body: GestureDetector(
              onTap: () => commentFocus.unfocus(),
              child: StatefulBuilder(
                builder: (context, setState) => Container(
                  width: double.infinity,
                  padding:
                  EdgeInsets.symmetric(horizontal: 10.w),
                  child: SafeArea(
                    child: Column(
                      children: [

                        separator,

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
                                    .bottom),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Image
                                if (!commentFocus.hasFocus)
                                  CircleAvatar(
                                    radius: 23.sp,
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(
                                        cubit.userModel!.image),
                                  ),
                                SizedBox(width: 10.h),

                                // TFF
                                Expanded(
                                  child: defaultTFF(
                                      hintText:
                                      'Write your comment...',
                                      keyboardType:
                                      TextInputType.text,
                                      controller:
                                      commentController,
                                      color: Colors.white,
                                      focus: commentFocus,
                                      maxLines: 3,
                                      minLines: 1,
                                      validator: (value) {
                                        if (value != null &&
                                            value == '') {
                                          return 'Please, Type Something';
                                        }
                                      }),
                                ),

                                SizedBox(width: 10.h),

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
              color: Colors.white,
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
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),

                Text(
                  comment.comment,
                  style: TextStyle(
                    fontSize: 14.sp,
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