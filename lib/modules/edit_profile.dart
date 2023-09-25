import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cubit/cubit.dart';
import 'package:social_app/shared/network/local/cubit/cubit_states.dart';
import '../shared/style/colors.dart';
import '../shared/style/icons/my_icons_icons.dart';

class EditProfile extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController bioController = new TextEditingController();

  EditProfile({
    required String name,
    required String phone,
    required String bio,
})
  {
    nameController.text = name;
    phoneController.text = phone;
    bioController.text = bio;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        return WillPopScope(
          onWillPop: () async {
            cubit.image = null;
            cubit.cover = null;
            return true;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  cubit.image = null;
                  cubit.cover = null;
                  Navigator.pop(context);
                },
                icon: FaIcon(FontAwesomeIcons.arrowLeft),
              ),
              title: Text(
                'Edit profile',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0.sp),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    cubit.updateUserProfile(
                        name: nameController.text,
                        phone: phoneController.text,
                        bio: bioController.text,
                    );
                  },
                  child: Text(
                    'UPDATE',
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
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    if (state is UpdateUserProfileLoadingState)
                      Column(
                        children: [
                          LinearProgressIndicator(color: blue,),
                          SizedBox(height: 5.h,)
                        ],
                      ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Cover & Profile Image
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.sp),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: height / 3.5,
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        // Cover Image
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.sp),
                                                // Cover: From Gallery or From Database
                                                child: ConditionalBuilder(
                                                  condition:
                                                      cubit.cover != null,
                                                  builder: (context) =>
                                                      Image.file(
                                                    cubit.cover!,
                                                    fit: BoxFit.cover,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            4.5,
                                                    width: double.infinity,
                                                  ),
                                                  fallback: (context) => Image(
                                                    image: NetworkImage(
                                                        cubit.userModel!.cover),
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            4.5,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              // Edit Cover
                                              Padding(
                                                padding: EdgeInsets.all(3.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    ImagePicker()
                                                        .pickImage(
                                                            source: ImageSource
                                                                .gallery)
                                                        .then((value) {
                                                      cubit.cover =
                                                          File(value!.path);
                                                      cubit.changeImageState();
                                                    });
                                                  },
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.white,
                                                    radius: 16.sp,
                                                    child: Icon(
                                                      MyIcons.pencil_1,
                                                      color: blue,
                                                      size: 20.sp,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        //Profile Image
                                        Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 52.sp,
                                                    backgroundColor:
                                                        superBabyBlue,
                                                  ),
                                                  CircleAvatar(
                                                    radius: 50.sp,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: ConditionalBuilder(
                                                      condition:
                                                          cubit.image != null,
                                                      builder: (context) =>
                                                          CircleAvatar(
                                                        radius: 50.sp,
                                                        backgroundColor:
                                                            Colors.white,
                                                        backgroundImage:
                                                            FileImage(
                                                                cubit.image!),
                                                      ),
                                                      fallback: (context) =>
                                                          CircleAvatar(
                                                        radius: 50.sp,
                                                        backgroundColor:
                                                            Colors.white,
                                                        backgroundImage:
                                                            NetworkImage(cubit
                                                                .userModel!
                                                                .image),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                            // Update Profile
                                            InkWell(
                                              onTap: () {
                                                ImagePicker()
                                                    .pickImage(
                                                        source:
                                                            ImageSource.gallery)
                                                    .then((value) {
                                                  cubit.image =
                                                      File(value!.path);
                                                  cubit.changeImageState();
                                                });
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: 15.sp,
                                                child: Icon(
                                                  MyIcons.camera,
                                                  color: blue,
                                                  size: 20.sp,
                                                ),
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
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),

                            Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: Text(
                                'Edit Your Info:',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 10.h,
                            ),
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  defaultTFF(
                                    hintText: 'Edit Name',
                                    keyboardType: TextInputType.text,
                                    prefixIcon: Icon(MyIcons.user_1),
                                    validator: (value) {
                                      if (value != null && value != '')
                                        return 'Please, Enter Your Name!';
                                    },
                                    controller: nameController,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  defaultTFF(
                                    hintText: 'Edit Phone',
                                    keyboardType: TextInputType.phone,
                                    prefixIcon: Icon(MyIcons.phone_handset),
                                    validator: (value) {
                                      if (value != null && value != '')
                                        return 'Please, Enter Your phone!';
                                    },
                                    controller: phoneController,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  defaultTFF(
                                    hintText: 'Edit Bio',
                                    keyboardType: TextInputType.text,
                                    prefixIcon: Icon(FontAwesomeIcons.info),
                                    validator: (value) {
                                      if (value != null && value != '')
                                        return 'Please, Enter Your Bio!';
                                    },
                                    controller: bioController,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Update Buttons
                    Row(
                      children: [
                        //Update Profile Picture
                        if (cubit.image != null)
                          ConditionalBuilder(
                            condition: state is StoreImageLoadingState,
                            builder: (context) => Expanded(
                                child: Center(
                              child: CircularProgressIndicator(
                                color: blue,
                              ),
                            )),
                            fallback: (context) => Expanded(
                              child: defaultButton(
                                  onPressed: () {
                                    cubit.updateProfile();
                                  },
                                  child: Text(
                                    'UPDATE PROFILE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  color: blue),
                            ),
                          ),

                        SizedBox(
                          width: 10.w,
                        ),

                        if (cubit.cover != null)
                          ConditionalBuilder(
                            condition: state is StoreCoverLoadingState,
                            builder: (context) => Expanded(
                                child: Center(
                              child: CircularProgressIndicator(
                                color: blue,
                              ),
                            )),
                            fallback: (context) => Expanded(
                              child: defaultButton(
                                onPressed: () {
                                  cubit.updateCover();
                                },
                                child: Text(
                                  'UPDATE COVER',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.sp,
                                  ),
                                ),
                                color: blue,
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
