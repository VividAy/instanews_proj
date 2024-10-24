import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

class imgp{
  imgp();
  String? getImg(String url){
    String? ret;

    getImageUrlFromLink(url).then((result){
      ret = result;
    });
    print(ret);
    return ret;
  }

  Future<String?> getImageUrlFromLink(String url) async {
    try {
      // Fetch the webpage content
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse the HTML
        var document = html.parse(response.body);

        // Find the first <img> tag
        var imgTag = document.querySelector('img');

        if (imgTag != null) {
          // Return the value of the src attribute
          return imgTag.attributes['src'];
        }
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }
}