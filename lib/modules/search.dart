import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/user_profile.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache/cache_helper.dart';
import 'package:social_app/shared/network/local/cubit/cubit.dart';
import 'package:social_app/shared/network/local/cubit/cubit_states.dart';

import '../shared/style/colors.dart';

class SearchScreen extends StatelessWidget {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {

      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: TextField(
              controller: searchController,
              onChanged: (value) {
                cubit.changeName(value);
              },
              style: TextStyle(
                color: cubit.isDark ? Colors.white : Colors.black,
                fontSize: 14.sp,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                isDense: true,
                prefixIconColor: cubit.isDark ? Colors.grey : Colors.grey.shade700,
                hintText: "Search",
                hintStyle: TextStyle(
                  color: cubit.isDark ? Colors.grey : Colors.grey.shade700,
                ),

              ),
            ),
          ),

          body: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  return (snapshot.connectionState == ConnectionState.waiting) ?
                      Center(child: CircularProgressIndicator(color: blue, strokeWidth: 3.sp,),)
                      : ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      UserModel user = UserModel.fromJson(
                          snapshot.data!.docs[index].data()
                          as Map<String, dynamic>);

                      if (cubit.name.isEmpty)
                        return searchItemBuilder(cubit, user, context);
                      if (user.name.toLowerCase().startsWith(cubit.name.toLowerCase()))
                        return searchItemBuilder(cubit, user, context);

                      return Container();
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 15.h,),
                    itemCount: snapshot.data!.docs.length,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }


  Widget searchItemBuilder(AppCubit cubit, UserModel user, BuildContext context)
  {
    return InkWell(
      onTap: () {
        if(user.id == CacheHelper.getData('userId'))
          {
            Navigator.pop(context);
            cubit.changeIndex(3);
          }
        else
          {
            navigateTo(context: context, widget: UserProfile(user));
            cubit.getUserPosts(user);
          }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          CircleAvatar(
            backgroundImage: NetworkImage(user.image),
            radius: 22.sp,
          ),

          SizedBox(width: 10.w,),

          // Name & Number of connections
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              Text(
                user.name,
                style: TextStyle(
                  color: cubit.isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,

                ),
              ),

              // Number of connections
              Text(
                "${user.numOfConnects} Connections",
                style: TextStyle(
                  color: cubit.isDark ? Colors.grey : Colors.grey.shade700,
                  fontSize: 14.sp,

                ),
              ),


            ],
          )
        ],
      ),
    );
  }
}
