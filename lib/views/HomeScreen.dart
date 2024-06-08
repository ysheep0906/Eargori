import 'package:eargori/controllers/CommunityController.dart';
import 'package:eargori/controllers/ReSearchController.dart';
import 'package:eargori/controllers/SentenceController.dart';
import 'package:eargori/services/HomeService.dart';
import 'package:eargori/services/SearchService.dart';
import 'package:eargori/services/SentenceService.dart';
import 'package:eargori/widgets/Header.dart';
import 'package:eargori/widgets/RegiSentence.dart';
import 'package:eargori/widgets/ShowText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeService _homeService = HomeService();
  final SearchService _searchService = SearchService();
  final SentenceService _sentenceService = SentenceService();
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _favorites = [];

  @override
  void initState() {
    super.initState();
    _getFavorites();
  }

  Future<void> _getFavorites() async {
    try {
      final response = await _homeService.getFavorites();
      if (response != null) {
        setState(() {
          _favorites.clear();
          for (var i = 0; i < response['sentences'].length; i++) {
            _favorites.add({
              'sentence': response['sentences'][i]['sentence'],
              'favorite': response['sentences'][i]['favorite']
            });
          }
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _favorite(String sentence, int index) async {
    try {
      final response = await _sentenceService.favorite(sentence);
      if (response != null) {
        setState(() {
          _favorites[index]['favorite'] = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _unfavorite(String sentence, int index) async {
    try {
      final response = await _sentenceService.unfavorite(sentence);
      if (response != null) {
        setState(() {
          _favorites[index]['favorite'] = false;
          _favorites.removeAt(index);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildTextField(context),
            buildCommunityButton(context),
            buildSentenceList(context),
            buildLine(),
            buildTitleFavorites(),
            buildFavoritesList(context),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(BuildContext context) {
    return Container(
      width: 283,
      height: 65,
      margin: const EdgeInsets.only(top: 20),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ReSearchController()));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: const BorderSide(color: Color(0xff969696)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('단어나 문장을 입력하세요', style: TextStyle(color: Color(0xff969696))),
            Icon(Icons.search, size: 30, color: Color(0xff969696))
          ],
        ),
      ),
    );
  }

  Widget buildCommunityButton(BuildContext context) {
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
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CommunityController()));
            },
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

  Widget buildSentenceList(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildSentenceButton(context, '불러오기', CupertinoIcons.collections),
        const SizedBox(
          width: 17,
          height: 176,
        ), // SizedBox로 간격 조정
        buildSentenceButton(context, '등록하기', CupertinoIcons.cloud_upload),
      ],
    );
  }

  Container buildSentenceButton(
      BuildContext context, String text, IconData ico) {
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
        onPressed: () {
          if (text == '불러오기') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SentenceController()));
          }
          if (text == '등록하기') {
            showDialog(context: context, builder: (context) => RegiSentence());
          }
        },
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

  Widget buildFavoritesList(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          for (var i = 0; i < _favorites.length; i++)
            buildFavoriteItem(context, _favorites[i]['sentence'], i,
                isFavorite: _favorites[i]['favorite']),
        ],
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
            FavoriteIconButton(
              isFavorite: isFavorite,
              onPressed: (bool isFavorite) {
                try {
                  if (_favorites[index]['favorite'] == true) {
                    _unfavorite(_favorites[index]['sentence'], index);
                  } else {
                    _favorite(_favorites[index]['sentence'], index);
                  }
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteIconButton extends StatefulWidget {
  final bool isFavorite;
  final Function(bool isFavorite) onPressed;

  const FavoriteIconButton({
    Key? key,
    required this.isFavorite,
    required this.onPressed,
  }) : super(key: key);

  @override
  _FavoriteIconButtonState createState() => _FavoriteIconButtonState();
}

class _FavoriteIconButtonState extends State<FavoriteIconButton> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isFavorite ? CupertinoIcons.star_fill : CupertinoIcons.star,
        color: _isFavorite ? Colors.black : Colors.grey,
      ),
      onPressed: () {
        widget.onPressed(_isFavorite);
      },
    );
  }
}
