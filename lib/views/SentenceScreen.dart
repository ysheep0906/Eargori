import 'package:eargori/services/SentenceService.dart';
import 'package:eargori/widgets/CreatePlace.dart';
import 'package:eargori/widgets/DeletePlace.dart';
import 'package:eargori/widgets/Header.dart';
import 'package:eargori/widgets/ShowText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

const double _kItemExtent = 32.0;
List<Map<String, dynamic>> placeNames = <Map<String, dynamic>>[];
int _selectedPlace = 0;
List<Map<String, dynamic>> sentences = <Map<String, dynamic>>[];

class SentenceScreen extends StatefulWidget {
  const SentenceScreen({super.key});

  @override
  State<SentenceScreen> createState() => SentenceScreenState();
}

class SentenceScreenState extends State<SentenceScreen> {
  final SentenceService _sentenceService = SentenceService();
  Future<void>? _placeFuture;

  void initState() {
    super.initState();
    setState(() {
      placeNames.clear();
      _selectedPlace = 0;
    });
    _placeFuture = _getPlace();
  }

  Future<void> _getPlace() async {
    try {
      final response = await _sentenceService.getPlace();
      if (response != null) {
        setState(() {
          for (var place in response['places']) {
            placeNames.add(place);
          }
        });
      }
      _getSentences(placeNames[_selectedPlace]['_id']);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getSentences(String placeId) async {
    try {
      final response = await _sentenceService.getSentences(placeId);
      if (response != null) {
        setState(() {
          sentences.clear();
          for (var sentence in response['sentences']) {
            sentences.add(sentence);
          }
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
      body: FutureBuilder<void>(
        future: _placeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return BuildPlace();
          }
        },
      ),
    );
  }
}

class BuildPlace extends StatefulWidget {
  const BuildPlace({super.key});

  @override
  State<BuildPlace> createState() => BuildPlaceState();
}

class BuildPlaceState extends State<BuildPlace> {
  final SentenceService _sentenceService = SentenceService();
  final List<Widget> _children = <Widget>[];

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  Future<void> _getSentences(String placeId) async {
    try {
      final response = await _sentenceService.getSentences(placeId);
      if (response != null) {
        setState(() {
          sentences.clear();
          _children.clear();
          int count = 0;
          for (var sentence in response['sentences']) {
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
    _getSentences(placeNames[_selectedPlace]['_id']);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Container(
        width: 280,
        height: 140,
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: ShapeDecoration(
          color: Color(0xFFE8FFDE),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '장소',
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: () {
                    _showDialog(CupertinoPicker(
                      magnification: 1.22,
                      squeeze: 1.2,
                      useMagnifier: true,
                      itemExtent: _kItemExtent,
                      // This sets the initial item.
                      scrollController: FixedExtentScrollController(
                        initialItem: _selectedPlace,
                      ),
                      // This is called when selected item is changed.
                      onSelectedItemChanged: (int selectedItem) {
                        setState(() {
                          _selectedPlace = selectedItem;
                          _getSentences(placeNames[_selectedPlace]['_id']);
                        });
                      },
                      children:
                          List<Widget>.generate(placeNames.length, (int index) {
                        return Center(child: Text(placeNames[index]['place']));
                      }),
                    ));
                  },
                  icon: const Icon(CupertinoIcons.bars),
                ),
              ],
            ),
            Text(
              placeNames[_selectedPlace]['place'],
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => {
                    showDialog(
                        context: context,
                        builder: (context) => CreatePlace(count: 0))
                  },
                  icon: Icon(
                    CupertinoIcons.add_circled,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                IconButton(
                  onPressed: () => {
                    showDialog(
                        context: context,
                        builder: (context) => DeletePlace(
                            place: placeNames[_selectedPlace]['_id'], count: 0))
                  },
                  icon: Icon(
                    CupertinoIcons.delete,
                    color: Colors.black.withOpacity(0.5),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      buildFavoritesList()
    ]);
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
