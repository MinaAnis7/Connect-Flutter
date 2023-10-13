import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/modules/login_screen.dart';
import 'package:social_app/shared/network/local/cubit/cubit.dart';
import 'package:social_app/shared/network/local/cubit/cubit_states.dart';
import '../layout/layout.dart';
import '../shared/components/components.dart';
import '../shared/style/colors.dart';

class SignUpScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if(state is CreateUserSuccessState)
          {
            navigateAndFinish(context: context, widget: Layout());
          }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: logo,
            titleSpacing: 0.0,
            leading: IconButton(
              onPressed: () {
                navigateAndFinish(context: context, widget: LoginScreen());
              },
              icon: Icon(
                Icons.arrow_back_ios,
              ),
            ),
            actions: [
              IconButton(onPressed: (){} , icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.transparent,
              ),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
              )
            ],
          ),
          backgroundColor: cubit.isDark ? DarkBackground : Colors.white,
          body: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0.w),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20.0.h,
                            ),
                            Text(
                              'Sign Up',
                              style: TextStyle(
                                color: cubit.isDark ? Colors.white : black,
                                fontSize: 30.0.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              height: 10.0.sp,
                            ),
                            Text(
                              'Join With Us And Find Your Community!',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0.sp,
                              ),
                            ),
                            SizedBox(
                              height: 40.0.sp,
                            ),
                            defaultTFF(
                                hintText: 'Your Name',
                                inputColor: cubit.isDark ? Colors.white : Colors.black,
                                borderColor: cubit.isDark ? ko7ly : babyBlue,
                                hintColor: cubit.isDark ? Colors.grey : Colors.grey.shade700,
                                maxLines: 1,
                                color: cubit.isDark ? DarkSurface : superBabyBlue,
                                keyboardType: TextInputType.text,
                                prefixIcon: Icon(Icons.person,
                                color: cubit.isDark ? Colors.grey : Colors.grey.shade700,),
                                controller: nameController,
                                validator: (value) {
                                  if (value != null && value == '')
                                    return 'Name is required!';
                                }),
                            SizedBox(
                              height: 20.0.sp,
                            ),
                            defaultTFF(
                                hintText: 'Choose Email',
                                maxLines: 1,
                                inputColor: cubit.isDark ? Colors.white : Colors.black,
                                borderColor: cubit.isDark ? ko7ly : babyBlue,
                                hintColor: cubit.isDark ? Colors.grey : Colors.grey.shade700,
                                color: cubit.isDark ? DarkSurface : superBabyBlue,
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: Icon(Icons.alternate_email,
                                color: cubit.isDark ? Colors.grey : Colors.grey.shade700,),
                                controller: emailController,
                                validator: (value) {
                                  if (value != null && value == '')
                                    return 'Email is required!';
                                }),
                            SizedBox(
                              height: 20.0.sp,
                            ),
                            defaultTFF(
                                hintText: 'Choose Password',
                                maxLines: 1,
                                inputColor: cubit.isDark ? Colors.white : Colors.black,
                                borderColor: cubit.isDark ? ko7ly : babyBlue,
                                hintColor: cubit.isDark ? Colors.grey : Colors.grey.shade700,
                                color: cubit.isDark ? DarkSurface : superBabyBlue,
                                suffixIcon: cubit.obscureIcon,
                                suffixColor: cubit.isDark ? Colors.grey : Colors.grey.shade700,
                                isObscure: cubit.isObscure,
                                suffixOnPressed: () {
                                  cubit.changeVisibility();
                                },
                                keyboardType: TextInputType.text,
                                prefixIcon: Icon(Icons.alternate_email,
                                color: cubit.isDark ? Colors.grey : Colors.grey.shade700,),
                                controller: passwordController,
                                validator: (value) {
                                  if (value != null && value == '')
                                    return 'Please, Specify your password!';
                                }),
                            SizedBox(
                              height: 20.0.sp,
                            ),
                            defaultTFF(
                                hintText: 'Phone',
                                maxLines: 1,
                                inputColor: cubit.isDark ? Colors.white : Colors.black,
                                borderColor: cubit.isDark ? ko7ly : babyBlue,
                                hintColor: cubit.isDark ? Colors.grey : Colors.grey.shade700,
                                color: cubit.isDark ? DarkSurface : superBabyBlue,
                                keyboardType: TextInputType.phone,
                                prefixIcon: Icon(Icons.phone,
                                  color: cubit.isDark ? Colors.grey : Colors.grey.shade700,),
                                controller: phoneController,
                                validator: (value) {
                                  if (value != null && value == '')
                                    return 'Please, Add Your Phone!';
                                }),
                            SizedBox(
                              height: 20.sp,
                            ),
                            ConditionalBuilder(
                              condition: state is! UserRegisterLoadingState,
                              builder: (context) => defaultButton(
                                color: blue,
                                highlightColor: Colors.lightBlue,
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.userRegister(
                                      nameController.text,
                                      emailController.text,
                                      passwordController.text,
                                      phoneController.text,
                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUzlfySeiXVWcK9aWigruMaOILZBN2YooUMQ&usqp=CAU',
                                      'Hey there! I\'m using Connect.',
                                      'https://wallpaperaccess.com/full/148418.jpg',
                                      0,
                                    );
                                  }
                                },
                                child: Text(
                                  'Create Account'.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15.0.sp),
                                ),
                              ),
                              fallback: (context) => Center(
                                child: CircularProgressIndicator(
                                  color: blue,
                                  strokeWidth: 4.0.sp,
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0.sp),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1.0.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0.w),
                                  child: Text(
                                    'OR',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1.0.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0.sp),
                            defaultButton(
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/google-logo-9808.png',
                                    width: 23.h,
                                    height: 23.h,
                                  ),
                                  SizedBox(
                                    width: 10.0.w,
                                  ),
                                  Text(
                                    'Sign up With Google',
                                    style: TextStyle(
                                      color: cubit.isDark ? Colors.white : black,
                                      fontSize: 15.0.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              color: cubit.isDark ? DarkSurface : superBabyBlue,
                            ),
                          ],
                        ),
                      ),
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
