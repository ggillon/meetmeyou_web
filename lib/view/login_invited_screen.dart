import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meetmeyou_web/constants/api_constants.dart';
import 'package:meetmeyou_web/constants/color_constants.dart';
import 'package:meetmeyou_web/constants/dimension_constants.dart';
import 'package:meetmeyou_web/constants/image_constants.dart';
import 'package:meetmeyou_web/constants/route_constants.dart';
import 'package:meetmeyou_web/enum/view_state.dart';
import 'package:meetmeyou_web/extensions/all_extensions.dart';
import 'package:meetmeyou_web/helper/date_time_helper.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/models/event.dart';
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
        onModelReady: (provider) async {
          this.provider = provider;
          await provider.getEvent(context, "vrwO-IxFr");
        },
        builder: (context, provider, _){
          return provider.state == ViewState.Busy ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                SizedBox(height: DimensionConstants.d5.h),
                Text("loading_event_please_wait".tr())
                    .regularText(ColorConstants.primaryColor,
                    DimensionConstants.d12.sp, TextAlign.left),
              ],
            ),
          ) : SafeArea(
            child:  SingleChildScrollView(
              child:  Column(
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
                            imageView(context, provider.eventResponse?.photoURL ?? ""),
                            Positioned(
                              bottom: -DimensionConstants.d75,
                              child: titleDateLocationCard(context, provider.eventResponse?.title ?? "",  DateTime.fromMillisecondsSinceEpoch(provider.eventResponse?.start ?? "")
                                  , DateTime.fromMillisecondsSinceEpoch(provider.eventResponse?.end ?? ""), provider.eventResponse?.location ?? "",
                                  provider.eventResponse?.organiserName ?? ""),
                            )
                          ],
                        ),
                        SizedBox(height: DimensionConstants.d75.h),
                        Text("event_description".tr())
                            .boldText(ColorConstants.colorBlack,
                            DimensionConstants.d15.sp, TextAlign.left,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        SizedBox(height: DimensionConstants.d10.h),
                        Text(provider.eventResponse?.description ?? "")
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

   Widget imageView(BuildContext context, String photoUrl) {
     return Card(
       margin: EdgeInsets.zero,
       shadowColor: ColorConstants.colorWhite,
       elevation: 5.0,
       shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.only(bottomLeft: Radius.circular(DimensionConstants.d12.r), bottomRight: Radius.circular(DimensionConstants.d12.r))),
       color: ColorConstants.colorLightGray,
       child: SizedBox(
         height: MediaQuery.of(context).size.width > 1050 ? DimensionConstants.d325.h : DimensionConstants.d300.h,
         width: double.infinity,
         child: ClipRRect(
                   borderRadius:
               BorderRadius.only(bottomLeft: Radius.circular(DimensionConstants.d12.r), bottomRight: Radius.circular(DimensionConstants.d12.r)),
                   child:
                   photoUrl == ""
                       ?  ImageView(
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

   Widget titleDateLocationCard(BuildContext context, String eventTitle, DateTime startDate, DateTime endDate, String location, String organiserName) {
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
                         const Icon(Icons.person),
                         SizedBox(width: DimensionConstants.d3.w),
                         Container(
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

   Widget dateCard(DateTime startDate) {
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
          //  context.go(RouteConstants.eventDetailScreen);
            provider.state == ViewState.Busy
                ? const Center(
              child:
              CircularProgressIndicator(),
            )
                : provider.signInWithGoogle(context);
          }),
          SizedBox(height: DimensionConstants.d10.h),
          socialMediaLoginBtn("sign_up_with_facebook".tr(), ImageConstants.ic_fb, onTap: (){
            //  context.go(RouteConstants.eventDetailScreen);
            provider.state == ViewState.Busy
                ? const Center(
              child:
              CircularProgressIndicator(),
            )
                : provider.signInWithFb(context);
          }),
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
