import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_app/shared/network/local/cubit/cubit.dart';

import '../shared/network/local/cubit/cubit_states.dart';
import '../shared/style/colors.dart';
import '../shared/style/icons/my_icons_icons.dart';

class CreatePost extends StatelessWidget {
  final TextEditingController postTextController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        return WillPopScope(
          onWillPop: () async {
            cubit.postImage = null;
            cubit.createdTags = [];
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  cubit.postImage = null;
                  cubit.createdTags = [];
                  Navigator.pop(context);
                },
                icon: FaIcon(FontAwesomeIcons.arrowLeft),
              ),
              title: Text(
                'Create Post',
                style: TextStyle(
                    color: cubit.isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0.sp),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    cubit.createPost(
                        text: postTextController.text, context: context);
                  },
                  child: Text(
                    'POST',
                    style: TextStyle(
                      color: blue,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 5.w,
                )
              ],
            ),
            backgroundColor: cubit.isDark ? DarkBackground : Colors.white,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    if (state is CreatePostLoadingState)
                      Column(
                        children: [
                          LinearProgressIndicator(
                            color: blue,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                        ],
                      ),
                    // Image & Name
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: superBabyBlue,
                          backgroundImage: NetworkImage(cubit.userModel!.image),
                        ),

                        SizedBox(
                          width: 10.w,
                        ),

                        // Name
                        Column(
                          children: [
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              cubit.userModel!.name,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: cubit.isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 10.h,
                    ),

                    // Post Text&Tags&Image
                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Post Text or Caption
                            TextFormField(
                              controller: postTextController,
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: 'Share Your Thoughts...',
                                hintStyle: TextStyle(
                                  color: cubit.isDark ? Colors.grey  : Colors.grey.shade700,
                                ),
                                border: InputBorder.none,
                              ),
                            ),

                            // Post Tags
                            if(cubit.createdTags != 0)
                              Column(
                                children: [
                                  SizedBox(height: 10.h,),
                                  Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                                        child: Wrap(
                                          children: List.generate(
                                            cubit.createdTags.length,
                                                (index) => InkWell(
                                              child: Text(
                                                '#' + cubit.createdTags[index],
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
                                ],
                              ),

                            SizedBox(
                              height: 10.h,
                            ),

                            // Post Image
                            if (cubit.postImage != null)
                              Container(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height / 2,
                                ),
                                child: Image(
                                  image: FileImage(
                                    cubit.postImage!,
                                  ),
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 10.h),

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
                              },
                              borderRadius: BorderRadius.circular(5.sp),
                              child: Row(
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
                                        fontSize: 14.sp, color: Colors.grey),
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
                              borderRadius: BorderRadius.circular(5.sp),
                              onTap: () {
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
                                                  controller: tagsController,
                                                  decoration: InputDecoration(
                                                    hintText: 'Add a Tag',
                                                    border: InputBorder.none,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  cubit.addTag(tagsController.text);
                                                  tagsController.text = '';
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor: blue,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10.sp),
                                                  )
                                                ),
                                                child: FaIcon(
                                                  FontAwesomeIcons.plus,
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
                                        fontSize: 14.sp, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Documents
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0.sp),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(5.sp),
                              onTap: () {},
                              child: Row(
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
                                          fontSize: 12.sp, color: Colors.grey),
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
                      height: 10.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
