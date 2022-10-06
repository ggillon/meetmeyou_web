import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meetmeyou_web/constants/color_constants.dart';
import 'package:meetmeyou_web/constants/dimension_constants.dart';
import 'package:meetmeyou_web/constants/image_constants.dart';
import 'package:meetmeyou_web/constants/route_constants.dart';
import 'package:meetmeyou_web/helper/dialog_helper.dart';
import 'package:meetmeyou_web/extensions/all_extensions.dart';
import 'package:meetmeyou_web/helper/date_time_helper.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/main.dart';
import 'package:meetmeyou_web/models/event.dart';
import 'package:meetmeyou_web/widgets/image_view.dart';
import 'dart:html' as html;

import 'package:url_launcher/url_launcher.dart';

class CommonWidgets{



 static Widget commonAppBar(BuildContext context, bool navigate, {String? routeName, String? userName, Function? onTapLogout}){
    return Card(
        margin: EdgeInsets.zero,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: DimensionConstants.d18.h, horizontal: DimensionConstants.d10.w),
            width: double.infinity,
            height: DimensionConstants.d75.h,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: DimensionConstants.d80.w,
                    alignment: Alignment.centerLeft,
                    child: ImageView(path: ImageConstants.webLogo, width: DimensionConstants.d80.w,)),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child:  Text(userName == null ? "Welcome" : "Welcome $userName")
                        .semiBoldText(ColorConstants.colorBlack,
                        DimensionConstants.d16.sp, TextAlign.left),
                  ),
                ),
                Container(
                  width: DimensionConstants.d80.w,
                  alignment: Alignment.centerRight,
                  child: PopupMenuButton<int>(
                    itemBuilder: (context) => [
                      // PopupMenuItem 1
                      PopupMenuItem(
                        value: 1,
                        child: Text("view_edit_profile".tr())
                            .mediumText(ColorConstants.primaryColor,
                            DimensionConstants.d14.sp, TextAlign.left),
                      ),
                      // PopupMenuItem 2
                      PopupMenuItem(
                        value: 2,
                        child:  Text("logout".tr())
                            .mediumText(ColorConstants.colorBlack,
                            DimensionConstants.d14.sp, TextAlign.left),
                      ),
                    ],
                    offset: const Offset(0, 50),
                    color: Colors.white,
                    elevation: 2,
                    icon: Icon(Icons.menu, color: ColorConstants.primaryColor, size: 30),
                    onSelected: (value) {
                      if (value == 1) {
                        if(navigate){
                          context.go(routeName!);
                        }
                      } else if (value == 2) {
                      }
                    },
                  ),
                ),
              ],
            ))
    );
  }

 static Widget respondBtn(BuildContext context, String txt,
     Color bgColor, Color txtColor,
     {VoidCallback? onTapFun, double? txtSize, double? width, double? height, var padding}) {
   return GestureDetector(
       onTap: onTapFun,
       child: Container(
         height: height ?? DimensionConstants.d40.h,
         width: width ?? double.infinity,
         alignment: Alignment.center,
         padding: padding ?? EdgeInsets.symmetric(horizontal: DimensionConstants.d10.w, vertical: DimensionConstants.d5.h),
         decoration: BoxDecoration(
             borderRadius:BorderRadius.circular(DimensionConstants.d8.r),
             color: bgColor
           // border: Border.all(
           //   color: ColorConstants.colorBlack.withOpacity(0.2),
           //   width: 1.0,
           // ),
         ),
         child: Text(txt)
             .mediumText(txtColor, txtSize ?? DimensionConstants.d15.sp, TextAlign.center),
       )
   );
 }

 static Widget imageView(BuildContext context, String photoUrl) {
   return Card(
     margin: EdgeInsets.zero,
     shadowColor: ColorConstants.colorWhite,
     elevation: 5.0,
     shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.only(
             bottomLeft: Radius.circular(DimensionConstants.d12.r),
             bottomRight: Radius.circular(DimensionConstants.d12.r))),
     color: ColorConstants.colorLightGray,
     child: SizedBox(
       height: MediaQuery.of(context).size.width > 1050
           ? DimensionConstants.d325.h
           : DimensionConstants.d300.h,
       width: double.infinity,
       child: ClipRRect(
         borderRadius: BorderRadius.only(
             bottomLeft: Radius.circular(DimensionConstants.d12.r),
             bottomRight: Radius.circular(DimensionConstants.d12.r)),
         child: photoUrl == ""
             ? ImageView(
           path: DEFAULT_EVENT_PHOTO_URL,
           fit: BoxFit.cover,
           height: DimensionConstants.d50.h,
           width: double.infinity,
         )
             : ImageView(
           path: photoUrl,
           fit: BoxFit.cover,
           height: DimensionConstants.d50.h,
           width: double.infinity,
         ),
       ),
     ),
   );
 }

 static Widget titleDateLocationCard(BuildContext context, String eventTitle, DateTime startDate, DateTime endDate, String location, String organiserName) {
   return Container(
     // width: DimensionConstants.d200.w,
     padding: EdgeInsets.symmetric(horizontal: DimensionConstants.d5.w),
     child: Card(
         shadowColor: ColorConstants.colorWhite,
         elevation: 5.0,
         shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(DimensionConstants.d12.r)),
         child: Padding(
           padding: EdgeInsets.symmetric(horizontal: DimensionConstants.d5.w, vertical: DimensionConstants.d10.h),
           child: Row(
             //  mainAxisSize: MainAxisSize.min,
             children: [
               dateCard(startDate),
               SizedBox(width: DimensionConstants.d5.w),
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   SizedBox(
                     width: MediaQuery.of(context).size.width > 1050 ? DimensionConstants.d175.w :  DimensionConstants.d225.w,
                     child: Text(eventTitle)
                         .boldText(ColorConstants.colorBlack,
                         DimensionConstants.d15.sp, TextAlign.left,
                         maxLines: 1, overflow: TextOverflow.ellipsis),
                   ),
                   SizedBox(height: DimensionConstants.d6.h),
                   Row(
                     children: [
                       const ImageView(path: ImageConstants.event_clock_icon),
                       SizedBox(width: DimensionConstants.d5.w),
                       SizedBox(
                         width:  MediaQuery.of(context).size.width > 1050 ? DimensionConstants.d150.w : DimensionConstants.d200.w,
                         child: Text(
                             (startDate.toString().substring(0, 11)) ==
                                 (endDate
                                     .toString()
                                     .substring(0, 11))
                                 ? DateTimeHelper.getWeekDay(startDate) +
                                 " - " +
                                 DateTimeHelper.convertEventDateToTimeFormat(
                                     startDate) +
                                 " to " +
                                 DateTimeHelper.convertEventDateToTimeFormat(
                                     endDate)
                                 : DateTimeHelper.getWeekDay(startDate) +
                                 " - " +
                                 DateTimeHelper.convertEventDateToTimeFormat(startDate) +
                                 " to " +
                                 DateTimeHelper.dateConversion(endDate) +
                                 " ( ${DateTimeHelper.convertEventDateToTimeFormat(endDate)})")
                             .regularText(ColorConstants.colorGray, DimensionConstants.d12.sp, TextAlign.left, maxLines: 1, overflow: TextOverflow.ellipsis),
                       )
                     ],
                   ),
                   SizedBox(height: DimensionConstants.d6.h),
                   Row(
                     children: [
                       const ImageView(path: ImageConstants.map),
                       SizedBox(width: DimensionConstants.d5.w),
                       SizedBox(
                         width:  MediaQuery.of(context).size.width > 1050 ? DimensionConstants.d150.w : DimensionConstants.d200.w,
                         child: Text(location)
                             .regularText(ColorConstants.colorGray,
                             DimensionConstants.d12.sp, TextAlign.left,
                             maxLines: 2, overflow: TextOverflow.ellipsis),
                       ),
                     ],
                   ),
                   SizedBox(height: DimensionConstants.d5.h),
                   Row(
                     children: [
                       const ImageView(path: ImageConstants.personIcon),
                       SizedBox(width: DimensionConstants.d5.w),
                       SizedBox(
                         width:  MediaQuery.of(context).size.width > 1050 ? DimensionConstants.d150.w : DimensionConstants.d200.w,
                         child: Text("$organiserName (${"organiser".tr()})")
                             .regularText(ColorConstants.colorGray,
                             DimensionConstants.d12.sp, TextAlign.left,
                             maxLines: 1, overflow: TextOverflow.ellipsis),
                       ),
                     ],
                   )
                 ],
               ),
             ],
           ),
         )),
   );
 }

 static Widget dateCard(DateTime startDate) {
   return Card(
     shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(DimensionConstants.d12.r)),
     child: Container(
       decoration: BoxDecoration(
           color: ColorConstants.primaryColor.withOpacity(0.2),
           borderRadius:BorderRadius.circular(DimensionConstants.d12.r) // use instead of BorderRadius.all(Radius.circular(20))
       ),
       padding: EdgeInsets.symmetric(horizontal: DimensionConstants.d10.w, vertical: DimensionConstants.d10.h),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Text(DateTimeHelper.getMonthByName(startDate))
               .regularText(ColorConstants.primaryColor,
               DimensionConstants.d15.sp, TextAlign.center),
           Text(startDate.day <= 9 ? "0${startDate.day.toString()}" : startDate.day.toString())
               .boldText(ColorConstants.primaryColor, DimensionConstants.d14.sp,
               TextAlign.center)
         ],
       ),
     ),
   );
 }

  static Widget appPlayStoreBtn(BuildContext context){
   return Row(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
       MediaQuery.of(context).size.width > 900 ? GestureDetector(
           onTap: (){
             html.window.open('https://apps.apple.com/ke/app/meetmeyou/id1580553300', 'new tab');
           },
           child: ImageView(path: ImageConstants.appStore, height: DimensionConstants.d40.h, width: DimensionConstants.d40.w, fit: BoxFit.contain,))
           : GestureDetector(
           onTap: (){
             html.window.open('https://apps.apple.com/ke/app/meetmeyou/id1580553300', 'new tab');
           },
           child: ImageView(path: ImageConstants.appStore, height: DimensionConstants.d60.h, width: DimensionConstants.d75.w, fit: BoxFit.contain,)),
       SizedBox(width: DimensionConstants.d5.w),
       MediaQuery.of(context).size.width > 900 ? GestureDetector(
           onTap: (){
             html.window.open('https://play.google.com/store/apps/details?id=com.meetmeyou.meetmeyou&gl=GB', 'new tab1');
           },
           child: ImageView(path: ImageConstants.googleStore, height: DimensionConstants.d40.h, width: DimensionConstants.d40.w, fit: BoxFit.contain,))
           : GestureDetector(
           onTap: (){
             html.window.open('https://play.google.com/store/apps/details?id=com.meetmeyou.meetmeyou&gl=GB', 'new tab1');
           },
           child: ImageView(path: ImageConstants.googleStore, height: DimensionConstants.d60.h, width: DimensionConstants.d75.w, fit: BoxFit.contain))
     ],
   );
 }

 static launchURL(BuildContext context, var url)async{
   if (await canLaunchUrl(url)) {
     await launchUrl(url);
   } else {
     DialogHelper.showMessage(context, "could not launch $url");
   }
 }

 static Widget footer(){
   return Container(
     color: const Color(0XFF333333),
     height: DimensionConstants.d75,
     width: double.infinity,
     alignment: Alignment.center,
     child: Row(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         Icon(Icons.copyright, color: ColorConstants.colorWhite, size: 15,),
         SizedBox(width: DimensionConstants.d1.w),
         const Text("MeetMeYou,  2021").regularText(
             ColorConstants.colorWhite,
             DimensionConstants.d12.sp,
             TextAlign.left),
       ],
     ),
   );
 }

 /// user profile card~~~~~~~~
 ///
 static Widget userContactCard(BuildContext context, String email, String contactName,
     {String? profileImg,
       String? searchStatus,
       bool search = false,
       VoidCallback? addIconTapAction,
       VoidCallback? deleteIconTapAction,
       bool invitation = false, bool currentUser = false, bool? isFavouriteContact}) {
   return Column(children: [
     Card(
       color: invitation
           ? ColorConstants.primaryColor
           :  currentUser == true ? ColorConstants.colorNewGray.withOpacity(0.3) : ColorConstants.colorWhite,
       elevation: 3.0,
       shadowColor: currentUser == true ? ColorConstants.colorNewGray.withOpacity(0.1) : ColorConstants.colorWhite,
       shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.all(Radius.circular(DimensionConstants.d10.r))),
       child: Padding(
         padding: const EdgeInsets.all(DimensionConstants.d10),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             profileCardImageDesign(context, profileImg!),
             SizedBox(width: DimensionConstants.d8.w),
             profileCardNameAndEmailDesign(contactName, email,
                 search: true, searchStatus: searchStatus, isFavouriteContact: isFavouriteContact),
             // currentUser == true ? Container() : iconStatusCheck(
             //     searchStatus: search ? searchStatus : "",
             //     addIconTap: search ? addIconTapAction : () {},
             //     deleteIconTap: search ? deleteIconTapAction ?? () {} : () {}
             //)
           ],
         ),
       ),
     ),
     SizedBox(height: DimensionConstants.d5.h)
   ]);
 }

 static Widget profileCardImageDesign(BuildContext context, String profileImg) {
   return Stack(
     clipBehavior: Clip.none,
     children: [
       ClipRRect(
           borderRadius: BorderRadius.all(Radius.circular(DimensionConstants.d10.r)),
           child: profileImg == null
               ? Container(
             color: ColorConstants.primaryColor,
             width: MediaQuery.of(context).size.width > 800 ? DimensionConstants.d90 : DimensionConstants.d60,
             height: MediaQuery.of(context).size.width > 800 ? DimensionConstants.d90 : DimensionConstants.d60,
           )
               : Container(
             width: MediaQuery.of(context).size.width > 800 ? DimensionConstants.d90 : DimensionConstants.d60,
             height: MediaQuery.of(context).size.width > 800 ? DimensionConstants.d90 : DimensionConstants.d60,
             child: ImageView(
               path: profileImg,
               width: MediaQuery.of(context).size.width > 800 ? DimensionConstants.d90 : DimensionConstants.d60,
               height: MediaQuery.of(context).size.width > 800 ? DimensionConstants.d90 : DimensionConstants.d60,
               // fit: BoxFit.contain,
             ),
           )),
       const Positioned(
           top: 25,
           right: -5,
           child: ImageView(path: ImageConstants.small_logo_icon))
     ],
   );
 }

 static Widget profileCardNameAndEmailDesign(
     String contactName, String email,
     {bool search = false, String? searchStatus, bool? isFavouriteContact}) {
   return Expanded(
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Row(
           children: [
             Text(contactName.capitalize()).semiBoldText(ColorConstants.colorBlack,
                 DimensionConstants.d14.sp, TextAlign.left,
                 maxLines: 1, overflow: TextOverflow.ellipsis),
             isFavouriteContact == true ?  Icon(Icons.star, color: ColorConstants.primaryColor, size: 20,) : Container()
           ],
         ),
         SizedBox(height: DimensionConstants.d5.h),
         Text(emailOrTextStatusCheck(searchStatus ?? "", email)).regularText(
             ColorConstants.colorBlackDown,
             DimensionConstants.d11.sp,
             TextAlign.left,
             maxLines: 1,
             overflow: TextOverflow.ellipsis),
       ],
     ),
   );
 }

 static Widget iconStatusCheck(
     {String? searchStatus,
       VoidCallback? addIconTap,
       VoidCallback? deleteIconTap}) {
   if (searchStatus == "Listed profile") {
     return GestureDetector(
       onTap: addIconTap,
       child: CircleAvatar(
           backgroundColor: ColorConstants.colorGray,
           radius: 12,
           child: const ImageView(path: ImageConstants.small_add_icon)),
     );
   } else if (searchStatus == "Confirmed contact") {
     return Container();
   } else if (searchStatus == "Invited contact") {
     return GestureDetector(
       onTap: () {},
       child: const ImageView(path: ImageConstants.invited_waiting_icon),
     );
   } else if (searchStatus == "Event Edit") {
     return GestureDetector(
       // onTap: deleteIconTap,
         child: const ImageView(path: ImageConstants.contact_arrow_icon)
       //ImageView(path: ImageConstants.event_remove_icon),
     );
   } else {
     return const ImageView(path: ImageConstants.contact_arrow_icon);
   }
 }

 static emailOrTextStatusCheck(String searchStatus, String email) {
   if (searchStatus == "Listed profile") {
     return "click_+_to_send_invitation".tr();
   } else if (searchStatus == "Confirmed contact") {
     return "already_a_contact".tr();
   } else if (searchStatus == "Invited contact") {
     return "invitation_waiting_reply".tr();
   } else {
     return email;
   }
 }


 static Widget welcomeCommonAppBar(BuildContext context, {String? userName}){
   return Card(
       margin: EdgeInsets.zero,
       child: Container(
           padding: EdgeInsets.symmetric(vertical: DimensionConstants.d18.h, horizontal: DimensionConstants.d10.w),
           width: double.infinity,
           height: DimensionConstants.d75.h,
           alignment: Alignment.centerLeft,
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               MediaQuery.of(context).size.width > 500 ? Container(width: DimensionConstants.d80.w,
                   alignment: Alignment.centerLeft,
                   child: ImageView(path: ImageConstants.webLogo, width: DimensionConstants.d80.w,)) :
               GestureDetector(
                   onTap: () async {},
                   child: ImageView(path: ImageConstants.mobileLogo, width: DimensionConstants.d80.w,)),
               Expanded(
                 child: Container(
                   alignment: Alignment.center,
                   child:  Text(userName == null ? "Welcome" : "Welcome $userName")
                       .semiBoldText(ColorConstants.colorBlack,
                       DimensionConstants.d16.sp, TextAlign.left),
                 ),
               ),
               MediaQuery.of(context).size.width > 500 ? Container(width: DimensionConstants.d80.w) :
               Container(width: DimensionConstants.d80.w),
             ],
           ))
   );
 }
}