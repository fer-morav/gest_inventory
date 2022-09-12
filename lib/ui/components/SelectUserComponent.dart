import 'package:flutter/material.dart';
import 'package:gest_inventory/ui/components/MessageComponent.dart';
import 'package:gest_inventory/utils/navigator_functions.dart';
import '../../data/models/User.dart';
import '../../utils/colors.dart';
import '../../utils/strings.dart';
import 'DividerComponent.dart';
import 'UserComponent.dart';

class SelectUserComponent extends StatelessWidget {
  final Stream<List<User>> listUser;
  final String indications;

  const SelectUserComponent({
    Key? key,
    required this.listUser,
    required this.indications,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: ListTile(
        title: Text(
          title_select_user,
          style: TextStyle(
            fontSize: 18,
            color: blackColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ListTileStyle.drawer,
        isThreeLine: true,
        subtitle: Text(
          indications,
          style: TextStyle(
            fontSize: 12,
            color: lightColor,
          ),
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: StreamBuilder<List<User>>(
          stream: listUser,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MessageComponent(text: text_connection_error),
                ],
              );
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MessageComponent(text: text_empty_list),
                ],
              );
            }
            if (snapshot.hasData) {
              return ListView.separated(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                separatorBuilder: (_, int index) => DividerComponent(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: UserComponent(
                      user: snapshot.data![index],
                      onTap: () => popWithResult(context, snapshot.data![index]),
                    ),
                  );
                },
              );
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
