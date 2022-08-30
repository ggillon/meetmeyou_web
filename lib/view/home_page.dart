import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meetmeyou_web/constants/dimension_constants.dart';
import 'package:meetmeyou_web/constants/image_constants.dart';
import 'package:meetmeyou_web/extensions/all_extensions.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/provider/base_provider.dart';
import 'package:meetmeyou_web/view/base_view.dart';
import 'package:meetmeyou_web/view/data_privacy_view.dart';
import 'package:meetmeyou_web/view/home_page_view.dart';
import 'package:meetmeyou_web/widgets/image_view.dart';

import '../constants/color_constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{

  BaseProvider provider = locator<BaseProvider>();

   TabController? _controller;
   int _selectedIndex = 0;

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseView<BaseProvider>(
        onModelReady: (provider){
          this.provider = provider;
          _controller = TabController(length: 3, vsync: this);
          _controller!.addListener(() {
            if(_controller!.indexIsChanging){
              _selectedIndex = _controller!.index;
             provider.updateLoadingStatus(true);
            }
          });
          print(MediaQuery.of(context).size.width);
        },
        builder: (context, provider, _){
          return Column(
            children: [
              header(context),
              Expanded(
                child: TabBarView(
                  controller: _controller,
                    children: [
                  const HomePageView(),
                  aboutView(),
                  const DataPrivacyView()
                ]),
              ),
            ],
          );
        },
      )
    );
  }

  Widget header(BuildContext context){
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
                Container(
                  width: MediaQuery.of(context).size.width < 700 ? DimensionConstants.d300 : DimensionConstants.d400,
                  alignment: Alignment.bottomRight,
                  child: TabBar(
                    indicatorColor: ColorConstants.colorWhite,
                    controller: _controller,
                    isScrollable: false,
                    tabs: [
                      Text("home".tr()).mediumText(
                          _selectedIndex == 0 ? ColorConstants.primaryColor : ColorConstants.colorBlack,
                                  DimensionConstants.d12.sp,
                                  TextAlign.left),
                      Text("about".tr()).mediumText(
                          _selectedIndex == 1 ? ColorConstants.primaryColor : ColorConstants.colorBlack,
                          DimensionConstants.d12.sp,
                          TextAlign.left),
                      Text("data_privacy".tr()).mediumText(
                          _selectedIndex == 2 ? ColorConstants.primaryColor : ColorConstants.colorBlack,
                          DimensionConstants.d12.sp,
                          TextAlign.left),
                    ],
                  ),
                )
              ],
            ))
    );
  }

  Widget aboutView(){
    return Padding(
      padding: MediaQuery.of(context).size.width > 900
          ? EdgeInsets.symmetric(
          horizontal: DimensionConstants.d90.w)
          : EdgeInsets.symmetric(
          horizontal: DimensionConstants.d60.w),
      child: Column(
    children: [
      SizedBox(height: DimensionConstants.d60.h),
      Text("about_us".tr()).mediumText(
          ColorConstants.colorBlack,
          DimensionConstants.d20.sp,
          TextAlign.left),
      SizedBox(height: DimensionConstants.d25.h),
      Text("about_us_desc".tr()).regularText(
          ColorConstants.colorBlack,
          DimensionConstants.d15.sp,
          TextAlign.center),
      Text("ggillon@meetmeyou.com").regularText(
          Colors.blue,
          DimensionConstants.d15.sp,
          TextAlign.center),
    ],
      ),
    );
  }
}
