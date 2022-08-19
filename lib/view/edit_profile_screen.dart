import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meetmeyou_web/constants/color_constants.dart';
import 'package:meetmeyou_web/constants/dimension_constants.dart';
import 'package:meetmeyou_web/constants/route_constants.dart';
import 'package:meetmeyou_web/extensions/all_extensions.dart';
import 'package:meetmeyou_web/helper/common_widgets.dart';
import 'package:meetmeyou_web/helper/decoration.dart';
import 'package:meetmeyou_web/helper/validations.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final countryCodeController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonWidgets.commonAppBar(context, true, routeName: RouteConstants.viewProfileScreen),
                SizedBox(height: DimensionConstants.d20.h),
                Padding(
                  padding: MediaQuery.of(context).size.width > 1050 ? EdgeInsets.symmetric(horizontal: DimensionConstants.d50.w) :  EdgeInsets.symmetric(horizontal: DimensionConstants.d20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("${"go_to_event".tr()} >>").mediumText(Colors.blue, DimensionConstants.d14.sp, TextAlign.left, underline: true),
                      ),
                      SizedBox(height: DimensionConstants.d10.h),
                      SizedBox(
                        width: DimensionConstants.d110,
                        height: DimensionConstants.d120,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(DimensionConstants.d12.r),
                            child: Container(
                              color: ColorConstants.primaryColor,
                              width: DimensionConstants.d110,
                              height: DimensionConstants.d120,
                            )
                        ),
                      ),
                      SizedBox(height: DimensionConstants.d20.h),
                      MediaQuery.of(context).size.width > 600 ?  profileRowTextFields() : profileColumnTextFields(),
                      SizedBox(height: DimensionConstants.d20.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: saveBtn(context)
                      ),
                      SizedBox(height: DimensionConstants.d20.h),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget profileRowTextFields(){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            rowTextFieldContainer("first_name".tr(), firstNameTextField()),
            SizedBox(width: DimensionConstants.d10.w),
            rowTextFieldContainer("last_name".tr(), lastNameTextField()),
          ],
        ),
        SizedBox(height: DimensionConstants.d15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            rowTextFieldContainer("country_code".tr(), countryCodeTextField()),
            SizedBox(width: DimensionConstants.d10.w),
            rowTextFieldContainer("phone_no".tr(), phoneNoTextField()),
          ],
        ),
        SizedBox(height: DimensionConstants.d15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            rowTextFieldContainer("email".tr(), emailTextField()),
            SizedBox(width: DimensionConstants.d10.w),
            rowTextFieldContainer("address".tr(), addressTextField()),
          ],
        ),
        SizedBox(height: DimensionConstants.d10.h),
      ],
    );
  }

  Widget rowTextFieldContainer(String txt, Widget textField){
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(txt).boldText(ColorConstants.colorBlack, DimensionConstants.d15.sp, TextAlign.left),
          SizedBox(height: DimensionConstants.d5.h),
          textField
        ],
      ),
    );
  }

  Widget profileColumnTextFields(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: DimensionConstants.d12.w),
      child: Column(
        children: [
          columnTextFieldContainer("first_name".tr(), firstNameTextField()),
          SizedBox(height: DimensionConstants.d10.h),
          columnTextFieldContainer("last_name".tr(), lastNameTextField()),
          SizedBox(height: DimensionConstants.d10.h),
          columnTextFieldContainer("country_code".tr(), countryCodeTextField()),
          SizedBox(height: DimensionConstants.d10.h),
          columnTextFieldContainer("phone_no".tr(), phoneNoTextField()),
          SizedBox(height: DimensionConstants.d10.h),
          columnTextFieldContainer("email".tr(), emailTextField()),
          SizedBox(height: DimensionConstants.d10.h),
          columnTextFieldContainer("address".tr(), addressTextField()),
          SizedBox(height: DimensionConstants.d10.h),
        ],
      ),
    );
  }

  Widget columnTextFieldContainer(String txt, Widget textField){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(txt).boldText(ColorConstants.colorBlack, DimensionConstants.d15.sp, TextAlign.left),
        SizedBox(height: DimensionConstants.d5.h),
        textField
      ],
    );
  }


  Widget firstNameTextField(){
    return TextFormField(
      controller: firstNameController,
      decoration: ViewDecoration.inputDecorationWithCurve("first_name".tr()),
      style: ViewDecoration.textFieldStyle(DimensionConstants.d15.sp, ColorConstants.colorBlack),
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "first_name_required".tr();
        }
        {
          return null;
        }
      },
    );
  }

  Widget lastNameTextField(){
    return TextFormField(
      controller: lastNameController,
      decoration: ViewDecoration.inputDecorationWithCurve("last_name".tr()),
      style: ViewDecoration.textFieldStyle(DimensionConstants.d15.sp, ColorConstants.colorBlack),
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "last_name_required".tr();
        }
        {
          return null;
        }
      },
    );
  }

  Widget countryCodeTextField(){
    return TextFormField(
      readOnly: true,
      controller: countryCodeController,
      decoration: ViewDecoration.inputDecorationWithCurve("", prefix: countryCodePicker()),
      style: ViewDecoration.textFieldStyle(DimensionConstants.d15.sp, ColorConstants.colorBlack),
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
    );
  }

  Widget countryCodePicker(){
    return  CountryCodePicker(
      onChanged: (value) {
       // countryCodeController.text = value.dialCode.toString();
      },
      textStyle:
      ViewDecoration.textFieldStyle(
          DimensionConstants.d14.sp,
          ColorConstants.colorBlack),
      initialSelection:
      countryCodeController.text == ""
          ? "US"
          : countryCodeController.text,
      //  favorite: ['US', 'GB', 'BE', 'FR', 'LU', 'AN', '+49'],
      showFlag: false,
      showFlagDialog: true,
      showCountryOnly: false,
      showOnlyCountryWhenClosed: false,
      alignLeft: false,
    );
  }
  Widget phoneNoTextField(){
    return TextFormField(
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      controller: phoneController,
      decoration: ViewDecoration.inputDecorationWithCurve("phone_no".tr()),
      style: ViewDecoration.textFieldStyle(DimensionConstants.d15.sp, ColorConstants.colorBlack),
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "phone_no_cannot_empty".tr();
        }
        else {
          return null;
        }
      },
    );
  }

  Widget emailTextField(){
    return TextFormField(
      controller: emailController,
      decoration: ViewDecoration.inputDecorationWithCurve("email".tr()),
      style: ViewDecoration.textFieldStyle(DimensionConstants.d15.sp, ColorConstants.colorBlack),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "email_required".tr();
        } else if (!Validations.emailValidation(
            value.trim())) {
          return "invalid_email".tr();
        } else {
          return null;
        }
      },
    );
  }

  Widget addressTextField(){
    return TextFormField(
      controller: addressController,
      decoration: ViewDecoration.inputDecorationWithCurve("address".tr()),
      style: ViewDecoration.textFieldStyle(DimensionConstants.d15.sp, ColorConstants.colorBlack),
      keyboardType: TextInputType.streetAddress,
      textInputAction: TextInputAction.done,
    );
  }

  Widget saveBtn(BuildContext context) {
    return GestureDetector(
        onTap: (){
          if(_formKey.currentState!.validate()){

          }
        },
        child: Container(
          width: DimensionConstants.d90,
          height: DimensionConstants.d40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius:BorderRadius.circular(DimensionConstants.d4.r),
              color: ColorConstants.primaryColor
          ),
          child: Text("save".tr())
              .mediumText(ColorConstants.colorWhite, DimensionConstants.d13.sp, TextAlign.center),
        )
    );
  }
}
