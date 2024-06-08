import 'package:eargori/controllers/SentenceController.dart';
import 'package:eargori/services/CreatePlaceService.dart';
import 'package:flutter/material.dart';

class CreatePlace extends StatefulWidget {
  final int count;
  CreatePlace({Key? key, required this.count}) : super(key: key);

  @override
  CreatePlaceState createState() => CreatePlaceState();
}

class CreatePlaceState extends State<CreatePlace> {
  String errMsg = '';
  final TextEditingController _placeController = TextEditingController();
  final CreatePlaceService _createPlaceService = CreatePlaceService();

  Future<void> _createPlace(BuildContext context) async {
    try {
      await _createPlaceService.createPlace(_placeController.text);
      if (widget.count == 0) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const SentenceController()));
      } else {
        for (int i = 0; i <= widget.count; i++) {
          Navigator.pop(context);
        }
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('장소 생성 완료!')));
    } catch (e) {
      setState(() {
        errMsg = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 300,
        height: 200,
        child: Center(
          child: Column(
            children: <Widget>[
              const Text('장소 생성'),
              const SizedBox(height: 20),
              TextField(
                controller: _placeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '장소 이름',
                ),
              ),
              const SizedBox(height: 20),
              buildText(),
              ElevatedButton(
                  onPressed: () {
                    _createPlace(context);
                  },
                  child: const Text(
                    '생성',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffDEEDFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildText() {
    return Text(errMsg, style: const TextStyle(color: Colors.red));
  }
}
