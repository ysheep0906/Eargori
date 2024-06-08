import 'package:eargori/services/CommunityService.dart';
import 'package:eargori/views/ShowArticleScreen.dart';
import 'package:eargori/widgets/CommunityHeader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final CommunityService communityService = CommunityService();
  final List<Map<String, dynamic>> articles = <Map<String, dynamic>>[];
  final List<Widget> _children = <Widget>[];
  Future<void>? _placeFuture;

  Future<void> getArticles() async {
    try {
      final result = await communityService.getArticles();
      if (result != null) {
        setState(() {
          int count = 0;
          _children.clear();
          articles.clear();
          for (var article in result['articles']) {
            DateTime dateTime = DateTime.parse(article['createdAt']);
            String date =
                "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
            String time =
                "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
            articles.insert(0, article);
            _children.insert(
                0,
                buildArticleButton(
                    context,
                    article['title'],
                    article['username'],
                    "$date $time",
                    article['description'],
                    count));
            count++;
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _placeFuture = getArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommunityHeader(),
      body: FutureBuilder<void>(
        future: _placeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView(
              children: [
                buildArticlesList(context),
              ],
            );
          }
        },
      ),
    );
  }

  Widget buildArticlesList(BuildContext context) {
    return Column(
      children: _children,
    );
  }

  String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, 26) +
          '\n' +
          text.substring(26, maxLength) +
          '...';
    }
  }

  Container buildArticleButton(BuildContext context, String title,
      String author, String date, String content, int index) {
    String truncatedText = truncateText(
      content,
      35, // 최대 글자 수
    );
    return Container(
      width: double.infinity,
      height: 130,
      margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            offset: const Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: OutlinedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ShowArticleScreen(data: articles[index]);
          }));
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Colors.transparent),
          padding: const EdgeInsets.all(0),
          fixedSize: const Size(168, 176),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.person_alt_circle,
                        size: 20,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10),
                      Text(author,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  Text(
                    date,
                    style: TextStyle(
                        color: Color(0xFF746F6F),
                        fontSize: 10,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    truncatedText,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
