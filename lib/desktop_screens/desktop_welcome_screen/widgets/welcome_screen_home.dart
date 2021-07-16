import 'package:at_contacts_group_flutter/screens/group_contact_view/group_contact_view.dart';
import 'package:atsign_atmosphere_pro/dekstop_services/desktop_image_picker.dart';
import 'package:atsign_atmosphere_pro/desktop_screens/desktop_contacts_screen/desktop_select_contacts_screen/desktop_select_contacts_screen.dart';
import 'package:atsign_atmosphere_pro/services/navigation_service.dart';
import 'package:atsign_atmosphere_pro/view_models/file_transfer_provider.dart';
import 'package:atsign_atmosphere_pro/view_models/welcome_screen_view_model.dart';
import 'package:atsign_atmosphere_pro/services/backend_service.dart';
import 'package:flutter/material.dart';
import 'package:atsign_atmosphere_pro/services/size_config.dart';
import 'package:atsign_atmosphere_pro/desktop_screens/desktop_common_widgets/desktop_selected_contacts.dart';
import 'package:atsign_atmosphere_pro/desktop_screens/desktop_common_widgets/desktop_selected_files.dart';
import 'package:atsign_atmosphere_pro/utils/colors.dart';
import 'package:atsign_atmosphere_pro/utils/images.dart';
import 'package:atsign_atmosphere_pro/utils/text_strings.dart';
import 'package:atsign_atmosphere_pro/utils/text_styles.dart';
import 'package:atsign_atmosphere_pro/screens/common_widgets/common_button.dart';
import 'package:atsign_atmosphere_pro/utils/constants.dart';
import 'package:provider/provider.dart';

enum CurrentScreen { PlaceolderImage, ContactsScreen, SelectedItems }

class WelcomeScreenHome extends StatefulWidget {
  @override
  _WelcomeScreenHomeState createState() => _WelcomeScreenHomeState();
}

class _WelcomeScreenHomeState extends State<WelcomeScreenHome> {
  // bool showContent = false, showSelectedItems = false;
  CurrentScreen _currentScreen = CurrentScreen.PlaceolderImage;
  FileTransferProvider _filePickerProvider;
  WelcomeScreenProvider _welcomeScreenProvider;
  List _selectedList = [];

