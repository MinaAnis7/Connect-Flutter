import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_app/modules/notification_screen.dart';
import 'package:social_app/modules/search.dart';
import 'package:social_app/modules/settings.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cubit/cubit.dart';
import 'package:social_app/shared/network/local/cubit/cubit_states.dart';
import '../shared/style/icons/my_icons_icons.dart';

class Layout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {

        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            AppCubit cubit = AppCubit.get(context);

            return Scaffold(
              appBar: AppBar(
                leading: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: logo,
                ),
                leadingWidth: 100.0.sp,
                title: Text(
                  cubit.titles[cubit.currentIndex],
                  style: TextStyle(
                      color: cubit.isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0.sp),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(context,
                        PageTransition(
                          type: PageTransitionType.topToBottom,
                          child: NotificationScreen(),
                        ),
                      );
                    },
                    padding: EdgeInsets.zero,
                    icon: Badge(
                      label: Text(
                          "${cubit.notifications.length}"
                      ),
                      isLabelVisible: cubit.notifications.isNotEmpty,
                      child: FaIcon(FontAwesomeIcons.bell, size: 20.sp,),
                    ),
                  ),

                  if (cubit.currentIndex == 3)
                    IconButton(
                      onPressed: () {
                        Navigator.push(context,
                          PageTransition(
                              type: PageTransitionType.rightToLeftWithFade,
                              child: Settings(),
                              duration: Duration(milliseconds: 200),
                              reverseDuration: Duration(milliseconds: 200)
                          ),
                        );
                      },
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.settings, size: 20.sp, ),
                    ),
                  if (cubit.currentIndex != 3)
                    IconButton(
                      onPressed: () {
                        Navigator.push(context,
                          PageTransition(child: SearchScreen(), type: PageTransitionType.rightToLeft)
                        );
                      },
                      padding: EdgeInsets.zero,
                      icon: Icon(MyIcons.search, size: 20.sp,),
                    ),
                ],
              ),
              body: cubit.screens[cubit.currentIndex],
              bottomNavigationBar: SizedBox(
                height: MediaQuery.of(context).size.height / 11.7,
                child: BottomNavigationBar(
                  items: cubit.navItems,
                  unselectedFontSize: 10.sp,
                  selectedFontSize: 12.sp,
                  iconSize: 20.sp,
                  currentIndex: cubit.currentIndex,
                  onTap: (index) {
                    cubit.changeIndex(index);
                    if (index == 3) {
                      cubit.getUserData();
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
