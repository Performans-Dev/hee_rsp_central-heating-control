import 'package:central_heating_control/app/data/models/function.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FunctionListScreen extends StatelessWidget {
  const FunctionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(builder: (dc) {
      return AppScaffold(
        selectedIndex: 1,
        title: 'Functions'.tr,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int i = 1; i <= dc.buttonFunctionList.length; i++)
              Expanded(
                child: Center(
                  child: ListTile(
                    leading: Icon(
                      Icons.sunny,
                      color: dc.btn1 ? Colors.green : null,
                    ),
                    title: Text('F$i'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownMenu<FunctionDefinition?>(
                          enableFilter: false,
                          enableSearch: false,
                          onSelected: (value) async {
                            await dc.updateButtonFunction(i, value?.id);
                          },
                          initialSelection: dc.functionList.firstWhereOrNull(
                              (e) => e.id == (dc.functionList[i].id)),
                          dropdownMenuEntries: dc.functionList
                              .map(
                                (e) => DropdownMenuEntry<FunctionDefinition?>(
                                    value: e, label: e.name),
                              )
                              .toList(),
                        ),
                        IconButton(
                          onPressed: dc.functionList.firstWhereOrNull(
                                      (e) => e.id == (dc.functionList[i].id)) ==
                                  null
                              ? null
                              : () {
                                  dc.updateButtonFunction(i, null);
                                },
                          icon: const Icon(Icons.clear),
                        ),
                      ],
                    ),
                    subtitle: Text(dc.functionList
                            .firstWhereOrNull(
                                (e) => e.id == (dc.functionList[i].id))
                            ?.name ??
                        'N/A'),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
