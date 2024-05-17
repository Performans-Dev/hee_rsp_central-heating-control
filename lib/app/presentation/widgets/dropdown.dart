import 'package:central_heating_control/app/data/models/dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DropdownWidget<DropdownModel> extends StatelessWidget {
  final List<DropdownModel> data;
  final dynamic selectedValue;
  final Function(dynamic) onSelected;
  final String labelText;
  final String hintText;
  DropdownWidget({
    super.key,
    required this.data,
    required this.labelText,
    required this.onSelected,
    required this.hintText,
    this.selectedValue,
  });
  final GlobalKey _popupKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          textAlign: TextAlign.start,
        ),
        const SizedBox(
          height: 2,
        ),
        GestureDetector(
          onTap: () {
            dynamic popupMenuState = _popupKey.currentState;
            popupMenuState.showButtonMenu();
          },
          child: Container(
            height: 55,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(selectedValue != null 
                      ? selectedValue.toString()
                      : hintText),
                  Row(
                    children: [
                      selectedValue == null
                          ? Container()
                          : IconButton(
                              onPressed: () {
                                onSelected(null);
                              },
                              icon: const Icon(Icons.close)),
                      PopupMenuButton<DropdownModel>(
                        key: _popupKey,
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 1,
                        initialValue: selectedValue,
                        onSelected: onSelected,
                        itemBuilder: (BuildContext context) {
                          return data.isEmpty
                              ? []
                              : data.map((DropdownModel item) {
                                  return PopupMenuItem<DropdownModel>(
                                    padding: const EdgeInsets.all(16),
                                    value: item,
                                    child: Text(item.toString()),
                                  );
                                }).toList();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
