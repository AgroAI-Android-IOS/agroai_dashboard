import 'package:flareline/flutter_gen/app_localizations.dart';
import 'package:flareline/pages/layout.dart';
import 'package:flareline_uikit/components/card/common_card.dart';
import 'package:flareline_uikit/components/tables/table_widget.dart';
import 'package:flareline_uikit/entity/table_data_entity.dart';
import 'package:flutter/material.dart';

class UserListPage extends LayoutWidget {
  const UserListPage({super.key});

  @override
  String breakTabTitle(BuildContext context) {
    return AppLocalizations.of(context)!.userList;
  }

  @override
  Widget contentDesktopWidget(BuildContext context) {
    return Column(
      children: [
        CommonCard(
          title: AppLocalizations.of(context)!.userList,
          child: UserTableWidget(),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/userCreate');
          },
          child: Text(AppLocalizations.of(context)!.createUser),
        ),
      ],
    );
  }
}

class UserTableWidget extends TableWidget<UserTableViewModel> {
  @override
  UserTableViewModel viewModelBuilder(BuildContext context) {
    return UserTableViewModel(context);
  }
}

class UserTableViewModel extends BaseTableProvider {
  @override
  String get TAG => 'UserTableViewModel';

  UserTableViewModel(super.context);

  @override
  loadData(BuildContext context) async {
    const headers = ["User ID", "Name", "Email", "Role", "Actions"];

    List rows = [];

    for (int i = 0; i < 50; i++) {
      List<List<Map<String, dynamic>>> list = [];

      List<Map<String, dynamic>> row = [];
      var id = i;
      var item = {
        'userId': id,
        'name': 'User $id',
        'email': 'user$id@example.com',
        'role': 'User',
      };
      row.add(getItemValue('userId', item));
      row.add(getItemValue('name', item));
      row.add(getItemValue('email', item));
      row.add(getItemValue('role', item));
      row.add(
          getItemValue('actions', item, dataType: CellDataType.ACTION.type));
      list.add(row);

      rows.addAll(list);
    }

    Map<String, dynamic> map = {'headers': headers, 'rows': rows};
    TableDataEntity data = TableDataEntity.fromJson(map);
    tableDataEntity = data;
  }
}
