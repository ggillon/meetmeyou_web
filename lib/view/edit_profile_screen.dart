import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meetmeyou_web/constants/color_constants.dart';
import 'package:meetmeyou_web/constants/dimension_constants.dart';
import 'package:meetmeyou_web/constants/route_constants.dart';
import 'package:meetmeyou_web/enum/view_state.dart';
import 'package:meetmeyou_web/extensions/all_extensions.dart';
import 'package:meetmeyou_web/helper/common_widgets.dart';
import 'package:meetmeyou_web/helper/decoration.dart';
import 'package:meetmeyou_web/helper/validations.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/provider/edit_profile_provider.dart';
import 'package:meetmeyou_web/view/base_view.dart';
import 'package:meetmeyou_web/widgets/image_view.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final countryCodeController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  EditProfileProvider provider = locator<EditProfileProvider>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseView<EditProfileProvider>(
        onModelReady: (provider){
          this.provider = provider;
          firstNameController.text = provider.userDetail.firstName.toString();
          lastNameController.text = provider.userDetail.lastName.toString();
          provider.countryCode = provider.userDetail.countryCode.toString();
          phoneController.text = provider.userDetail.phone.toString();
          emailController.text = provider.userDetail.email.toString();
          addressController.text = provider.userDetail.address.toString();
        },
        builder: (context, provider, _){
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonWidgets.commonAppBar(context, true, routeName: RouteConstants.viewProfileScreen, userName: provider.userDetail.displayName),
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
                              child: (provider.userDetail.profileUrl == null || provider.userDetail.profileUrl == "")
                                  ? Container(
                                color: ColorConstants.primaryColor,
                                width: DimensionConstants.d110,
                                height: DimensionConstants.d120,
                              )
                                  : ImageView(
                                path: provider.userDetail.profileUrl,
                                width: DimensionConstants.d110,
                                height: DimensionConstants.d120,
                                fit: BoxFit.cover,
                              ),

                          ),
                        ),
                        SizedBox(height: DimensionConstants.d20.h),
                        MediaQuery.of(context).size.width > 600 ?  profileRowTextFields() : profileColumnTextFields(),
                        SizedBox(height: DimensionConstants.d20.h),
                        MediaQuery.of(context).size.width < 600 ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: DimensionConstants.d12.w),
                          child: provider.state == ViewState.Busy ? const Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator()
                          ) :  Align(
                              alignment: Alignment.centerLeft,
                              child: saveBtn(context)
                          ),
                        ) :  provider.state == ViewState.Busy ? const Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator()
                        ) :  Align(
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
          );
        },
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
        provider.countryCode = value.dialCode.toString();
      },
      textStyle:
      ViewDecoration.textFieldStyle(
          DimensionConstants.d14.sp,
          ColorConstants.colorBlack),
      initialSelection:
      (provider.countryCode == "" || provider.countryCode == null)
          ? "US"
          : provider.userDetail.countryCode,
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
            provider.updateProfile(context, firstNameController.text, lastNameController.text, provider.countryCode.toString(), phoneController.text, emailController.text, addressController.text);
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
