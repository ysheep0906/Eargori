import 'package:eargori/services/SoundService.dart';
import 'package:flutter/material.dart';

class DynamicTextFields extends StatefulWidget {
  final Function(String) onSearch;

  DynamicTextFields({required this.onSearch});

  @override
  DynamicTextFieldsState createState() => DynamicTextFieldsState();
}

class DynamicTextFieldsState extends State<DynamicTextFields> {
  final SoundService searchService = SoundService();
  List<Widget> textFields = [];
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    addTextField();
  }

  void addTextField() {
    final controller = new TextEditingController();
    controllers.add(controller);

    final index = textFields.length;
    final textField = ListTile(
      title: TextField(
        controller: controller,
        onChanged: (text) {
          if (index == textFields.length - 1) {
            widget.onSearch(text);
          }
        },
        onSubmitted: (text) {
          addTextField();
        },
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: '입력해주세요.',
          hintStyle: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: Colors.black.withOpacity(0.2),
          ),
          contentPadding: EdgeInsets.only(left: 20, right: 7),
        ),
      ),
      trailing: IconButton(
        onPressed: () {
          setState(() {
            textFields.removeAt(index);
            controllers.removeAt(index);
          });
        },
        icon: Icon(Icons.delete),
      ),
    );

    setState(() {
      textFields.add(textField);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: textFields,
    );
  }
}
