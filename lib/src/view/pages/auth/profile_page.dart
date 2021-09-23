import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp3/src/logic/config/LocaleLang.dart';
import 'package:myapp3/src/logic/config/end_boxs.dart';
import 'package:myapp3/src/logic/config/pallete.dart';
import 'package:myapp3/src/logic/function/home_function.dart';
import 'package:myapp3/src/logic/function/router_function.dart';
import 'package:myapp3/src/view/app_nara.dart';

import 'login_view.dart';
import 'widgets/widget_profile.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final String _image = "assets/images/frosted-glass-texture.jpg";

  /// [Logic] of Page

  @override
  void initState() {
    super.initState();
    String token = Hive.box(EndBoxs.NaraApp).get("token");
    if (token == null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {

        // add your code here.

        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => AppNara( init: Nav.MYBAD, ) ));
      });
//      RouterF.of(context).put(() =>  );
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          AppLocale.of(context).getTranslated("my_account"),
          style: TextStyle(color: Colors.black),
        ),
        leading: FlatButton(
          child: Icon(Icons.arrow_back_ios, color: Color(0xFF333333)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: WidgetProfile.build(context, size, () => setState(() {})),
    );
  }

  get line =>
      Divider(thickness: 0.5, height: 1, color: Colors.black.withOpacity(0.4));
}
