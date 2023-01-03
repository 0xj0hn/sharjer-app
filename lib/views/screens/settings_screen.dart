import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:mojtama/models/theme_model.dart';
import 'package:mojtama/services/user_api_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

var box = Hive.box("theme");

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "تنظیمات",
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              width: 50,
              height: 50,
            ),
          ),
          Divider(
            indent: 8,
            endIndent: 8,
            height: 0.5,
          ),
          Padding(
            padding: EdgeInsets.all(7),
            child: Consumer<ThemeModel>(builder: (context, model, child) {
              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                title: Text(
                  "تم تیره: ",
                  style: TextStyle(
                      fontSize: 14, color: Theme.of(context).primaryColor),
                ),
                leading: Icon(
                  Icons.dark_mode,
                ),
                subtitle: !model.isDarkMode
                    ? Text(
                        "برای کمتر آسیب دیدن چشم، توصیه می‌شود تم تیره را فعال کنید.")
                    : null,
                trailing: Checkbox(
                  value: model.isDarkMode,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (x) {
                    model.toggleTheme();
                    // SystemChrome.setSystemUIOverlayStyle(
                    //   SystemUiOverlayStyle.light,
                    // ); TODO after update flutter to 3.0
                  },
                ),
                horizontalTitleGap: 2,
                onTap: () {
                  model.toggleTheme();
                },
              );
            }),
          ),
          Divider(
            height: 0.5,
            indent: 8,
            endIndent: 8,
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              title: Text("راه ارتباطی با برنامه‌نویس در پیامرسان بله"),
              subtitle: Text(
                  "اطلاعات کامل سفارش خود را به پیوی ارسال نمایید. (با فشردن این قسمت وارد محیط برنامه بله شوید.)"),
              onTap: () {
                launchUrlString("http://ble.im/JohnPeterson",
                    mode: LaunchMode.externalNonBrowserApplication);
              },
            ),
          ),
          Divider(
            height: 0.5,
            indent: 8,
            endIndent: 8,
          ),
          UpdateApp(),
        ],
      ),
    );
  }
}

class UpdateApp extends StatelessWidget {
  @override
  UserProvider userProvider = UserProvider();
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userProvider.checkApplicationVersion(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data["status"] == "updated") {
            return Container(
              child: TextButton(
                child: Text("نسخه اپلیکیشن شما بروز می‌باشد."),
                onPressed: () {},
              ),
            );
          } else if (snapshot.data["status"] == "not updated") {
            return Container(
              child: TextButton(
                child: Text("نسخه‌ی اپلیکیشن شما: " +
                    snapshot.data["version"] +
                    ". (برای دانلود، ضربه بزنید)"),
                onPressed: () {
                  launchUrlString(snapshot.data["link"],
                      mode: LaunchMode.externalApplication);
                },
              ),
            );
          }
        } else {
          return SpinKitCircle(
            color: Theme.of(context).primaryColor,
            size: 25,
          );
        }
        return Container();
      },
    );
  }
}