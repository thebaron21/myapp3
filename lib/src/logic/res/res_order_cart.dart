import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:myapp3/src/logic/repository/my_order_repository.dart';
import '../config/end_boxs.dart';
import '../config/end_point.dart';
import '../function/res_function.dart';
import 'package:http/http.dart' as http;
class ResOrderCart {
  static String _token = Hive.box(EndBoxs.NaraApp).get("token");

  static Future setCart({Map<String, dynamic> map,String token}) async {
    try {
      var data = await ResFunction.postRes(
          url: EndPoint.addCartUrl,
          headers: ResFunction.withToken(_token),
          body: FormData.fromMap(map));
      print(data);
      return data;
    } catch (e) {
      print(e);
      return e;
    }
  }

  static Future getOrder() async {
    try {
      var data = await ResFunction.getRes(
        url: EndPoint.myOrdersUrl,
        headers: ResFunction.withToken(_token),
      );
      print(data);
      return RespoitoryMyOrder.fromJson(data["data"]["data"]);
    } catch (e) {
      throw e;
    }
  }

  static Future setPayment({addressId, paymentType}) async {
    try {
      var data = await ResFunction.postRes(
        url: EndPoint.checkout,
        headers: ResFunction.withToken(_token),
        body: {
          "address_id": addressId,
          "payment_type": paymentType,
        },
      );
      return data;
    } catch (e) {
      throw e;
    }
  }

//  static Future payoneer({
//     int addressId, File img}) async {
//    var uri = Uri.parse(EndPoint.checkout);
//
//    final request = http.MultipartRequest('POST', uri);
//    request.headers['Authorization'] = 'Bearer ' + _token;
//    request.files
//        .add(await http.MultipartFile.fromPath('payment_image', img.path));
//    request.fields['address_id'] = addressId.toString();
//    request.fields['payment_type'] = 'transfer';
//    request.send().then((value) async {
//      print(value.stream);
//      if (value.statusCode == 200) {
//        return true;
//      } else {
//      return false;
//      }
//    });
//  }

  static Future payoneer(addressId,File file) async {
//    var formData = {
//      "payment_image": file.openRead(),
//      "address_id": addressId,
//      "payment_type" : "transfer"
//    };
//    Dio _dio = Dio();
//    var data = await _dio.post(
//        EndPoint.checkout,
//        options: Options(
//          headers: ResFunction.withToken(_token),
//        ),
//      data: formData,
//    );
//    print(data.statusCode);
//    return data;
    var request = http.MultipartRequest(
      'POST', Uri.parse(EndPoint.checkout),
    );

    request.files.add(http.MultipartFile(
      'payment_image',
      file.readAsBytes().asStream(),
      file.lengthSync(),
      filename: "payment_all",
//      contentType: MediaType('image','jpeg'),
    ));
    Map<String,String> headers={
      "Authorization":"Bearer $_token",
      "Content-type": "multipart/form-data"
    };
    request.headers.addAll(headers);
    request.fields.addAll({
      "address_id": addressId.toString(),
      "payment_type" : "transfer"
    });
    print("request: "+request.toString());
    var res = await request.send();
    print("This is response:"+res.toString());
    print("Status Code : ${res.statusCode}");
    return res.statusCode;
  }

}
