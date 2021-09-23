import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
//import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:myapp3/src/logic/config/LocaleLang.dart';
import 'package:myapp3/src/logic/config/end_boxs.dart';
import 'package:myapp3/src/logic/config/pallete.dart';
import 'package:myapp3/src/logic/function/home_function.dart';
import 'package:myapp3/src/logic/function/router_function.dart';
import 'package:myapp3/src/logic/res/res_auth.dart';
import 'package:myapp3/src/view/app_nara.dart';
import 'widgets/box_button.dart';
import 'widgets/widget_public_auth.dart';

// ignore: must_be_immutable
class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController name = TextEditingController();

  final TextEditingController email = TextEditingController();

  final TextEditingController password = TextEditingController();

  final TextEditingController confirmPassword = TextEditingController();

  bool isShow = false;

  String iconShow = "Hide";

  showPassword() {
    return GestureDetector(
      onTap: () {
        if (isShow == true) {
          isShow = false;
          iconShow = "Hide";
        } else {
          isShow = true;
          iconShow = "Show";
        }
      },
      child: Text(iconShow),
    );
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double _heightSeperator = 20;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          AppLocale.of(context).getTranslated("register"),
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: _heightSeperator * 2,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey[400].withOpacity(0.7),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WidgetAuthPublic.designTextField(
                      size,
                      hint: AppLocale.of(context).getTranslated("username"),
                      password: false,
                      controller: name,
                    ),
                    Divider(
                      height: 5,
                      thickness: .8,
                      color: Colors.grey[200],
                    ),
                    WidgetAuthPublic.designTextField(
                      size,
                      hint: AppLocale.of(context).getTranslated("login_email"),
                      password: false,
                      controller: email,
                    ),
                    Divider(
                      height: 2,
                      thickness: .8,
                      color: Colors.grey[200],
                    ),
                    WidgetAuthPublic.designTextField(
                      size,
                      hint: AppLocale.of(context).getTranslated("login_passw"),
                      password: isShow,
                      controller: password,
                      trailing: showPassword(),
                    ),
                    Divider(
                      height: 5,
                      thickness: .8,
                      color: Colors.grey[200],
                    ),
                    WidgetAuthPublic.designTextField(
                      size,
                      hint: AppLocale.of(context)
                          .getTranslated("password_confirmation"),
                      password: isShow,
                      controller: confirmPassword,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              //-------------Sex
              WidgetAuthPublic.selectSex(
                size,
                index,
                onPressed: () {
                  if (index == 1)
                    setState(() => index = 0);
                  else
                    setState(() => index = 1);
                },
                onPressed2: () {
                  if (index == 2)
                    setState(() => index = 0);
                  else
                    setState(() => index = 2);
                },
                onPressed3: () {
                  if (index == 3)
                    setState(() => index = 0);
                  else
                    setState(() => index = 3);
                },
              ),
              SizedBox(
                height: _heightSeperator * 2,
              ),
              BoxButton(
                busy: isLoading,
                disabled: isLoading,
                title: AppLocale.of(context).getTranslated("sign_up"),
                onTap: register,
              ),
              SizedBox(
                height: _heightSeperator * 2,
              ),

              Align(
                alignment: Alignment.center,
                child: SignInButton(
                  Buttons.Facebook,
                  onPressed: loginFacebook,
                  text: AppLocale.of(context)
                      .getTranslated("sign_up_with_facebook"),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: SignInButton(
                  Buttons.Google,
                  onPressed: onGoogle,
                  text: AppLocale.of(context)
                      .getTranslated("sign_up_with_google"),
                ),
              ),

              Align(
                alignment: Alignment.center,
                child: WidgetAuthPublic.alreadyIHave(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int index = 0;

  void register() async {
    if (confirmPassword.text == password.text) {
      setState(() => isLoading = true);
      var data = await ResAuth.register(
        email: email.text,
        password: password.text,
        name: name.text,
      );
      print(data["status"]);
      if (data["status"] == true) {
        Hive.box(EndBoxs.NaraApp).put("token", data["token"]);
        RouterF.of(context).push(() => AppNara(init: Nav.HOME));
      } else {
        RouterF.of(context).message("خطأ", data["errors"].toString());
      }
      setState(() => isLoading = false);
    } else {
      RouterF.of(context).message("خطأ", "كلمة السر غير متطابقة");
    }
  }


  onGoogle() async {
    try {
      setState(() => isLoading = true);
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      bool isLogin = await _googleSignIn.isSignedIn();
      if(isLogin == true){
        await _googleSignIn.disconnect();
      }
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication d = await googleSignInAccount.authentication;

      print("Email : ${d.idToken}");
      print("ID: ${googleSignInAccount.id }");
      print("DisplayName: ${googleSignInAccount.displayName}");
      print("Email: ${googleSignInAccount.email}");
      var data = await ResAuth.loginGoogle(email: googleSignInAccount.email, name:googleSignInAccount.displayName, accessToken: googleSignInAccount.id.toString());
      if(data is DioError){
        if( data.response.statusCode == 422 ){
          print(data.response.data);
        }
      }
      if (data["token"] != null ) {
        await Hive.box(EndBoxs.NaraApp).put("token", data["token"]);
        print(data["token"]);
        RouterF.of(context).push(() => AppNara(init: Nav.HOME));
      } else {
        RouterF.of(context).message("خطأ", data["errors"].toString());
      }
      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
      throw e;
    }
  }

  loginFacebook() async {
    setState(() => isLoading = true);
    FirebaseAuth _auth = FirebaseAuth.instance; //4499394463453652
    final fb = FacebookLogin();
    // ignore: unrelated_type_equality_checks
    bool isLogin = await fb.isLoggedIn;
    if(isLogin==true) {
      await fb.logOut();
    }

    FacebookLoginResult res = await fb.logIn(permissions: [
      FacebookPermission.email,
      FacebookPermission.publicProfile,
    ]);

    // Check result status
    switch (res.status) {
      case FacebookLoginStatus.success:

        final profile = await fb.getUserProfile();
        var data = await ResAuth.register(
          name: profile.firstName,
          email: "profile.userId@mail.com",
          password: profile.name
        );

        if (data["status"] == true) {
          await Hive.box(EndBoxs.NaraApp).put("token", data["token"]);
          RouterF.of(context).push(() => AppNara(init: Nav.HOME));
        } else {
          RouterF.of(context).message("خطأ", data["errors"].toString());
        }
        break;
      case FacebookLoginStatus.cancel:
      // User cancel log in
        break;
      case FacebookLoginStatus.error:
      // Log in failed
        print('Error while log in: ${res.error}');
        break;
    }
    setState(() => isLoading = false);
  }
}
