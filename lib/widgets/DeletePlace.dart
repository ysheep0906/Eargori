import 'package:eargori/controllers/SentenceController.dart';
import 'package:eargori/services/DeletePlaceService.dart';
import 'package:flutter/material.dart';

class DeletePlace extends StatelessWidget {
  final String place;
  final int count;
  final DeletePlaceService _deletePlaceService = DeletePlaceService();
  DeletePlace({required this.place, required this.count});

  Future<void> deletePlace(BuildContext context) async {
    try {
      await _deletePlaceService.deletePlace(place);
      if (count == 0) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const SentenceController()));
      } else {
        for (int i = 0; i <= count; i++) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      print('Error in deletePlace: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 300,
        height: 140,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              const Text(
                '정말 삭제하시겠습니까?',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              const Text(
                '장소에 담겨있는 모든 문장이 삭제됩니다.',
                style:
                    TextStyle(fontWeight: FontWeight.w700, color: Colors.red),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    deletePlace(context);
                  },
                  child: const Text(
                    '삭제',
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
}
