import 'package:eargori/services/SoundService.dart';
import 'package:eargori/utils/SpeechToText.dart';
import 'package:eargori/utils/DynamicTextFields.dart';
import 'package:eargori/widgets/ShowText.dart';
import 'package:eargori/widgets/SoundHeader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SoundScreen extends StatefulWidget {
  const SoundScreen({super.key});

  @override
  _SoundScreenState createState() => _SoundScreenState();
}

class _SoundScreenState extends State<SoundScreen> {
  final SoundService searchService = SoundService();
  final List<Widget> _children = <Widget>[];
  double _topHeight = 40.0;
  double _bottomHeight = 60.0;

  Future<void> search(BuildContext context, String query) async {
    try {
      final result = await searchService.search(query);
      if (result != null) {
        setState(() {
          int count = 0;
          _children.clear();
          for (var sentence in result['sentences']) {
            _children.add(searchList(context, sentence['sentence'], count));
            count++;
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _increaseTopHeight() {
    if (_topHeight < 50) {
      if (_topHeight == 30.0) {
        setState(() {
          _topHeight += 20;
          _bottomHeight -= 20;
        });
      } else {
        setState(() {
          _topHeight += 10;
          _bottomHeight -= 10;
        });
      }
    }
  }

  void _increaseBottomHeight() {
    if (_bottomHeight < 70) {
      if (_bottomHeight == 50.0) {
        setState(() {
          _topHeight -= 20;
          _bottomHeight += 20;
        });
      } else {
        setState(() {
          _topHeight -= 10;
          _bottomHeight += 10;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SoundHeader(),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: _increaseTopHeight,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * (_topHeight / 100),
                color: Colors.black.withOpacity(0.8299999833106995),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(left: 20, right: 7),
                  child: SpeechToTextWidget(),
                ),
              ),
            ),
            GestureDetector(
              onTap: _increaseBottomHeight,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                height: (MediaQuery.of(context).size.height *
                        (_bottomHeight / 100)) -
                    160,
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DynamicTextFields(
                          onSearch: (text) => search(context, text)),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: _children,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container searchList(BuildContext context, String text, int index) {
    return Container(
      height: 45,
      margin: EdgeInsets.only(left: 10, top: 10),
      child: ElevatedButton(
        onPressed: () {
          showDialog(
              context: context, builder: (context) => ShowText(text: text));
        },
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFD9D9D9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
