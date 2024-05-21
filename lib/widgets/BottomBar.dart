import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            offset: const Offset(0, -4),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: StylishBottomBar(
        option: AnimatedBarOptions(
          iconSize: 20,
          barAnimation: BarAnimation.fade,
          iconStyle: IconStyle.Default,
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
          opacity: 0.8,
        ),
        items: [
          BottomBarItem(
            icon: const Icon(
              CupertinoIcons.text_bubble,
              size: 30,
            ),
            title: const Text('문장'),
            selectedColor: Colors.black,
          ),
          BottomBarItem(
            icon: const Icon(
              CupertinoIcons.waveform_path,
              size: 30,
            ),
            title: const Text('음성'),
            selectedColor: Colors.black,
          ),
        ],
        //fabLocation: StylishBarFabLocation.center,
        hasNotch: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
    // return BottomNavigationBar(
    //   items: const <BottomNavigationBarItem>[
    //     BottomNavigationBarItem(
    //       icon: Icon(CupertinoIcons.text_bubble),
    //       label: '문장',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.home),
    //       label: '홈',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(CupertinoIcons.waveform_path),
    //       label: '음성',
    //     ),
    //   ],
    //   currentIndex: _selectedIndex,
    //   selectedItemColor: Colors.black,
    //   onTap: _onItemTapped,
    // );
  }

  Widget homeButton() {
    return SizedBox(
      width: 80,
      height: 80,
      child: FittedBox(
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              _selectedIndex = 2;
            });
          },
          child: const Icon(
            CupertinoIcons.house_fill,
            color: Colors.white,
            size: 30,
          ),
          shape: const CircleBorder(),
          backgroundColor: const Color(0xff2E56E3),
        ),
      ),
    );
  }
}
