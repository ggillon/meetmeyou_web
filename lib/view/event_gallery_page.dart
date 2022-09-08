import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meetmeyou_web/constants/color_constants.dart';
import 'package:meetmeyou_web/constants/dimension_constants.dart';
import 'package:meetmeyou_web/constants/image_constants.dart';
import 'package:meetmeyou_web/constants/route_constants.dart';
import 'package:meetmeyou_web/helper/dialog_helper.dart';
import 'package:meetmeyou_web/enum/view_state.dart';
import 'package:meetmeyou_web/extensions/all_extensions.dart';
import 'package:meetmeyou_web/helper/shared_pref.dart';
import 'package:meetmeyou_web/main.dart';
import 'package:meetmeyou_web/provider/event_gallery_page_provider.dart';
import 'package:meetmeyou_web/view/base_view.dart';
import 'package:meetmeyou_web/widgets/image_view.dart';
import 'package:provider/provider.dart';

class EventGalleryPage extends StatelessWidget {
  EventGalleryPage({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: ColorConstants.colorWhite,
        body: BaseView<EventGalleryPageProvider>(
          onModelReady: (provider){
            provider.getPhotoAlbum(context, provider.eventId.toString());
          },
          builder: (context, provider, _){
            return SingleChildScrollView(
              child: Column(
                children: [
                  commonAppBar(context,
                      userName: SharedPreference.prefs!.getString(SharedPreference.displayName)),
                  SizedBox(height: DimensionConstants.d20.h),
                  provider.getAlbum == true || provider.state == ViewState.Busy ?
                  SizedBox(
                    height: DimensionConstants.d700,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Center(child: CircularProgressIndicator()),
                        SizedBox(height: DimensionConstants.d5.h),
                        Text("fetching_gallery".tr()).regularText(
                            ColorConstants.primaryColor,
                            DimensionConstants.d14.sp,
                            TextAlign.left),
                      ],
                    ),
                  ) :    Padding(
                    padding: MediaQuery.of(context).size.width > 1050
                        ? EdgeInsets.symmetric(
                        horizontal: DimensionConstants.d50.w)
                        : EdgeInsets.symmetric(
                        horizontal: DimensionConstants.d15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: (){
                            provider.loginInfo = Provider.of<LoginInfo>(context, listen: false);
                            provider.loginInfo.setLoginState(true);
                            context.go(RouteConstants.eventDetailScreen);
                          },
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("${"go_to_event".tr()} >>").mediumText(Colors.blue, DimensionConstants.d14.sp, TextAlign.left, underline: true),
                          ),
                        ),
                        SizedBox(height: DimensionConstants.d20.h),
                       Text(provider.eventDetail.eventTitle ?? "").boldText(
                              ColorConstants.colorBlack,
                              DimensionConstants.d16.sp,
                              TextAlign.left, maxLines: 2, overflow: TextOverflow.ellipsis),
                        SizedBox(height: DimensionConstants.d2.h),
                      provider.galleryImagesUrl.isEmpty ? Center(
                        child: Container(
                          alignment: Alignment.center,
                          height: DimensionConstants.d600,
                          child:Text("no_photos_yet".tr()).regularText(
                              ColorConstants.primaryColor,
                              DimensionConstants.d14.sp,
                              TextAlign.left),
                        ),
                      )
                          : galleryGridView(provider),

                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        )
    );
  }

  Widget galleryGridView(EventGalleryPageProvider provider){
    return  SizedBox(
        height: DimensionConstants.d650,
        child: GridView.builder(
        //  physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.galleryImagesUrl.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0
          ),
          itemBuilder: (BuildContext context, int index){

            return GestureDetector(
                onTap: (){
                //  provider.eventDetail.eventGalleryPhotoUrl = provider.mmyPhotoList[index].photoURL;
                  SharedPreference.prefs!.setString(SharedPreference.eventGalleryPhotoUrl, provider.mmyPhotoList[index].photoURL);
                  context.go(RouteConstants.eventGalleryPhotoViewPage);
                  // Navigator.pushNamed(context, RoutesConstants.eventGalleryImageView, arguments: provider.mmyPhotoList[index]).then((value) {
                  //   provider.getPhotoAlbum(_scaffoldKey.currentContext!, provider.eventDetail.eid.toString());
                  // });
                },
                child: Card(child: ImageView(path: provider.galleryImagesUrl[index], fit: BoxFit.cover,)));
          },
        ));
  }

  Widget commonAppBar(BuildContext context, {String? userName}){
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

