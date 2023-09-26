import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/modules/comments_sheet.dart';
import 'package:social_app/modules/create_post.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cubit/cubit_states.dart';
import 'package:social_app/shared/style/colors.dart';
import 'package:social_app/shared/style/icons/my_icons_icons.dart';
import '../shared/network/local/cubit/cubit.dart';

class NewsFeed extends StatelessWidget {
  TextEditingController tagsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        return RefreshIndicator(
            onRefresh: () async {
              cubit.getPosts();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12.0.w,
              ),
              child: ConditionalBuilder(
                condition: cubit.userModel == null,
                builder: (context) => Center(
                  child: CircularProgressIndicator(
                    color: blue,
                  ),
                ),
                fallback: (context) => Container(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    key: key,
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!FirebaseAuth.instance.currentUser!.emailVerified)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.sp),
                            child: Container(
                              width: double.infinity,
                              color: babyBlue,
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline),
                                  SizedBox(
                                    width: 10.0.w,
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Please, verify your email address',
                                            style: TextStyle(
                                              fontSize: 12.99.sp,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            FirebaseAuth.instance.currentUser!
                                                .sendEmailVerification()
                                                .then((value) {
                                              Fluttertoast.showToast(
                                                msg:
                                                    'Verification mail was sent',
                                                toastLength: Toast.LENGTH_LONG,
                                                timeInSecForIosWeb: 1,
                                                gravity: ToastGravity.BOTTOM,
                                                backgroundColor: Colors.green,
                                                textColor: Colors.white,
                                                fontSize: 15.0.sp,
                                              );
                                            }).catchError((error) {
                                              if (kDebugMode)
                                                print(error.toString());
                                            });
                                          },
                                          child: Text(
                                            'Send',
                                            style: TextStyle(
                                              color: blue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        // create post
                        Container(
                          width: double.infinity,
                          child: Card(
                            clipBehavior: Clip.hardEdge,
                            elevation: 3.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.sp),
                            ),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image and text
                                InkWell(
                                  onTap: () {
                                    navigateTo(
                                        context: context, widget: CreatePost());
                                  },
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10.0.sp),
                                        child: ClipRRect(
                                          clipBehavior: Clip.hardEdge,
                                          borderRadius:
                                              BorderRadius.circular(30.sp),
                                          child: CircleAvatar(
                                            radius: 30.sp,
                                            backgroundColor: superBabyBlue,
                                            backgroundImage: NetworkImage(
                                              cubit.userModel!.image,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        'Share your thoughts...',
                                        style: TextStyle(
                                          fontSize: 12.9.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Separator
                                separator,

                                //Buttons
                                Row(
                                  children: [
                                    // Image
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(8.sp),
                                        child: InkWell(
                                          onTap: () {
                                            cubit.addPostImage();
                                            navigateTo(
                                                context: context,
                                                widget: CreatePost());
                                          },
                                          borderRadius:
                                              BorderRadius.circular(5.sp),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                MyIcons.camera,
                                                color: Colors.red[300],
                                                size: 22.0.sp,
                                              ),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Text(
                                                'Image',
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Tags
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0.sp),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(5.sp),
                                          onTap: () {
                                            navigateTo(
                                                context: context,
                                                widget: CreatePost());
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.w),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: TextFormField(
                                                              controller:
                                                                  tagsController,
                                                              decoration:
                                                                  InputDecoration(
                                                                hintText:
                                                                    'Add a Tag',
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                              ),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              cubit.addTag(
                                                                  tagsController
                                                                      .text);
                                                              tagsController
                                                                  .text = '';
                                                            },
                                                            style: TextButton
                                                                .styleFrom(
                                                                    backgroundColor:
                                                                        blue,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.sp),
                                                                    )),
                                                            child: FaIcon(
                                                              FontAwesomeIcons
                                                                  .plus,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                MyIcons.tag,
                                                color: blue,
                                                size: 22.0.sp,
                                              ),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Text(
                                                'Tags',
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0.sp),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(5.sp),
                                          onTap: () {},
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                MyIcons.doc,
                                                color: Colors.green,
                                                size: 22.0.sp,
                                              ),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'Document',
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: Colors.grey),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3.h,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 10.h,
                        ),

                        // Posts
                        ConditionalBuilder(
                          condition: cubit.posts.length != 0,
                          builder: (context) => ListView.separated(
                            itemBuilder: (context, index) => postBuilder(
                                context, cubit.posts[index], index, cubit, state),
                            separatorBuilder: (context, index) => SizedBox(
                              height: 10.h,
                            ),
                            itemCount: cubit.posts.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                          ),
                          fallback: (context) => Column(
                            children: [
                              SizedBox(
                                height: 10.h,
                              ),
                              Center(
                                child: CircularProgressIndicator(
                                  color: blue,
                                ),
                              ),
                            ],
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
      },
    );
  }

  Widget postBuilder(
      BuildContext context, PostModel post, int index, AppCubit cubit, state) {
    return Container(
      width: double.infinity,
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.sp),
        ),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post info
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0.sp),
                  child: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(25.sp),
                    child: CircleAvatar(
                      radius: 25.sp,
                      backgroundColor: superBabyBlue,
                      backgroundImage: NetworkImage(
                        post.profilePicture,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.name,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        post.dateTime,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Post options
                IconButton(
                  onPressed: () {},
                  icon: FaIcon(FontAwesomeIcons.ellipsis, size: 20.sp,),
                ),

                SizedBox(
                  width: 3.w,
                ),
              ],
            ),

            separator,

            SizedBox(
              height: 2.h,
            ),

            // Caption
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              child: ReadMoreText(
                post.text,
                style: TextStyle(
                  fontSize: 13.5.sp,
                ),
                trimLines: 3,
                trimMode: TrimMode.Line,
              ),
            ),

            SizedBox(
              height: 2.h,
            ),

            // Tags
            if (post.tags.isNotEmpty)
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Wrap(
                    children: List.generate(
                      post.tags.length,
                      (index) => InkWell(
                        child: Text(
                          '#' + post.tags[index],
                          style: TextStyle(
                            fontSize: 12.5.sp,
                            color: blue,
                          ),
                        ),
                        onTap: () {},
                      ),
                    ),
                    spacing: 5.w,
                  )),

            SizedBox(
              height: 5.h,
            ),

            // Image
            if (post.postImage!.isNotEmpty)
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 2,
                ),
                child: Image.network(
                  post.postImage!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            SizedBox(
              height: 10.h,
            ),

            // Number of Loves and Comments
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // loves
                  InkWell(
                    onTap: () {
                      // Getting Who Loved This
                    },
                    child: Row(
                      children: [
                        Icon(
                          MyIcons.heart,
                          color: Colors.red,
                          size: 20.sp,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          '${post.numOfLikes}',
                          style: TextStyle(color: Colors.red, fontSize: 13.sp),
                        ),
                      ],
                    ),
                  ),

                  // comments
                  Row(
                    children: [
                      Icon(
                        MyIcons.comment,
                        color: blue,
                        size: 20.sp,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        '${post.numOfComments}',
                        style: TextStyle(
                          color: blue,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 10.h,
            ),

            separator,

            SizedBox(
              height: 10.h,
            ),

            // Loving and Commenting
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Loving
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        cubit.love(post);
                      },
                      child: FutureBuilder<bool>(
                        future: cubit.isLoved(post),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!) {
                              return InkWell(
                                onTap: () {
                                  cubit.loveWithdrawal(post);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      MyIcons.heart,
                                      color: Colors.red,
                                      size: 22.sp,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      'Loved',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        fontSize: 14.sp
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return InkWell(
                                onTap: () {
                                  cubit.love(post);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(MyIcons.heart, size: 22.sp,),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text('Love', style: TextStyle(fontSize: 14.sp),),
                                  ],
                                ),
                              );
                            }
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(MyIcons.heart, size: 22.sp,),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text('Love', style: TextStyle(fontSize: 14.sp)),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  // Commenting
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        cubit.getComments(post);
                        Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: CommentsSheet(post)));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(MyIcons.comment, size: 22.sp,),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text('Comment', style: TextStyle(fontSize: 14.sp)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }

}
