import 'package:eargori/services/ShowArticleService.dart';
import 'package:eargori/widgets/CommunityHeader.dart';
import 'package:eargori/widgets/Header.dart';
import 'package:eargori/widgets/ShowText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ShowArticleScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const ShowArticleScreen({required this.data});

  @override
  ShowArticleScreenState createState() => ShowArticleScreenState();
}

class ShowArticleScreenState extends State<ShowArticleScreen> {
  late Map<String, dynamic> data;
  final List<Widget> _children = <Widget>[];
  final ShowArticleService showArticleService = ShowArticleService();
  Future<void>? _placeFuture;

  Future<void> getSentences() async {
    try {
      final result =
          await showArticleService.getSentences(data['content']['sentences']);
      if (result != null) {
        setState(() {
          int count = 0;
          _children.clear();
          for (var sentence in result['sentences']) {
            _children
                .add(buildFavoriteItem(context, sentence['sentence'], count));
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
    data = widget.data;
    _placeFuture = getSentences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: FutureBuilder<void>(
        future: _placeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView(
              children: [buildTitle(), buildContent(), buildFavoritesList()],
            );
          }
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        '장소 커뮤니티',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(CupertinoIcons.back),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Container(
          color: Color(0xffC2C2C2), // #C2C2C2
          height: 1.0, // Border width
        ),
      ),
    );
  }

  Widget buildTitle() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.person_alt_circle,
                size: 40,
              ),
              const SizedBox(width: 10),
              Text(data['username'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            ],
          ),
          Text(data['createdAt'],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF746F6F),
                fontSize: 13,
                fontWeight: FontWeight.w300,
              )),
        ],
      ),
    );
  }

  Widget buildContent() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['title'],
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Text(
              data['description'],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFavoritesList() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: double.infinity,
      child: Column(
        children: _children,
      ),
    );
  }

  GestureDetector buildFavoriteItem(
      BuildContext context, String text, int index,
      {bool isFavorite = false}) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => ShowText(text: text),
        );
      },
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xffBBBBBB),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 30, right: 20),
              width: 5,
              height: 5,
              color: Colors.black,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 27,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
