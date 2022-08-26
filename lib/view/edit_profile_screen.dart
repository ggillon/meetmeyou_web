import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meetmeyou_web/constants/color_constants.dart';
import 'package:meetmeyou_web/constants/dimension_constants.dart';
import 'package:meetmeyou_web/constants/image_constants.dart';
import 'package:meetmeyou_web/constants/route_constants.dart';
import 'package:meetmeyou_web/enum/view_state.dart';
import 'package:meetmeyou_web/extensions/all_extensions.dart';
import 'package:meetmeyou_web/helper/common_widgets.dart';
import 'package:meetmeyou_web/helper/decoration.dart';
import 'package:meetmeyou_web/helper/shared_pref.dart';
import 'package:meetmeyou_web/helper/validations.dart';
import 'package:meetmeyou_web/locator.dart';
import 'package:meetmeyou_web/main.dart';
import 'package:meetmeyou_web/provider/edit_profile_provider.dart';
import 'package:meetmeyou_web/view/base_view.dart';
import 'package:meetmeyou_web/widgets/image_view.dart';
import 'package:provider/provider.dart';

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
        onModelReady: (provider) async {
          this.provider = provider;
          firstNameController.text = SharedPreference.prefs!.getString(SharedPreference.firstName) ?? "";
          lastNameController.text = SharedPreference.prefs!.getString(SharedPreference.lastName) ?? "";
          provider.countryCode = SharedPreference.prefs!.getString(SharedPreference.countryCode) ?? "";
          phoneController.text = SharedPreference.prefs!.getString(SharedPreference.phone) ?? "";
          emailController.text = SharedPreference.prefs!.getString(SharedPreference.email) ?? "";
          addressController.text = SharedPreference.prefs!.getString(SharedPreference.address) ?? "";
          provider.loginInfo = Provider.of<LoginInfo>(context, listen: false);
        },
        builder: (context, provider, _){
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  commonAppBar(context, true, routeName: RouteConstants.viewProfileScreen, userName: SharedPreference.prefs!.getString(SharedPreference.displayName) ?? "",),
                  SizedBox(height: DimensionConstants.d20.h),
                  Padding(
                    padding: MediaQuery.of(context).size.width > 1050 ? EdgeInsets.symmetric(horizontal: DimensionConstants.d50.w) :  EdgeInsets.symmetric(horizontal: DimensionConstants.d20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            provider.loginInfo.setLoginState(true);
                            context.go(RouteConstants.eventDetailScreen);
                          },
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("${"go_to_event".tr()} >>").mediumText(Colors.blue, DimensionConstants.d14.sp, TextAlign.left, underline: true),
                          ),
                        ),
                        SizedBox(height: DimensionConstants.d10.h),
                        SizedBox(
                          width: DimensionConstants.d110,
                          height: DimensionConstants.d120,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(DimensionConstants.d12.r),
                              child: (SharedPreference.prefs!.getString(SharedPreference.profileUrl) == null || SharedPreference.prefs!.getString(SharedPreference.profileUrl) == "")
                                  ? Container(
                                color: ColorConstants.primaryColor,
                                width: DimensionConstants.d110,
                                height: DimensionConstants.d120,
                              )
                                  : ImageView(
                                path: SharedPreference.prefs!.getString(SharedPreference.profileUrl),
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

  Widget commonAppBar(BuildContext context, bool navigate, {String? routeName, String? userName}){
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
                    offset: Offset(0, 50),
                    color: Colors.white,
                    elevation: 2,
                    icon: Icon(Icons.menu, color: ColorConstants.primaryColor, size: 30),
                    onSelected: (value) {
                      if (value == 1) {
                        if(navigate){
                          provider.loginInfo = Provider.of<LoginInfo>(context, listen: false);
                          provider.loginInfo.setLoginState(false);
                          context.go(routeName!);
                          provider.updateLoadingStatus(true);
                        }
                      } else if (value == 2) {
                        //    provider.isDisposed = false;
                        provider.loginInfo = Provider.of<LoginInfo>(context, listen: false);
                        provider.loginInfo.setLoginState(false);
                        provider.loginInfo.setLogoutState(true);
                        provider.updateLoadingStatus(true);
                        context.go("/");
                        provider.updateLoadingStatus(true);
                      }
                    },
                  ),
                ),
              ],
            ))
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
      controller: firstNameController..text = SharedPreference.prefs!.getString(SharedPreference.firstName) ?? "",
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
      controller: lastNameController..text = SharedPreference.prefs!.getString(SharedPreference.lastName) ?? "",
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
      (SharedPreference.prefs!.getString(SharedPreference.countryCode) == null)
          ? "US"
          :  SharedPreference.prefs!.getString(SharedPreference.countryCode),
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
      controller: phoneController..text = SharedPreference.prefs!.getString(SharedPreference.phone) ?? "",
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
      controller: emailController..text = SharedPreference.prefs!.getString(SharedPreference.email) ?? "",
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
      controller: addressController..text = SharedPreference.prefs!.getString(SharedPreference.address) ?? "",
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
            provider.loginInfo.setLoginState(false);
            provider.setUserProfile(context, firstNameController.text, lastNameController.text, provider.userDetail.profileUrl.toString(), emailController.text,
                phoneController.text, addressController.text, provider.countryCode == null ?  (SharedPreference.prefs!.getString(SharedPreference.countryCode) ?? "") : provider.countryCode.toString()).then((value){
                  if(value == true){
                    context.go(RouteConstants.viewProfileScreen);
                  }
            });
            // provider.updateProfile(context, firstNameController.text, lastNameController.text,
            //     provider.countryCode.toString(), phoneController.text, emailController.text, addressController.text);
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
