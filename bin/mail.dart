import 'dart:io';
import 'weibo.dart';

class Mail {

  void sendEmail(List<Weibo> weiboList, String receiver) {
    String message = "";
    for (Weibo weibo in weiboList) {
      message += "<li>${weibo.time}:<a href='${weibo.scheme}'><br>${weibo
          .content}</a></li>";
    }
    print(message);

    Process.run('python3',
        ['pyutils/mail_utils.py', receiver, message]).then((
        ProcessResult results) {
      print(results.stdout);
    });
  }
}
