import 'package:eargori/services/SearchService.dart';
import 'package:eargori/services/SentenceService.dart';
import 'package:eargori/widgets/Header.dart';
import 'package:eargori/widgets/ShowText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final SearchService searchService = SearchService();
  final SentenceService _sentenceService = SentenceService();
  List<Map<String, dynamic>> sentences = <Map<String, dynamic>>[];
  final List<Widget> _children = <Widget>[];
  String searchText = '';

  Future<void> search(BuildContext context, String query) async {
    try {
      final result = await searchService.search(query);
      if (result != null) {
        setState(() {
          int count = 0;
          sentences.clear();
          _children.clear();
          for (var sentence in result['sentences']) {
            sentences.add(sentence);
            _children.add(buildFavoriteItem(
                context, sentence['sentence'], count,
                isFavorite: sentence['favorite']));
            count++;
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _favorite(String sentence, int index) async {
    try {
      final response = await _sentenceService.favorite(sentence);
      if (response != null) {
        setState(() {
          sentences[index]['favorite'] = true;
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
          sentences[index]['favorite'] = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(searchText);
    return Scaffold(
      appBar: Header(),
      body: ListView(
        children: [
          buildTextField(),
          buildFavoritesList(),
        ],
      ),
    );
  }

  Widget buildTextField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: 283,
            height: 65,
            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 30),
            margin: const EdgeInsets.only(top: 20, bottom: 40),
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
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '단어나 문장을 입력하세요',
                      hintStyle: TextStyle(color: Color(0xff969696)),
                    ),
                  ),
                ),
                IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      search(context, _controller.text);
                    }),
              ],
            )),
      ],
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
            FavoriteIconButton(
              isFavorite: isFavorite,
              onPressed: (bool isFavorite) {
                try {
                  if (sentences[index]['favorite'] == true) {
                    _unfavorite(sentences[index]['sentence'], index);
                  } else {
                    _favorite(sentences[index]['sentence'], index);
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
        setState(() {
          _isFavorite = !_isFavorite;
        });
        widget.onPressed(_isFavorite);
      },
    );
  }
}
