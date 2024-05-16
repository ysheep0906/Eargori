import 'package:eargori/widgets/Header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const homeUrl = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: ListView(
        children: [
          buildTextField(),
          buildCommunityButton(),
          buildSentenceList(),
          buildLine(),
          buildTitleFavorites(),
          buildFavoritesList(),
        ],
      ),
    );
  }
}

Widget buildTextField() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
          width: 283,
          height: 65,
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 30),
          margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: const Offset(0, 4),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xff969696)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) => {},
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '단어나 문장을 입력하세요',
                    hintStyle: TextStyle(color: Color(0xff969696)),
                  ),
                ),
              ),
              IconButton(icon: const Icon(Icons.search), onPressed: () {}),
            ],
          )),
    ],
  );
}

Widget buildCommunityButton() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 353,
        height: 69,
        margin: const EdgeInsets.only(top: 25),
        decoration: BoxDecoration(
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
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color(0xff2E56E3),
            fixedSize: const Size(353, 69),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: const BorderSide(color: Colors.transparent),
          ),
          child: Row(
            children: [
              const Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '장소 커뮤니티',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(7),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  CupertinoIcons.chat_bubble_text_fill,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget buildSentenceList() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      buildSentenceButton('불러오기', CupertinoIcons.collections),
      const SizedBox(
        width: 17,
        height: 176,
      ), // SizedBox로 간격 조정
      buildSentenceButton('등록하기', CupertinoIcons.cloud_upload),
    ],
  );
}

Container buildSentenceButton(String text, IconData ico) {
  return Container(
    width: 168,
    height: 176,
    margin: const EdgeInsets.only(top: 25),
    decoration: BoxDecoration(
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
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xffDEEDFF),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    '장소 별 언어',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    ico,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

// 선 긋기
Widget buildLine() {
  return Container(
    width: double.infinity,
    height: 1,
    margin: const EdgeInsets.only(top: 25, bottom: 30),
    color: const Color(0xffC2C2C2),
  );
}

Widget buildTitleFavorites() {
  return const Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SizedBox(width: 20),
      Text(
        '내 즐겨찾기',
        style: TextStyle(
          color: Colors.black,
          fontSize: 32,
          fontWeight: FontWeight.w600,
        ),
      )
    ],
  );
}

Widget buildFavoritesList() {
  return SizedBox(
    width: double.infinity,
    child: Column(
      children: [
        buildFavoriteItem(
          '얼마에요?',
          isFavorite: true,
        ),
        buildFavoriteItem(
          '얼마에요?',
          isFavorite: true,
        ),
        buildFavoriteItem(
          '얼마에요?',
          isFavorite: true,
        ),
        buildFavoriteItem(
          '얼마에요?',
          isFavorite: true,
        ),
        buildFavoriteItem(
          '얼마에요?',
          isFavorite: true,
        ),
      ],
    ),
  );
}

Container buildFavoriteItem(String text, {bool isFavorite = false}) {
  return Container(
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
            Text(text,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 27,
                  fontWeight: FontWeight.w600,
                ))
          ],
        )),
        const Favorite(),
      ],
    ),
  );
}

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => FavoriteState();
}

class FavoriteState extends State<Favorite> {
  bool _boolStatus = false;
  Color _statusColor = Colors.grey;

  void _btnFavorite() {
    setState(() {
      if (_boolStatus == true) {
        _boolStatus = false;
        _statusColor = Colors.grey;
      } else {
        _boolStatus = true;
        _statusColor = Colors.black;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.star,
        size: 30,
      ),
      color: _statusColor,
      onPressed: _btnFavorite,
    );
  }
}
