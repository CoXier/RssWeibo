#coding:utf-8
import smtplib
from email.mime.text import MIMEText
from email.utils import formataddr
import sys
import json

import os

if __name__ == '__main__':
    print("========= Read config ==========")
    current_dir = os.path.dirname(os.path.abspath(__file__))
    json_file = os.path.join(current_dir, 'config.json')
    json_data = json.load(open(json_file))
    print(json_data)
    my_sender = json_data.get('email')
    my_pass = json_data.get('password')
    print("========= Start sending mail ========")
    receiver = sys.argv[1]
    msg = sys.argv[2]
    msg = MIMEText(msg, 'html', 'utf-8')
    msg['From'] = formataddr(["月老", my_sender])  # 括号里的对应发件人邮箱昵称、发件人邮箱账号
    msg['To'] = formataddr(["CoXier", receiver])  # 括号里的对应收件人邮箱昵称、收件人邮箱账号
    msg['Subject'] = "Ta更新微博啦"  # 邮件的主题，也可以说是标题

    server = smtplib.SMTP_SSL("smtp.qq.com", 465)
    server.login(my_sender, my_pass)  # 括号中对应的是发件人邮箱账号、邮箱密码
    server.sendmail(my_sender, [receiver, ], msg.as_string())  # 括号中对应的是发件人邮箱账号、收件人邮箱账号、发送邮件
    server.quit()  # 关闭连接
