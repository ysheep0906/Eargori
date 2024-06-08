import 'package:eargori/views/HomeScreen.dart';
import 'package:eargori/views/SoundScreen.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MainController extends StatefulWidget {
  const MainController({super.key});

  @override
  State<MainController> createState() => MainControllerState();
}

class MainControllerState extends State<MainController> {
  final PageController _pageController = PageController();

  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    HomeScreen(),
    const SoundScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Eargori',
        theme: ThemeData(
          primaryColor: Colors.white,
          fontFamily: 'SF Pro Text',
        ),
        home: Scaffold(
          body: PageView(
            controller: _pageController,
            children: <Widget>[
              Scaffold(
                body: _pages.elementAt(_selectedIndex),
              ),
            ],
          ),
          floatingActionButton: homeButton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: Container(
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
                padding: const EdgeInsets.only(
                    left: 30, right: 30, top: 10, bottom: 10),
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
              hasNotch: false,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ),
        ));
  }

  Widget homeButton() {
    return SizedBox(
      width: 80,
      height: 80,
      child: FittedBox(
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              _selectedIndex = 0;
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
