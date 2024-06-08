import 'package:eargori/utils/Timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextWidget extends StatefulWidget {
  const SpeechToTextWidget({Key? key}) : super(key: key);

  @override
  SpeechToTextWidgetState createState() => SpeechToTextWidgetState();
}

class SpeechToTextWidgetState extends State<SpeechToTextWidget> {
  late stt.SpeechToText _speech;
  bool isListening = false;
  String _soundText = '재생 버튼을 눌러 말하기를 시작하세요.';

  bool _isPlaying = false;
  Widget _playIcon = Icon(
    CupertinoIcons.play_fill,
    color: Colors.white,
    size: 24,
  );
  late bool available;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void startListening() async {
    available = await _speech.initialize(
      onStatus: (val) {
        print('onStatus: $val');
        if (val == 'notListening' && _isPlaying) {
          startListening(); // 다시 듣기 시작
        }
      },
      onError: (val) => print('onError: $val'),
    );

    if (available) {
      setState(() => isListening = true);
      _speech.listen(
        onResult: (val) => setState(() {
          _soundText = val.recognizedWords;
        }),
      );
    }
    print(isListening);
  }

  void stopListening() {
    _speech.stop();
    setState(() => isListening = false);
    print(isListening);
  }

  void _playSound() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _playIcon = TimerWidget();
        startListening();
      } else {
        _playIcon = Icon(
          CupertinoIcons.play_fill,
          color: Colors.white,
          size: 24,
        );
        stopListening();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  _playSound();
                },
                icon: _playIcon),
          ],
        ),
        Text(
          _soundText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
