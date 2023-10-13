import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/modules/comments_sheet.dart';
import 'package:social_app/modules/connections.dart';
import 'package:social_app/modules/create_post.dart';
import 'package:social_app/modules/edit_profile.dart';
import 'package:social_app/modules/post_loves.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cubit/cubit_states.dart';
import 'package:social_app/shared/style/colors.dart';
import 'package:social_app/shared/style/icons/my_icons_icons.dart';
import '../shared/network/local/cubit/cubit.dart';

class Profile extends StatelessWidget {
  final tagsController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        double height = MediaQuery
            .of(context)
            .size
            .height;
        AppCubit cubit = AppCubit.get(context);


        return ConditionalBuilder(
          condition: cubit.userModel != null,
          fallback: (context) =>
              Center(child: CircularProgressIndicator(color: blue,),),
          builder: (context) =>
              RefreshIndicator(
                onRefresh: () async {
                  cubit.getProfilePosts();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                  ),
                  child: RefreshIndicator(
                    color: blue,
                    onRefresh: () async {
                      await cubit.getUserDataRefresh();
                    },
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          // Cover & profile picture
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.sp),
                              color: cubit.isDark ? DarkSurface : Colors.white,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: height / 3.5,
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              10.sp),
                                          child: Image(
                                            image: NetworkImage(
                                                cubit.userModel!.cover),
                                            height:
                                            MediaQuery
                                                .of(context)
                                                .size
                                                .height / 4.5,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),

                                      //Profile Image
                                      Stack(alignment: Alignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: 52.sp,
                                              backgroundColor: superBabyBlue,
                                            ),
                                            CircleAvatar(
                                              radius: 50.sp,
                                              backgroundColor: superBabyBlue,
                                              backgroundImage: NetworkImage(
                                                  cubit.userModel!.image),
                                            ),
                                          ]),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                // Name
                                Text(
                                  cubit.userModel!.name,
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold,
                                    color: cubit.isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                                // Bio
                                Text(
                                  cubit.userModel!.bio,
                                  style: TextStyle(
                                    color: cubit.isDark ? Colors.white : Colors.black54,
                                    fontSize: 12.9.sp,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.sp,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                navigateTo(
                                                  context: context,
                                                  widget: Connections(),
                                                );
                                              },
                                              child: Column(
                                                children: [
                                                  Text(
                                                    '${cubit.userModel!
                                                        .numOfConnects}',
                                                    style: TextStyle(
                                                      fontSize: 20.sp,
                                                      color: cubit.isDark ? Colors.white : Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Connections',
                                                    style: TextStyle(
                                                      fontSize: 12.5.sp,
                                                      color: cubit.isDark ? Colors.white : Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: defaultButton(
                                          onPressed: () {
                                            navigateTo(context: context,
                                                widget: EditProfile(
                                                  name: cubit.userModel!.name,
                                                  phone: cubit.userModel!.phone,
                                                  bio: cubit.userModel!.bio,
                                                ));
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: [
                                              Text(
                                                'Edit Profile',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: cubit.isDark? Colors.white : Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: 5.w,),
                                            ],
                                          ),
                                          color: cubit.isDark ? ko7ly : superBabyBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.h,),
                              ],
                            ),
                          ),

                          SizedBox(height: 10.h,),
                          // Create Post
                          Container(
                            width: double.infinity,
                            child: Card(
                              clipBehavior: Clip.hardEdge,
                              elevation: 3.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.sp),
                              ),
                              color: cubit.isDark ? DarkSurface : Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image and text
                                  InkWell(
                                    onTap: () {
                                      navigateTo(
                                          context: context,
                                          widget: CreatePost());
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
                                  separator(context),

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
                                                    padding: EdgeInsets
                                                        .symmetric(
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
                                                                    BorderRadius
                                                                        .circular(
                                                                        10.sp),
                                                                  )),
                                                              child: FaIcon(
                                                                FontAwesomeIcons
                                                                    .plus,
                                                                color: Colors
                                                                    .white,
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
                                                    overflow: TextOverflow
                                                        .ellipsis,
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
                            condition: cubit.profilePosts.isNotEmpty,
                            builder: (context) =>
                                ListView.separated(
                                  itemBuilder: (context, index) =>
                                      postBuilder(
                                          context, cubit.profilePosts[index],
                                          index, cubit, state),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                  itemCount: cubit.profilePosts.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                ),
                            fallback: (context) =>
                                ConditionalBuilder(
                                    condition: state is GetProfilePostsLoadingState,
                                    builder: (context) =>
                                        Column(
                                          children: [
                                            SizedBox(height: 10.h,),
                                            CircularProgressIndicator(color: blue,),
                                          ],
                                        ),
                                    fallback: (context) =>
                                        Center(
                                          child: Text(
                                            "No Posts Yey :/",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: cubit.isDark ? Colors.grey : Colors.grey.shade700,
                                            ),
                                          ),
                                        ),
                                )
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
        color: cubit.isDark ? DarkSurface : Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post info
            Row(
              children: [
                // Image
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

                // Name & Date time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.name,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: cubit.isDark ? Colors.white : Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${post.dateTime}',
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
                PopupMenuButton(
                  color: cubit.isDark? Colors.white : Colors.black,
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Row(
                          children: [
                            Icon(MyIcons.trash, color: Colors.red, size: 20.sp,),
                            SizedBox(width: 7.w,),
                            Text("Delete", style: TextStyle(fontSize: 14.sp),),
                          ],
                        ),
                        onTap: () {
                          cubit.deletePost(post);
                        },
                      ),
                    ];
                  },
                ),


                SizedBox(
                  width: 3.w,
                ),
              ],
            ),

            separator(context),

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
                  color: cubit.isDark ? Colors.white : Colors.black,
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
            if (post.postImage != null)
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
                      cubit.getLoves(post);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            title: Text(
                              "Who loved this post",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                                color: cubit.isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.sp),
                            ),
                            elevation: 5,
                            backgroundColor: cubit.isDark ?
                            DarkSurface : Colors.white,
                            children: [
                              PostLoves(post),
                            ],
                          );
                        },
                      );
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

            separator(context),

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
                                      size: 21.sp,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      'Loved',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                          fontSize: 13.sp
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
                                    Icon(MyIcons.heart, size: 21.sp,
                                      color: cubit.isDark ? Colors.white : Colors.black,),

                                    SizedBox(
                                      width: 5.w,
                                    ),

                                    Text('Love',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: cubit.isDark ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(MyIcons.heart, size: 21.sp,
                                  color: cubit.isDark ? Colors.white : Colors.black,
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text('Love',
                                    style: TextStyle(fontSize: 13.sp,
                                      color: cubit.isDark ? Colors.white : Colors.black,)),
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
                          Icon(MyIcons.comment, size: 21.sp,color: cubit.isDark ? Colors.white : Colors.black,),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text('Comment', style: TextStyle(
                            fontSize: 13.sp, color: cubit.isDark ? Colors.white : Colors.black,)),
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
