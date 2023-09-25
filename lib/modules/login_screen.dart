import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/modules/sign_up.dart';
import 'package:social_app/shared/network/local/cubit/cubit.dart';
import 'package:social_app/shared/network/local/cubit/cubit_states.dart';
import 'package:social_app/shared/style/colors.dart';
import '../layout/layout.dart';
import '../shared/components/components.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is UserLoginSuccessState) {
          navigateAndFinish(context: context, widget: Layout());
        }
        if (state is UserLoginErrorState) {
          toastDF(
            context: context,
            title: 'Error',
            describtion: state.error,
            color: Colors.red,
            icon: Icons.error_outline_rounded,
          );
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: logo,
          ),
          backgroundColor: Colors.white,
          body: Container(
            width: double.infinity,
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
                            'Login',
                            style: TextStyle(
                              color: black,
                              fontSize: 36.0.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 10.0.sp,
                          ),
                          Text(
                            'Connect With Those You Love!',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0.sp,
                            ),
                          ),
                          SizedBox(
                            height: 40.0.sp,
                          ),
                          defaultTFF(
                              hintText: 'Email',
                              maxLines: 1,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icon(Icons.alternate_email),
                              controller: emailController,
                              validator: (value) {
                                if (value != null && value == '')
                                  return 'Email is required';
                              }),
                          SizedBox(
                            height: 20.0.sp,
                          ),
                          defaultTFF(
                              hintText: 'password',
                              maxLines: 1,
                              suffixIcon: cubit.obscureIcon,
                              isObscure: cubit.isObscure,
                              suffixOnPressed: () {
                                cubit.changeVisibility();
                              },
                              keyboardType: TextInputType.text,
                              prefixIcon: Icon(Icons.lock_rounded),
                              controller: passwordController,
                              validator: (value) {
                                if (value != null && value == '')
                                  return 'Password is required';
                              }),
                          SizedBox(
                            height: 20.0.sp,
                          ),
                          ConditionalBuilder(
                            condition: state is! UserLoginLoadingState,
                            builder: (context) => defaultButton(
                              color: blue,
                              highlightColor: Colors.lightBlue,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  cubit.userLogin(
                                    emailController.text,
                                    passwordController.text,
                                  );
                                }
                              },
                              child: Text(
                                'login'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15.0.sp),
                              ),
                            ),
                            fallback:(context) =>  Center(
                              child: CircularProgressIndicator(
                                color: blue,
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
                                  'Login With Google',
                                  style: TextStyle(
                                    color: black,
                                    fontSize: 15.0.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            color: superBabyBlue,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.0.sp,
                        ),
                      ),
                      SizedBox(
                        width: 5.0.w,
                      ),
                      TextButton(
                        onPressed: () {
                          navigateTo(
                            context: context,
                            widget: SignUpScreen(),
                          );
                        },
                        child: Text(
                          'Register Now',
                          style: TextStyle(
                              fontSize: 14.0.sp, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
