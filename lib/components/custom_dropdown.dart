import 'package:flutter/material.dart';
import 'package:sequitur_movil/resources/app_colors.dart';

class CustomDropdownWidget<T> extends StatefulWidget {
  final List<T> items;
  final String hintText;
  final Function(T?) onChanged;
  final String Function(T) displayTextBuilder;

  CustomDropdownWidget({
    required this.items,
    required this.hintText,
    required this.onChanged,
    required this.displayTextBuilder,
  });

  @override
  _CustomDropdownWidgetState<T> createState() => _CustomDropdownWidgetState<T>();
}

class _CustomDropdownWidgetState<T> extends State<CustomDropdownWidget<T>> {
  T? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: DropdownButton<T>(
        value: _selectedItem,
        hint: Text(widget.hintText),
        onChanged: (value) {
          setState(() {
            _selectedItem = value;
          });
          widget.onChanged(value);
        },
        isExpanded: true,
        items: widget.items.map<DropdownMenuItem<T>>((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(widget.displayTextBuilder(item)),
          );
        }).toList(),
      ),
    );
  }
}