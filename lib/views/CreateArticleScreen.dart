import 'package:eargori/controllers/CommunityController.dart';
import 'package:eargori/services/CreateArticleService.dart';
import 'package:eargori/widgets/CreatePlace.dart';
import 'package:eargori/widgets/DeletePlace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateArticleScreen extends StatefulWidget {
  const CreateArticleScreen({super.key});

  @override
  State<CreateArticleScreen> createState() => CreateArticleScreenState();
}

class CreateArticleScreenState extends State<CreateArticleScreen> {
  final CreateArticleService _createArticleService = CreateArticleService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> createArticle(BuildContext context) async {
    try {
      final response = await _createArticleService.createArticle(
          titleController.text,
          descriptionController.text,
          placeNames[_selectedPlace]['_id']);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CommunityController()));
      print(response);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const BuildPlace(),
            buildTitleTextField('제목'),
            buildDescriptionTextField('내용을 입력하세요'),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        '글 쓰기',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(CupertinoIcons.back),
      ),
      actions: [
        buildButton(context, '완료'),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Container(
          color: Color(0xffC2C2C2), // #C2C2C2
          height: 1.0, // Border width
        ),
      ),
    );
  }

  Container buildButton(BuildContext context, String text) {
    return Container(
      margin:
          EdgeInsets.only(right: 16.0), // Add margin to align button properly
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: OutlinedButton(
        onPressed: () {
          createArticle(context);
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          fixedSize: const Size(56, 27),
          backgroundColor: const Color(0xffDEEDFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: const BorderSide(color: Colors.transparent),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.w600,
            height: 0.08,
            letterSpacing: -0.32,
          ),
        ),
      ),
    );
  }

  Widget buildTitleTextField(String hintText) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: TextField(
        controller: titleController,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 20,
            color: Color(0xffC2C2C2),
            fontWeight: FontWeight.w600,
          ),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffC2C2C2),
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffC2C2C2),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDescriptionTextField(String hintText) {
    return Container(
      height: 500,
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: SingleChildScrollView(
        child: TextField(
          controller: descriptionController,
          maxLines: null,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            hintStyle: const TextStyle(
              fontSize: 20,
              color: Color(0xffC2C2C2),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

const double _kItemExtent = 32.0;
List<Map<String, dynamic>> placeNames = <Map<String, dynamic>>[];
int _selectedPlace = 0;

class BuildPlace extends StatefulWidget {
  const BuildPlace({super.key});

  @override
  State<BuildPlace> createState() => BuildPlaceState();
}

class BuildPlaceState extends State<BuildPlace> {
  final CreateArticleService _createArticleService = CreateArticleService();
  final List<Widget> _children = <Widget>[];
  Future<void>? _placeFuture;

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
      final response = await _createArticleService.getPlace();
      print(response);
      if (response != null) {
        setState(() {
          for (var place in response['places']) {
            placeNames.add(place);
          }
        });
      }
    } catch (e) {
      print(e);
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
                          children: List<Widget>.generate(placeNames.length,
                              (int index) {
                            return Center(
                                child: Text(placeNames[index]['place']));
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
                                place: placeNames[_selectedPlace]['_id'],
                                count: 0))
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
      },
    );
  }
}
