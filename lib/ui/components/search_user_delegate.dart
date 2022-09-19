import 'package:flutter/material.dart';
import '../../data/models/User.dart';
import '../../utils/actions_enum.dart';
import '../../utils/colors.dart';
import '../../utils/icons.dart';
import '../../utils/strings.dart';
import 'DividerComponent.dart';
import 'UserComponent.dart';

class SearchUserDelegate extends SearchDelegate<User?> {
  final List<User> users;
  final ActionType actionType;

  List<User> _listQuery = [];

  SearchUserDelegate({required this.users, required this.actionType});

  @override
  String? get searchFieldLabel => textfield_label_name;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: getIcon(AppIcons.error, size: 30, color: errorColor),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: getIcon(AppIcons.arrow_back, color: primaryColor, size: 30),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _listQuery = _getQuery();

    return ListView.separated(
      itemCount: _listQuery.length,
      separatorBuilder: (_, int index) => DividerComponent(),
      itemBuilder: (context, index) {
        return UserComponent(
          user: _listQuery[index],
          actionType: actionType,
          onTap: () => close(context, _listQuery[index]),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _listQuery = _getQuery();

    return ListView.separated(
      itemCount: _listQuery.length,
      separatorBuilder: (_, int index) => DividerComponent(),
      itemBuilder: (context, index) {
        return UserComponent(
          user: _listQuery[index],
          actionType: actionType,
          onTap: () => close(context, _listQuery[index]),
        );
      },
    );
  }

  List<User> _getQuery() {
    return users.where(
      (User) => User.name.toLowerCase().contains(query.toLowerCase().trim()),
    ).toList();
  }
}