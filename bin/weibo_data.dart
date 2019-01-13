import 'weibo.dart';

class WeiboData {
  List<Weibo> weiboList;
  Map toJson() {
    return {
      "Data": weiboList
    };
  }

  WeiboData() {

  }

  WeiboData.fromJson(Map json) {
    var list = json['Data'] as List;
    weiboList = list.map((weibo) => Weibo.fromJson(weibo)).toList();
  }
}