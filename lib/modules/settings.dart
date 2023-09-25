import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cubit/cubit.dart';
import 'package:social_app/shared/network/local/cubit/cubit_states.dart';

class Settings extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: TextButton(
                  onPressed: () {
                  cubit.signOut();
                  navigateAndFinish(context: context, widget: LoginScreen());
                },
                  child: Text("Sign out"),
              ),
            ),
          ),
        );
      }
    );
  }
}
