import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/data/models/app_user.dart';
import 'package:flutter/material.dart';

class MultiSelectUserWidget extends StatefulWidget {
  final List<AppUser> users;
  final List<AppUser> selectedUsers;
  final Function(List<AppUser>) onSelected;
  const MultiSelectUserWidget({
    super.key,
    required this.users,
    required this.selectedUsers,
    required this.onSelected,
  });

  @override
  State<MultiSelectUserWidget> createState() => _MultiSelectUserWidgetState();
}

class _MultiSelectUserWidgetState extends State<MultiSelectUserWidget> {
  late List<AppUser> selectedUsers;
  @override
  void initState() {
    super.initState();
    selectedUsers = widget.selectedUsers;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widget.users.map((e) {
        return CheckboxListTile(
          secondary: CircleAvatar(
            child: Text(e.username.getInitials()),
          ),
          value: widget.selectedUsers.map((m) => m.id).toList().contains(e.id),
          selected:
              widget.selectedUsers.map((m) => m.id).toList().contains(e.id),
          title: Text(e.username),
          selectedTileColor: Theme.of(context).primaryColor,
          onChanged: (v) {
            if (widget.selectedUsers.map((m) => m.id).toList().contains(e.id)) {
              widget.selectedUsers.removeWhere((x) => x.id == e.id);
            } else {
              widget.selectedUsers.add(e);
            }
            widget.onSelected.call(widget.selectedUsers);
          },
        );
      }).toList(),
    );
  }
}
