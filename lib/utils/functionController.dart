import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive/hive.dart';

class AdminAPI extends GetConnect {
  final host = "http://localhost/mojtama/src/adminpanel";
  // var host = "http://localhost/mojtama/src/adminpanel";

  changeMonthPrices(year, {List? months}) async {
    var moharam = months![0];
    var safar = months[1];
    var rabi1 = months[2];
    var rabi2 = months[3];
    var jamadi1 = months[4];
    var jamadi2 = months[5];
    var rajab = months[6];
    var shaban = months[7];
    var ramezan = months[8];
    var shaval = months[9];
    var zighade = months[10];
    var zihaje = months[11];
    var structure = {
      year: {
        "محرم": moharam,
        "صفر": safar,
        "ربیع الاول": rabi1,
        "ربیع الثانی": rabi2,
        "جمادی الاول": jamadi1,
        "جمادی الثانی": jamadi2,
        "رجب": rajab,
        "شعبان": shaban,
        "رمضان": ramezan,
        "شوال": shaval,
        "ذی القعده": zighade,
        "ذی الحجه": zihaje,
      },
    };

    Map<String, dynamic> payload = {
      "monthPrices": jsonEncode(structure),
    };

    Response request = await post(
      "$host/changeMonthPrice.php",
      FormData(payload),
    );
    return request.body;
  }

  Future<dynamic> getUsersList() async {
    String username =
        Hive.box("auth").get("username"); //get username from hive database
    String password =
        Hive.box("auth").get("password"); //get password from hive database

    var data = {
      "username": username,
      "password": password,
    };
    //Uri url = Uri.parse("${host}/adminpanel/get_members_list.php");
    Response req = await post(host + "/get_members_list.php", FormData(data));
    var js;

    try {
      js = jsonDecode(req.body);
    } catch (e) {
      Get.snackbar(
        "وضعیت",
        "خروجی دریافت شده نامعتبر می‌باشد.",
      );
    }

    return js;
  }

  addCharge(
    username,
    password,
    targetBluck,
    targetVahed,
    targetYear,
    targetMonth,
  ) async {
    var data = {
      "username": username,
      "password": password,
      "bluck": targetBluck,
      "vahed": targetVahed,
      "year": targetYear,
      "month": targetMonth,
    };

    var req = await post(host + "/addCharge.php", FormData(data));
    var js = jsonDecode(req.body);
    return js["status"];
  }

  getMonthPrices() async {
    String route = "../payment/info.json";
    Response req;
    try {
      req = await get(host + "/" + route);
    } catch (e) {
      return [
        {"test": "test"}
      ];
    }
    return req.body;
  }
}

class UserAPI extends GetConnect {
  final host = "http://localhost/mojtama/src/userapi";
  getDatabaseYears() async {
    var url = Uri.parse("$host/get_years.php");
    Response req = await get(host);
    return req.body;
  }
}