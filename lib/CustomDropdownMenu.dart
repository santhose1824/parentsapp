import 'package:flutter/material.dart';

class CustomDropdownMenu<T> extends StatefulWidget {
  final T initialSelection;
  final ValueChanged<T?> onSelected;
  final List<DropdownMenuItem<T>> dropdownMenuEntries;
  final double dropdownHeight;
  final double dropdownWidth;

  const CustomDropdownMenu({
    required this.initialSelection,
    required this.onSelected,
    required this.dropdownMenuEntries,
    this.dropdownHeight = 150.0,
    this.dropdownWidth = 100.0,
  });

  @override
  _CustomDropdownMenuState<T> createState() => _CustomDropdownMenuState<T>();
}

class _CustomDropdownMenuState<T> extends State<CustomDropdownMenu<T>> {
  late T selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.dropdownWidth,
      height: widget.dropdownHeight,
      child: DropdownButtonFormField<T>(
        value: selectedValue,
        items: widget.dropdownMenuEntries,
        onChanged: (T? newValue) {
          if (newValue != null) {
            setState(() {
              selectedValue = newValue;
              widget.onSelected(newValue);
            });
          }
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }
}