  @override
  void initState() {
    _filePickerProvider =
        Provider.of<FileTransferProvider>(context, listen: false);
    _welcomeScreenProvider = Provider.of<WelcomeScreenProvider>(
        NavService.navKey.currentContext,
        listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedList.isNotEmpty) {
      _currentScreen = CurrentScreen.SelectedItems;
    }
    return Scaffold(
        body: Row(
      children: [
        Container(
          width: (SizeConfig().screenWidth - MixedConstants.SIDEBAR_WIDTH) / 2,
          height: SizeConfig().screenHeight - 80,
          padding: EdgeInsets.symmetric(horizontal: 50),
          color: ColorConstants.LIGHT_BLUE_BG,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome !' +
                    (BackendService.getInstance().atClientInstance != null
                        ? '${BackendService.getInstance().atClientInstance.currentAtSign}'
                        : ''),
                style: CustomTextStyles.desktopBlackPlayfairDisplay26,
              ),
              SizedBox(
                height: 20.toHeight,
              ),
              Text(
                'Type a receipient and start sending them files.',
                style: CustomTextStyles.desktopSecondaryRegular18,
              ),
              SizedBox(
                height: 50.toHeight,
              ),
              Text(
                TextStrings().welcomeSendFilesTo,
                style: CustomTextStyles.desktopSecondaryRegular18,
              ),
              SizedBox(
                height: 20.toHeight,
              ),
              sendFileTo(isSelectContacts: true),
              SizedBox(
                height: 30,
              ),
              Text(TextStrings().welcomeFilePlaceholder,
                  style: CustomTextStyles.desktopSecondaryRegular18),
              SizedBox(
                height: 20.toHeight,
              ),
              sendFileTo(),
              SizedBox(
                height: 20.toHeight,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: CommonButton(
                  'Send',
                  () async {
                    await _filePickerProvider.sendFileWithFileBin(
                        _filePickerProvider.selectedFiles,
                        _welcomeScreenProvider.selectedContacts);
                  },
                  color: ColorConstants.orangeColor,
                  border: 3,
                  height: 45,
                  width: 110,
                  fontSize: 20,
                  removePadding: true,
                ),
              )
            ],
          ),
        ),
        Expanded(child: currentScreen()),
      ],
    ));
  }

  // ignore: missing_return
  Widget currentScreen() {
    switch (_currentScreen) {
      case CurrentScreen.PlaceolderImage:
        return _selectedList.isNotEmpty
            ? _selectedItems()
            : _placeholderImage();
      case CurrentScreen.ContactsScreen:
        return GroupContactView(
            asSelectionScreen: true,
            singleSelection: false,
            showGroups: false,
            showContacts: true,
            isDesktop: true,
            selectedList: (_list) {
              Provider.of<WelcomeScreenProvider>(
                      NavService.navKey.currentContext,
                      listen: false)
                  .updateSelectedContacts(_list);
            },
            onBackArrowTap: () {
              setState(() {
                _currentScreen = CurrentScreen.PlaceolderImage;
              });
            },
            onDoneTap: () {
              setState(() {
                _currentScreen = CurrentScreen.SelectedItems;
              });
            });
      // return _contactsScreen();
      case CurrentScreen.SelectedItems:
        return _selectedItems();
    }
  }

  Widget _selectedItems() {
    return Container(
      width: (SizeConfig().screenWidth - MixedConstants.SIDEBAR_WIDTH) / 2,
      height: SizeConfig().screenHeight - 80,
      color: ColorConstants.LIGHT_BLUE_BG,
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: SingleChildScrollView(
        child: Column(
          children: [
            DesktopSelectedContacts((val) {
              if (_welcomeScreenProvider.selectedContacts.isEmpty &&
                  _filePickerProvider.selectedFiles.isEmpty) {
                _currentScreen = CurrentScreen.PlaceolderImage;
              }
              setState(() {});
            }),
            Divider(
              height: 20,
              thickness: 5,
            ),
            DesktopSelectedFiles((val) {
              if (_welcomeScreenProvider.selectedContacts.isEmpty &&
                  _filePickerProvider.selectedFiles.isEmpty) {
                _currentScreen = CurrentScreen.PlaceolderImage;
              }
              setState(() {});
            }),
          ],
        ),
      ),
    );
  }

  Widget _contactsScreen() {
    return SizedBox(
      width: (SizeConfig().screenWidth - MixedConstants.SIDEBAR_WIDTH) / 2,
      height: SizeConfig().screenHeight - 80,
      child: DesktopSelectContactsScreen(
        onArrowBackTap: () {
          setState(() {
            _currentScreen = CurrentScreen.PlaceolderImage;
          });
        },
        onDoneTap: () {
          setState(() {
            _currentScreen = CurrentScreen.SelectedItems;
          });
        },
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: (SizeConfig().screenWidth - MixedConstants.SIDEBAR_WIDTH) / 2,
      height: SizeConfig().screenHeight - 80,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            ImageConstants.welcomeDesktop,
          ),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget sendFileTo({bool isSelectContacts = false}) {
    return InkWell(
        onTap: () async {
          if (isSelectContacts) {
            _currentScreen = CurrentScreen.ContactsScreen;
          } else {
            var file = await desktopImagePicker();
            if (file != null) {
              _filePickerProvider.selectedFiles = file;
              _currentScreen = CurrentScreen.SelectedItems;
            }
          }
          setState(() {});
        },
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: ListTile(
              title: _currentScreen != CurrentScreen.PlaceolderImage
                  ? Text(
                      (isSelectContacts
                          ? '${_welcomeScreenProvider.selectedContacts.length} contacts added'
                          : '${_filePickerProvider.selectedFiles.length} files selected'),
                      style: CustomTextStyles.desktopSecondaryRegular18)
                  : SizedBox(),
              trailing: isSelectContacts
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Image.asset(
                        ImageConstants.contactsIcon,
                        color: Colors.black,
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.symmetric(vertical: 15.toHeight),
                      child: Icon(
                        Icons.add_circle,
                        color: Colors.black,
                      ),
                    ),
            )));
  }
}