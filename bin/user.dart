import 'dart:io';
import 'dart:convert' as JSON;

class User {
  String senderEmail;
  String senderPassWord;
  String receiverEmail;
  String rssWeiboId;

  User.fromFile(String path) {
    File file = File(path);
    String data = file.readAsStringSync();
    Map json = JSON.jsonDecode(data);
    senderEmail = json['email'];
    senderPassWord = json['password'];
    receiverEmail = json['receiver_email'];
    rssWeiboId = json['rss_weibo_id'];
  }


}