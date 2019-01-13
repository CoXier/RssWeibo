import 'dart:convert' as JSON;
import 'dart:io';
import 'weibo_data.dart';

import 'weibo.dart';

class Spider {
  static const String url = "https://m.weibo.cn/api/container/getIndex?type=uid&value=";

  Future<String> fetch(String id) async {
    var containerId = await getContainerId(id);
    var containerInfoUrl = url + id + "&containerid=" + containerId;
    List<Weibo> allWeibo = List();
    List<Weibo> page = await fetchLatestWeibo(containerInfoUrl);
    var pageIndex = 2;
    while (page.length != 0) {
      allWeibo.addAll(page);
      containerInfoUrl = containerInfoUrl + "&page=" + pageIndex.toString();
      pageIndex++;
      page = await fetchLatestWeibo(containerInfoUrl);
    }
    WeiboData weiboData = WeiboData();
    weiboData..weiboList = allWeibo;
    String result = JSON.jsonEncode(weiboData);
    return result;
  }

  Future<String> getContainerId(String id) async {
    var jsonResponse = await getResponse(url + id);
    return jsonResponse['data']['tabsInfo']['tabs'][1]['containerid'];
  }


  Future<List<Weibo>> fetchLatestWeibo(String weiboInfoUrl) async {
    var jsonResponse = await getResponse(weiboInfoUrl);
    List cards = jsonResponse['data']['cards'];
    List<Weibo> weiboList = List();
    for (int i = 0; i < cards.length; i++) {
      Weibo weibo = Weibo();
      if (cards[i]['mblog']['retweeted_status'] == null &&
          cards[i]['mblog']['source'] != "生日动态"
          && cards[i]['mblog']['source'] != "超话") {
        weibo.content = cards[i]['mblog']['text'];
        weibo.time = cards[i]['mblog']['created_at'];
        weibo.id = cards[i]['itemid'];
        weibo.scheme = cards[i]['scheme'];
        List pics = cards[i]['mblog']['pics'];
        List<String> weiPics = List();
        weibo.pics = weiPics;
        if(pics != null) {
          for(int j =0; j < pics.length; j++) {
            weiPics.add(pics[j]['large']['url']);
          }
        }
        weiboList.add(weibo);
      }
    }
    return weiboList;
  }

  Future<Map> getResponse(String url) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    String responseBody = await response.transform(JSON.utf8.decoder).join();
    Map jsonResponse = JSON.jsonDecode(responseBody);
    httpClient.close();
    return jsonResponse;
  }

}