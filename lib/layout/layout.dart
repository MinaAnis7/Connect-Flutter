import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cubit/cubit.dart';
import 'package:social_app/shared/network/local/cubit/cubit_states.dart';
import '../shared/style/icons/my_icons_icons.dart';

class Layout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0.sp),
            ),
            actions: [
              IconButton(
                onPressed: () {
                },
                icon: FaIcon(FontAwesomeIcons.bell),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(MyIcons.search),
              ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: SizedBox(
            height: MediaQuery.of(context).size.height / 13,
            child: BottomNavigationBar(
              items: cubit.navItems,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
                if(index == 3) {
                  cubit.getUserData();
                }
              },
            ),
          ),
        );
      },
    );
  }
}
