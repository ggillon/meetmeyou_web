import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meetmeyou_web/constants/color_constants.dart';
import 'package:meetmeyou_web/constants/dimension_constants.dart';
import 'package:meetmeyou_web/constants/route_constants.dart';
import 'package:meetmeyou_web/helper/shared_pref.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/models/event_detail.dart';
import 'package:photo_view/photo_view.dart';

class EventGalleryPhotoViewPage extends StatelessWidget {
  EventGalleryPhotoViewPage({Key? key}) : super(key: key);

  EventDetail eventDetail = locator<EventDetail>();
  final photoUrl = SharedPreference.prefs!.getString(SharedPreference.eventGalleryPhotoUrl);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.colorWhite,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorConstants.colorNewGray,
        automaticallyImplyLeading: false,
        leading: Center(child: Row(
          children: [
            SizedBox(width: DimensionConstants.d5.w),
            GestureDetector(
                onTap: (){
                  context.go(RouteConstants.eventGalleryPage);
                },
                child: Icon(Icons.arrow_back_ios, color: Colors.blue))
          ],
        )),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ClipRRect(
            borderRadius:
                BorderRadius.all(Radius.circular(DimensionConstants.d10.r)),
            child: Container(
                color: ColorConstants.primaryColor,
                width: double.infinity,
                child:
                PhotoView(imageProvider: NetworkImage(photoUrl!)))),
      ),
    );
  }
}
