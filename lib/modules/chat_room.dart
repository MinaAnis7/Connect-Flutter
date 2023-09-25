import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/network/local/cache/cache_helper.dart';
import 'package:social_app/shared/network/local/cubit/cubit.dart';
import 'package:social_app/shared/style/colors.dart';
import '../shared/components/components.dart';
import '../shared/network/local/cubit/cubit_states.dart';
import 'package:flutter/foundation.dart' as foundation;

class ChatRoom extends StatelessWidget {
  final UserModel receiver;
  final TextEditingController messageController = TextEditingController();

  ChatRoom(this.receiver);

  _onBackspacePressed() {
    messageController
      ..text = messageController.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: messageController.text.length));
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        AppCubit.get(context).getMessages(receiver.id);

        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            AppCubit cubit = AppCubit.get(context);

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if(cubit.emojiIsNotVisible == false)
                    {
                      cubit.changeEmojiVisibility();
                    }
                  },
                  icon: Icon(Icons.arrow_back_ios),
                ),
                titleSpacing: 0,
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: superBabyBlue,
                      backgroundImage: NetworkImage(
                        receiver.image,
                      ),
                      radius: 22.sp,
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    Expanded(
                      child: Text(
                        receiver.name,
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  if(cubit.emojiIsNotVisible == false)
                    cubit.changeEmojiVisibility();
                },
                child: SafeArea(
                  child: Column(
                    children: [
                      // Messages
                      Expanded(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 15.w,),
                            child: ConditionalBuilder(
                              condition: cubit.messages.isNotEmpty,
                              builder:(context) => ListView.builder(
                                itemBuilder: (context, index) {
                                  String message = cubit.messages[index].message;

                                  if(cubit.messages[index].senderId == CacheHelper.getData('userId'))
                                    return myMessage(message);
                                  else
                                    return recipientMessage(message);
                                },
                                itemCount: cubit.messages.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                              ),
                              fallback:(context) => Center(child: Text(
                                'No Messages.',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.grey,
                                ),
                              ),),
                            ),
                          )),

                      // Typing Section
                      Padding(
                        padding: EdgeInsets.all(15.h,),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // TFF
                            Expanded(
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.all(Radius.circular(17.sp)),
                                  ),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      prefixIcon: MaterialButton(
                                        onPressed: () async {
                                          FocusScope.of(context).unfocus();
                                          await Future.delayed(Duration(milliseconds: 100,));
                                          cubit.changeEmojiVisibility();
                                        },
                                        minWidth: 40.w,
                                        padding: EdgeInsets.zero,
                                        child: Icon(
                                          Icons.tag_faces_outlined,
                                          size: 26.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 5.w,),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(17.sp),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: superBabyBlue,
                                      hintText: 'Your Message...',
                                    ),
                                    minLines: 1,
                                    controller: messageController,
                                    maxLines: 5,
                                    onTap: () {
                                      if(cubit.emojiIsNotVisible == false)
                                      {
                                        cubit.changeEmojiVisibility();
                                      }
                                    },
                                  ),
                                )
                            ),

                            SizedBox(width: 10.w,),

                            // Send Button
                            Column(
                              children: [
                                MaterialButton(
                                  onPressed: (){
                                    if(messageController.text == '')
                                    {
                                      errorMsg('Please type Something');
                                    }
                                    else
                                    {
                                      cubit.sendMessage(messageController.text, receiver.id);
                                      messageController.text = '';
                                    }
                                  },
                                  elevation: 5,
                                  highlightColor: Colors.blue[300],
                                  padding: EdgeInsets.zero,
                                  color: blue,
                                  shape: CircleBorder(),
                                  minWidth: 40.sp,
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0.sp),
                                    child: Icon(
                                      CupertinoIcons.paperplane_fill,
                                      color: Colors.white,
                                      size: 25.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 1.h,),
                              ],
                            )
                          ],
                        ),
                      ),

                      // Emoji Keyboard
                      WillPopScope(
                        onWillPop: () async {
                          if(cubit.emojiIsNotVisible == false)
                          {
                            cubit.changeEmojiVisibility();
                            return false;
                          }
                          else
                            return true;
                        },
                        child: Offstage(
                          offstage: cubit.emojiIsNotVisible,
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height / 2.9,
                              child: EmojiPicker(
                                textEditingController: messageController,
                                onBackspacePressed: _onBackspacePressed,
                                config: Config(
                                  columns: 7,
                                  emojiSizeMax: 32 *
                                      (foundation.defaultTargetPlatform ==
                                          TargetPlatform.iOS
                                          ? 1.30
                                          : 1.0),
                                  verticalSpacing: 0,
                                  horizontalSpacing: 0,
                                  gridPadding: EdgeInsets.zero,
                                  initCategory: Category.RECENT,
                                  bgColor: superBabyBlue,
                                  indicatorColor: Colors.blue,
                                  iconColor: Colors.grey,
                                  iconColorSelected: blue,
                                  backspaceColor: blue,
                                  skinToneDialogBgColor: Colors.white,
                                  skinToneIndicatorColor: Colors.grey,
                                  enableSkinTones: true,
                                  recentTabBehavior: RecentTabBehavior.RECENT,
                                  recentsLimit: 28,
                                  replaceEmojiOnLimitExceed: false,
                                  noRecents: const Text(
                                    'No Recents',
                                    style: TextStyle(fontSize: 20, color: Colors.black26),
                                    textAlign: TextAlign.center,
                                  ),
                                  loadingIndicator: const SizedBox.shrink(),
                                  tabIndicatorAnimDuration: kTabScrollDuration,
                                  categoryIcons: const CategoryIcons(),
                                  buttonMode: ButtonMode.MATERIAL,
                                  checkPlatformCompatibility: true,
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              backgroundColor: Colors.white,
            );
          },
        );
      },
    );
  }

  Widget myMessage(String message)
  {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(15.sp),
        margin: EdgeInsets.only(
          top: 15.h,
        ),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: blue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.sp),
            topRight: Radius.circular(15.sp),
            bottomLeft: Radius.circular(15.sp),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
          ),
          maxLines: null,
        ),
      ),
    );
  }

  Widget recipientMessage(String message)
  {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(15.sp),
        margin: EdgeInsets.only(
          top: 15.h,
        ),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: babyBlue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.sp),
            topRight: Radius.circular(15.sp),
            bottomRight: Radius.circular(15.sp),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15.sp,
          ),
          maxLines: null,
        ),
      ),
    );
  }

}
