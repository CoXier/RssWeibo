import 'dart:io';

import 'spider.dart';
import 'weibo_data.dart';
import 'weibo.dart';
import 'dart:convert' as JSON;
import 'mail.dart';

main(List<String> arguments) async {
  var spider = Spider();
  String id = arguments[0];
  String receiver = arguments[1];
  final filename = "data/${receiver}/${id}_data.json";
  File file = File(filename);
  // 首先读出之前的数据
  WeiboData oldWeiboData;
  if (file.existsSync()) {
    String oldData = await file.readAsString();
    oldWeiboData = WeiboData.fromJson(JSON.jsonDecode(oldData));
    String newData = await spider.fetch(id);
    WeiboData newWeiboData = WeiboData.fromJson(JSON.jsonDecode(newData));
    List<Weibo> oldWeiboList = oldWeiboData.weiboList;
    List<Weibo> newWeiboList = newWeiboData.weiboList;

    List<Weibo> unReadList = List();
    for (Weibo weibo in newWeiboList) {
      if (!oldWeiboList.contains(weibo)) {
        unReadList.add(weibo);
      }
    }
    if (unReadList.isNotEmpty) {
      // 保存数据，只有数据发生变化时，才更新文件
      file.writeAsString(newData);
      Mail().sendEmail(unReadList, receiver);
    }
  } else {
    file.createSync(recursive: true);
    // 第一次查询的时候，直接写入文件
    String newData = await spider.fetch(id);
    // 保存数据
    file.writeAsString(newData);
    return;
  }

}
