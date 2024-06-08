import 'dart:async';

import 'package:eargori/services/RegiSentenceService.dart';
import 'package:eargori/widgets/CreatePlace.dart';
import 'package:eargori/widgets/DeletePlace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const double _kItemExtent = 32.0;
List<Map<String, dynamic>> placeNames = <Map<String, dynamic>>[];
int _selectedPlace = 0;

class RegiSentence extends StatefulWidget {
  const RegiSentence({super.key});

  @override
  State<RegiSentence> createState() => RegiSentenceState();
}

class RegiSentenceState extends State<RegiSentence> {
  final TextEditingController _sentenceController = TextEditingController();
  final RegiSentenceService _regiSentenceService = RegiSentenceService();
  Future<void>? _placeFuture;
  String errMsg = '';

  @override
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
      final response = await _regiSentenceService.getPlace();
      if (response != null) {
        print('Places: $response');
        setState(() {
          for (var place in response['places']) {
            placeNames.add(place);
          }
        });

        print(placeNames.length);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _createSentence(BuildContext context) async {
    try {
      final response = await _regiSentenceService.createSentence(
        _sentenceController.text,
        placeNames[_selectedPlace]['_id'],
      );
      if (response != null) {
        print('Sentence: $response');
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        errMsg = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _placeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return AlertDialog(
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 310,
                  height: 380,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(CupertinoIcons.clear)),
                        ],
                      ),
                      BuildPlace(),
                      buildTextField(),
                      buildText(),
                      buildButton(context, '등록'),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }

  Widget buildText() {
    return Text(errMsg, style: const TextStyle(color: Colors.red));
  }

  Widget buildTextField() {
    return Container(
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
        child: Center(
          child: Expanded(
            child: TextField(
              controller: _sentenceController,
              onChanged: (value) => {},
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '단어나 문장을 입력하세요',
                hintStyle: TextStyle(color: Color(0xff969696)),
              ),
            ),
          ),
        ));
  }

  Container buildButton(BuildContext context, String text) {
    return Container(
      width: 100,
      height: 50,
      margin: const EdgeInsets.only(top: 20),
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
            _createSentence(context);
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color(0xffDEEDFF),
            fixedSize: const Size(283, 65),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: const BorderSide(color: Colors.transparent),
          ),
          child: Text(text,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ))),
    );
  }
}

class BuildPlace extends StatefulWidget {
  const BuildPlace({super.key});

  @override
  State<BuildPlace> createState() => BuildPlaceState();
}

class BuildPlaceState extends State<BuildPlace> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      context: context, builder: (context) => CreatePlace(count: 1))
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
                          place: placeNames[_selectedPlace]['_id'], count: 1))
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
    );
  }
}
