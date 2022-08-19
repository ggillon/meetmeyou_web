import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meetmeyou_web/constants/color_constants.dart';
import 'package:meetmeyou_web/constants/dimension_constants.dart';
import 'package:meetmeyou_web/constants/image_constants.dart';
import 'package:meetmeyou_web/constants/route_constants.dart';
import 'package:meetmeyou_web/extensions/all_extensions.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/provider/login_invited_provider.dart';
import 'package:meetmeyou_web/view/base_view.dart';
import 'package:meetmeyou_web/widgets/image_view.dart';

class LoginInvitedScreen extends StatelessWidget {
   LoginInvitedScreen({Key? key}) : super(key: key);

  LoginInvitedProvider provider = locator<LoginInvitedProvider>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseView<LoginInvitedProvider>(
        onModelReady: (provider){
          this.provider = provider;
          print(MediaQuery.of(context).size.width);
       //   provider.login(context, "jd@gmail.com", "Qwerty@123");
        },
        builder: (context, provider, _){
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    margin: EdgeInsets.zero,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: DimensionConstants.d18.h, horizontal: DimensionConstants.d40.w),
                        width: double.infinity,
                        height: DimensionConstants.d75.h,
                      alignment: Alignment.centerLeft,
                        child: const ImageView(path: ImageConstants.webLogo))
                  ),
                  Padding(
                    padding: MediaQuery.of(context).size.width > 1050 ? EdgeInsets.symmetric(horizontal: DimensionConstants.d50.w) :  EdgeInsets.symmetric(horizontal: DimensionConstants.d15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.bottomCenter,
                          children: [
                            imageView(context),
                            Positioned(
                              bottom: -DimensionConstants.d75,
                              child: titleDateLocationCard(context),
                            )
                          ],
                        ),
                        SizedBox(height: DimensionConstants.d75.h),
                        Text("event_description".tr())
                            .boldText(ColorConstants.colorBlack,
                            DimensionConstants.d15.sp, TextAlign.left,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        SizedBox(height: DimensionConstants.d10.h),
                        Text("Hiiiiiiiiiiiiiiii")
                            .regularText(ColorConstants.colorGray,
                            DimensionConstants.d12.sp, TextAlign.left,
                            maxLines: 5, overflow: TextOverflow.ellipsis),
                        SizedBox(height: DimensionConstants.d15.h),
                        respondToInviteContainer(context),
                        SizedBox(height: DimensionConstants.d20.h),
                        Align(
                          alignment: Alignment.center,
                          child:  Text("for_advance_function_download_app_on_your_smartphone".tr())
                              .mediumText(ColorConstants.colorBlack,
                              DimensionConstants.d12.sp, TextAlign.left),
                        ),
                        SizedBox(height: DimensionConstants.d10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MediaQuery.of(context).size.width > 900 ? ImageView(path: ImageConstants.appStore, height: DimensionConstants.d40.h, width: DimensionConstants.d40.w, fit: BoxFit.contain,)
                                : ImageView(path: ImageConstants.appStore, height: DimensionConstants.d60.h, width: DimensionConstants.d75.w, fit: BoxFit.contain,),
                            SizedBox(width: DimensionConstants.d5.w),
                            MediaQuery.of(context).size.width > 900 ? ImageView(path: ImageConstants.googleStore, height: DimensionConstants.d40.h, width: DimensionConstants.d40.w, fit: BoxFit.contain,)
                                : ImageView(path: ImageConstants.googleStore, height: DimensionConstants.d60.h, width: DimensionConstants.d75.w, fit: BoxFit.contain)
                          ],
                        ),
                        SizedBox(height: DimensionConstants.d10.h),

                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

   Widget imageView(BuildContext context) {
     return Card(
       margin: EdgeInsets.zero,
       shadowColor: ColorConstants.colorWhite,
       elevation: 5.0,
       shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.only(bottomLeft: Radius.circular(DimensionConstants.d12.r), bottomRight: Radius.circular(DimensionConstants.d12.r))),
       color: ColorConstants.colorLightGray,
       child: Container(
         height: MediaQuery.of(context).size.width > 1050 ? DimensionConstants.d325.h : DimensionConstants.d300.h,
         width: double.infinity,
         child: ClipRRect(
                   borderRadius:
               BorderRadius.only(bottomLeft: Radius.circular(DimensionConstants.d12.r), bottomRight: Radius.circular(DimensionConstants.d12.r)),
                   child: const ImageView(
                     path: "images/test.jpeg",
                     fit: BoxFit.cover)
                   // provider.eventDetail.photoUrlEvent == null ||
                   //     provider.eventDetail.photoUrlEvent == ""
                   //     ? Container(
                   //   color: ColorConstants.primaryColor,
                   //   height: DimensionConstants.d50.h,
                   //   width: double.infinity,
                   // )
                   //     : ImageView(
                   //   path: provider.eventDetail.photoUrlEvent,
                   //   fit: BoxFit.cover,
                   //   height: DimensionConstants.d50.h,
                   //   width: double.infinity,
                   // ),
                 ),


       ),
     );
   }

   Widget titleDateLocationCard(BuildContext context) {
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
                 dateCard(),
                 SizedBox(width: DimensionConstants.d5.w),
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     SizedBox(
                       width: MediaQuery.of(context).size.width > 1050 ? DimensionConstants.d175.w :  DimensionConstants.d225.w,
                       child: Text("Birthdays")
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
                           child: Text(" Thursday - 19:00 to 4 Aug 2022 (22:00)")
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
                          child: Text("Hii 5 Hotel, Jalan Kampung Air 5, Kota Kinabalu, Sabah, Malaysia")
                              .regularText(ColorConstants.colorGray,
                              DimensionConstants.d12.sp, TextAlign.left,
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                     SizedBox(height: DimensionConstants.d5.h),
                     Row(
                       children: [
                         Icon(Icons.person),
                         SizedBox(width: DimensionConstants.d5.w),
                         Container(
                           width:  MediaQuery.of(context).size.width > 1050 ? DimensionConstants.d150.w : DimensionConstants.d200.w,
                           child: Text("Akshay Kumar (Organiser)")
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

   Widget dateCard() {
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
             Text("Aug")
                 .regularText(ColorConstants.primaryColor,
                 DimensionConstants.d15.sp, TextAlign.center),
             Text("15")
                 .boldText(ColorConstants.primaryColor, DimensionConstants.d14.sp,
                 TextAlign.center)
           ],
         ),
       ),
     );
   }

   Widget respondToInviteContainer(BuildContext context){
    return Container(
      alignment: Alignment.center,
      margin:  MediaQuery.of(context).size.width > 1200 ? EdgeInsets.symmetric(horizontal: DimensionConstants.d60.w) : EdgeInsets.symmetric(horizontal: DimensionConstants.d50.w),
      padding: EdgeInsets.symmetric(horizontal: DimensionConstants.d15.w, vertical: DimensionConstants.d15.h),
      decoration: BoxDecoration(
        borderRadius:BorderRadius.circular(DimensionConstants.d10.r),
        border: Border.all(
          color: ColorConstants.colorBlack.withOpacity(0.2),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          Text("to_respond_to_invite".tr())
              .boldText(ColorConstants.colorBlack, DimensionConstants.d12.sp,
              TextAlign.center),
          SizedBox(height: DimensionConstants.d10.h),
          socialMediaLoginBtn("sign_up_with_google".tr(), ImageConstants.ic_google, onTap: (){
            context.go(RouteConstants.eventDetailScreen);
          }),
          SizedBox(height: DimensionConstants.d10.h),
          socialMediaLoginBtn("sign_up_with_facebook".tr(), ImageConstants.ic_fb),
          SizedBox(height: DimensionConstants.d10.h),
          socialMediaLoginBtn("sign_up_with_apple".tr(), ImageConstants.ic_apple)
        ],
      ),
    );
   }

   Widget socialMediaLoginBtn(String heading, String path, {VoidCallback? onTap}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: DimensionConstants.d10.w, vertical: DimensionConstants.d5.h),
        decoration: BoxDecoration(
          borderRadius:BorderRadius.circular(DimensionConstants.d8.r),
          border: Border.all(
            color: ColorConstants.colorBlack.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            ImageView(path: path, height: DimensionConstants.d20.h, width: DimensionConstants.d30.w,),
            SizedBox(width: DimensionConstants.d5.w),
            Text(heading)
                .mediumText(ColorConstants.colorBlack, DimensionConstants.d12.sp,
                TextAlign.center),
          ],
        ),
      ),
    );
   }
}
