
import 'package:SecretlyFollowHerWeibo/mailer/mailer.dart';
import 'package:SecretlyFollowHerWeibo/mailer/smtp_server/qq.dart';
import 'package:SecretlyFollowHerWeibo/mailer/src/entities/address.dart';
import 'package:SecretlyFollowHerWeibo/mailer/src/entities/message.dart';

import 'user.dart';
import 'weibo.dart';

class Mail {
  Future sendEmail(List<Weibo> weiboList, User user) async {
    String messageText = "";
    if (weiboList != null) {
      for (Weibo weibo in weiboList) {
        messageText +=
        "<li>${weibo.time}:<a href='${weibo.scheme}'><br>${weibo.content}</a></li>";
      }
    }
    print(messageText);
    var qqStmpServer = qq(user.senderEmail, user.senderPassWord);
    final message = new Message()
      ..from = new Address(user.senderEmail, '月老')
      ..subject = "Ta更新微博啦"
      ..recipients.add(user.receiverEmail)
      ..html = messageText;
    List<SendReport> sendReportList = await send(message, qqStmpServer);
    print(sendReportList[0].validationProblems);
  }
}
