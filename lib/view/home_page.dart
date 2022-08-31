import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meetmeyou_web/constants/dimension_constants.dart';
import 'package:meetmeyou_web/constants/image_constants.dart';
import 'package:meetmeyou_web/extensions/all_extensions.dart';
import 'package:meetmeyou_web/helper/common_widgets.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/provider/base_provider.dart';
import 'package:meetmeyou_web/view/base_view.dart';
import 'package:meetmeyou_web/view/data_privacy_view.dart';
import 'package:meetmeyou_web/view/home_page_view.dart';
import 'package:meetmeyou_web/widgets/image_view.dart';
import 'package:url_launcher/url_launcher.dart';

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
  int popupValue = 1;

  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'ggillon@meetmeyou.com',
  );

@override
  void initState() {
    super.initState();
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
              MediaQuery.of(context).size.width > 700 ?  Expanded(
                child: TabBarView(
                  controller: _controller,
                    children: [
                  const HomePageView(),
                  aboutView(),
                  DataPrivacyView()
                ]),
              ) : (
              popupValue == 1 ? const Expanded(child: HomePageView()) : (popupValue == 2 ? Expanded(child: aboutView()) : Expanded(
                child: DataPrivacyView(),
              ))
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
                MediaQuery.of(context).size.width > 700 ? Container(
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
                ) :   Container(
                  width: DimensionConstants.d80.w,
                  alignment: Alignment.centerRight,
                  child: PopupMenuButton<int>(
                    itemBuilder: (context) => [
                      // PopupMenuItem 1
                      PopupMenuItem(
                        value: 1,
                        child: Text("home".tr())
                            .mediumText(popupValue == 1 ? ColorConstants.primaryColor : ColorConstants.colorBlack,
                            DimensionConstants.d14.sp, TextAlign.left),
                      ),
                      // PopupMenuItem 2
                      PopupMenuItem(
                        value: 2,
                        child:  Text("about".tr())
                            .mediumText(popupValue == 2 ? ColorConstants.primaryColor : ColorConstants.colorBlack,
                            DimensionConstants.d14.sp, TextAlign.left),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child:  Text("data_privacy".tr())
                            .mediumText(popupValue == 3 ? ColorConstants.primaryColor : ColorConstants.colorBlack,
                            DimensionConstants.d14.sp, TextAlign.left),
                      ),
                    ],
                    offset: Offset(0, 50),
                    color: Colors.white,
                    elevation: 2,
                    icon: Icon(Icons.menu, color: ColorConstants.primaryColor, size: 30),
                    onSelected: (value) {
                      if (value == 1) {
                        popupValue = value;
                        provider.updateLoadingStatus(true);
                      } else if (value == 2) {
                        popupValue = value;
                        provider.updateLoadingStatus(true);
                      } else if (value == 3) {
                        popupValue = value;
                        provider.updateLoadingStatus(true);
                      }
                    },
                  ),
                ),
              ],
            ))
    );
  }

  Widget aboutView(){
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Padding(
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
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: "about_us_desc".tr(), style: TextStyle(
                      color:  ColorConstants.colorBlack, fontSize: DimensionConstants.d14.sp
                  )),
                  TextSpan(
                    text: 'ggillon@meetmeyou.com ',
                    style: TextStyle(color:  Colors.blue, fontSize: DimensionConstants.d14.sp, decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      launchUrl(emailLaunchUri);
                    },
                  ),
                  ]),),
          ]
            ),
          ),
          Expanded(child: Container(
            alignment: Alignment.bottomCenter,
              child: CommonWidgets.footer()))
        ],
      ),
    );
  }
}
