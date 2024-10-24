import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class datapkg {
  String i, des, title, link;
  List<String> tags = [];

  datapkg(this.i, this.des, this.title, this.link);

  String getImageURL() {
    return this.i;
  }

  String getDescription() {
    return this.des;
  }

  String getTitle() {
    return this.title;
  }

  void addTag(String t) {
    tags.add(t);
  }

  bool checkTag(String t) {
    return tags.contains(t);
  }

  // Method to convert datapkg to JSON
  Map<String, dynamic> toJson() {
    return {
      'i': i,
      'des': des,
      'title': title,
      'link': link,
      'tags': tags
    };
  }

  // Method to create a datapkg from JSON
  factory datapkg.fromJson(Map<String, dynamic> json) {
    var newPkg = datapkg(json['i'], json['des'], json['title'], json['link']);
    newPkg.tags = List<String>.from(json['tags']);
    return newPkg;
  }

  // Method to send data to the server
  Future<void> sendData() async {
    var httpClient = HttpClient();
    var uri = Uri.parse('http://172.20.10.3:3000/add');  // Replace with your machine's IP and port 3000
    var request = await httpClient.postUrl(uri);
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(toJson())));
    var response = await request.close();

    if (response.statusCode == HttpStatus.ok) {
      print('Data package added successfully');
    } else {
      print('Failed to add data package');
    }
  }

  // Method to get data from the server
  static Future<List<datapkg>> getData() async {
    var httpClient = HttpClient();
    var uri = Uri.parse('http://172.20.10.3:3000/data');  // Replace with your machine's IP and port 3000
    var request = await httpClient.getUrl(uri);
    var response = await request.close();

    if (response.statusCode == HttpStatus.ok) {
      var responseBody = await response.transform(utf8.decoder).join();
      List<dynamic> data = jsonDecode(responseBody);
      return data.map((json) => datapkg.fromJson(json)).toList();
    } else {
      print('Failed to fetch data packages');
      return [];
    }
  }
}

class dataStorage {
  dataStorage();
  static List<datapkg> data = [];
  static int numPkgs = 0;
  static int lit = 0;
  static int sci = 0;
  static int design = 0;
  static int article = 0;

  Future<void> addData(String img, String desc, String title, String link, List<String> tags) async {
    datapkg r = datapkg(img, desc, title, link);
    for (String i in tags) {
      r.addTag(i);
      if (i == 'Article Review') {
        article++;
      }
      if (i == 'Literature') {
        lit++;
      }
      if (i == 'Science Research') {
        sci++;
      }
      if (i == '3D Art and Design') {
        design++;
      }
    }
    await r.sendData();  // Send data to the server
    data.add(r);
    numPkgs++;
  }

  Future<void> fetchData() async {
    data = await datapkg.getData();  // Get data from the server
    numPkgs = data.length;
    // Reset counts
    article = 0;
    lit = 0;
    sci = 0;
    design = 0;
    // Recalculate counts
    for (var pkg in data) {
      for (var tag in pkg.tags) {
        if (tag == 'Article Review') {
          article++;
        }
        if (tag == 'Literature') {
          lit++;
        }
        if (tag == 'Science Research') {
          sci++;
        }
        if (tag == '3D Art and Design') {
          design++;
        }
      }
    }
  }

  int getarticle() {
    return article;
  }

  int getdesign() {
    return design;
  }

  int getsci() {
    return sci;
  }

  int getlit() {
    return lit;
  }

  // Method to update the description of an existing entry
  void setDesc(int index, String desc) {
    data[index] = datapkg(data[index].i, desc, data[index].title, data[index].link);
  }

  void setImg(int index, String img) {
    data[index] = datapkg(img, data[index].des, data[index].title, data[index].link);
  }

  void setTitle(int index, String title) {
    data[index] = datapkg(data[index].i, data[index].des, title, data[index].link);
  }

  Future<datapkg> getData(int index) async {
    await fetchData();
    return data.elementAt(index);
  }

  String getLink(int index) {
    return data[index].link;
  }

  Future<int> getNumPkgs() async {
    await fetchData();
    return numPkgs;
  }
}
