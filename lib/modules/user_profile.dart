import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chat_room.dart';
import 'package:social_app/modules/comments_sheet.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cubit/cubit_states.dart';
import 'package:social_app/shared/style/colors.dart';
import 'package:social_app/shared/style/icons/my_icons_icons.dart';
import '../shared/network/local/cubit/cubit.dart';

class UserProfile extends StatelessWidget {
  final UserModel user;

  UserProfile(this.user);


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


        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.chevron_left, size: 25.sp,),
            ),
            title: Text(
              user.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
            centerTitle: true,
          ),

          body: RefreshIndicator(
            onRefresh: () async {
              cubit.getUserPosts(user);
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
                                            user.cover),
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
                                              user.image),
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
                              user.name,
                              style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
                                color: cubit.isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            // Bio
                            Text(
                              user.bio,
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
                                        Text(
                                          '${user.numOfConnects}',
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

                                  FutureBuilder<bool>(
                                    future: cubit.isConnectionExists(user),
                                    builder: (context, snapshot) {
                                      if(snapshot.hasData)
                                        {
                                          if(snapshot.data!)
                                            {
                                              return Expanded(
                                                child: defaultButton(
                                                  onPressed: () {
                                                    Navigator.push(context,
                                                    PageTransition(
                                                        child: ChatRoom(user),
                                                        type: PageTransitionType.rightToLeft));
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      Text(
                                                        'Message',
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
                                              );
                                            }
                                          else
                                            {
                                              return Expanded(
                                                child: defaultButton(
                                                  onPressed: () {
                                                    cubit.sendConnectionRequest(user);
                                                    msg("Connection Sent Successfully!");
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      Text(
                                                        'Connect',
                                                        style: TextStyle(
                                                            fontSize: 14.sp,
                                                            color: cubit.isDark? Colors.white : Colors.blue,
                                                            fontWeight: FontWeight.bold,
                                                            fontFamily: 'Pacifico'
                                                        ),
                                                      ),
                                                      SizedBox(width: 5.w,),
                                                    ],
                                                  ),
                                                  color: cubit.isDark ? ko7ly : superBabyBlue,
                                                ),
                                              );
                                            }
                                        }
                                      else
                                        {
                                          return Expanded(
                                            child: defaultButton(
                                              onPressed: () {
                                                cubit.sendConnectionRequest(user);
                                                msg("Connection Sent Successfully!");
                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .center,
                                                children: [
                                                  Text(
                                                    'Connect',
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: cubit.isDark? Colors.white : Colors.blue,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'Pacifico'
                                                    ),
                                                  ),
                                                  SizedBox(width: 5.w,),
                                                ],
                                              ),
                                              color: cubit.isDark ? ko7ly : superBabyBlue,
                                            ),
                                          );
                                        }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.h,),
                          ],
                        ),
                      ),

                      SizedBox(height: 10.h,),


                      SizedBox(
                        height: 10.h,
                      ),

                      // Posts
                      ConditionalBuilder(
                          condition: cubit.userPosts.isNotEmpty,
                          builder: (context) =>
                              ListView.separated(
                                itemBuilder: (context, index) =>
                                    postBuilder(
                                        context, cubit.userPosts[index],
                                        index, cubit, state),
                                separatorBuilder: (context, index) =>
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                itemCount: cubit.userPosts.length,
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
