import 'package:flutter/cupertino.dart';

class AppData with ChangeNotifier {
  bool putstate = false;
  bool isput = false;

  int cur_id = 0;
  String cur_name = '';
  String cur_desc = '';
  String cur_img = '';

  String img1kp ='';
  String img2kp ='';
  String result ='';
  String matches ='';
  String goodMatches ='';
  String score ='';

  notifyChange(){
    notifyListeners();
  }
}
