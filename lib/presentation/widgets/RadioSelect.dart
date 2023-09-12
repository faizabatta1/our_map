import 'package:flutter/material.dart';

class MultiSelect extends StatefulWidget {
  final List items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {

  int? _selectedItem = 0;

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(int itemValue) {
    setState(() {
      _selectedItem = itemValue;
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItem);
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      title: const Text('Select Topics'),
      content: SingleChildScrollView(
        child: ListBody(
          //TODO.txt:change checkbox to radio to limit test choices
          children: widget.items
              .map((item) => RadioListTile(
            value: item.id,
            groupValue: "the same value for all items",
            //  tileColor: Colors.red,
            title: Text(item.name),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (value) => _itemChange(value!),

          )
            ,

          )
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}