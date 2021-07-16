import 'dart:io';

import 'package:atsign_atmosphere_pro/desktop_screens/desktop_my_files/widgets/desktop_file_card.dart';
import 'package:atsign_atmosphere_pro/screens/common_widgets/provider_handler.dart';
import 'package:atsign_atmosphere_pro/view_models/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:atsign_atmosphere_pro/services/size_config.dart';

class DesktopAPK extends StatefulWidget {
  @override
  _DesktopAPKState createState() => _DesktopAPKState();
}

class _DesktopAPKState extends State<DesktopAPK> {
  @override
  Widget build(BuildContext context) {
    return ProviderHandler<HistoryProvider>(
      functionName: 'sort_files',
      load: (provider) {
        // provider.getReceivedHistory();
      },
      successBuilder: (provider) {
        return provider.receivedApk.isEmpty
            ? Center(
                child: Text('No file found'),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                margin: EdgeInsets.symmetric(
                    vertical: 10.toHeight, horizontal: 10.toWidth),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    runSpacing: 10.0,
                    spacing: 30.0,
                    children: List.generate(
                      provider.receivedApk.length,
                      (index) => InkWell(
                        onTap: () async {
                          File test =
                              File(provider.receivedApk[index].filePath);
                          bool fileExists = await test.exists();
                          if (fileExists) {
                            await OpenFile.open(
                                provider.receivedApk[index].filePath);
                          }
                        },
                        child: DesktopFileCard(
                          title: provider.receivedApk[index].filePath
                              .split('/')
                              .last,
                          filePath: provider.receivedApk[index].filePath,
                        ),
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}