import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meetmeyou_web/constants/dimension_constants.dart';
import 'package:meetmeyou_web/constants/image_constants.dart';
import 'package:meetmeyou_web/extensions/all_extensions.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/provider/base_provider.dart';
import 'package:meetmeyou_web/view/base_view.dart';
import 'package:meetmeyou_web/widgets/image_view.dart';

import '../constants/color_constants.dart';

class HomePage extends StatelessWidget {
   HomePage({Key? key}) : super(key: key);

  List<String> tabsList = ["home".tr(), "about".tr(), "data_privacy".tr()];
  int selectedIndex = 0;
  BaseProvider provider = locator<BaseProvider>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseView<BaseProvider>(
        onModelReady: (provider){
          this.provider = provider;
        },
        builder: (context, provider, _){
          return Column(
            children: [
              appBar(context)
            ],
          );
        },
      )
    );
  }

  Widget appBar(BuildContext context){
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
                      alignment: Alignment.bottomRight,
                      child: ListView.builder(
                        shrinkWrap: true,
                   scrollDirection: Axis.horizontal,
                  itemCount: tabsList.length,
                      itemBuilder: (context, index){
                  return GestureDetector(
                    onTap: (){
                      selectedIndex = index;
                      provider.updateLoadingStatus(true);
                    },
                    child: Row(
                        children: [
                          SizedBox(width: DimensionConstants.d10.w),
                          Text(tabsList[index]).mediumText(
                              selectedIndex == index ? ColorConstants.primaryColor : ColorConstants.colorBlack,
                              DimensionConstants.d12.sp,
                              TextAlign.left),
                          SizedBox(width: DimensionConstants.d10.w)
                        ],
                    ),
                  );
                }),
                    ))
              ],
            ))
    );
  }
}
