class Weibo {
  String content;
  String time;
  String id;
  List<String> pics;
  String scheme; // 微博链接

  Weibo() {

  }

  Map toJson() =>
      {
        "id": id,
        "time": time,
        "content": content,
        "scheme": scheme,
        "pics": pics
      };

  Weibo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'];
    content = json['content'];
    scheme = json['scheme'];
    pics = new List<String>.from(json['pics']);
  }

  @override
  bool operator ==(other) {
    return other is Weibo && other.id == this.id;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}