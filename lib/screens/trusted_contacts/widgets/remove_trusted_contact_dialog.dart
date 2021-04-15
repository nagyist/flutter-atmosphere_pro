import 'dart:typed_data';

import 'package:at_contact/at_contact.dart';
import 'package:atsign_atmosphere_pro/utils/text_strings.dart'
    as pro_text_strings;
import 'package:atsign_atmosphere_pro/screens/common_widgets/contact_initial.dart';
import 'package:atsign_atmosphere_pro/screens/common_widgets/custom_button.dart';
import 'package:atsign_atmosphere_pro/screens/common_widgets/custom_circle_avatar.dart';
import 'package:atsign_atmosphere_pro/utils/text_styles.dart';
import 'package:atsign_atmosphere_pro/view_models/trusted_sender_view_model.dart';
import 'package:flutter/material.dart';
import 'package:atsign_atmosphere_pro/services/size_config.dart';
import 'package:provider/provider.dart';

class RemoveTrustedContact extends StatefulWidget {
  final String image;
  final String name;
  final String atSign;
  final AtContact contact;

  const RemoveTrustedContact(
      {Key key, this.image, this.name, this.atSign, this.contact})
      : super(key: key);

  @override
  _RemoveTrustedContactState createState() => _RemoveTrustedContactState();
}

class _RemoveTrustedContactState extends State<RemoveTrustedContact> {
  Uint8List image;

  @override
  void initState() {
    super.initState();
    if (widget.contact.tags != null && widget.contact.tags['image'] != null) {
      List<int> intList = widget.contact.tags['image'].cast<int>();
      image = Uint8List.fromList(intList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.toWidth),
      ),
      titlePadding: EdgeInsets.all(20.toHeight),
      title: Row(
        children: [
          Expanded(
            child: Text(
              pro_text_strings.TextStrings().removeTrustedSender,
              style: CustomTextStyles.secondaryRegular16,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      content: Container(
        height: 300.toHeight,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (image != null)
                    ? CustomCircleAvatar(
                        byteImage: image,
                        nonAsset: true,
                      )
                    : ContactInitial(
                        initials: widget.contact.tags != null &&
                                widget.contact.tags['name'] != null
                            ? widget.contact.tags['name'].substring(0, 2)
                            : widget.contact.atSign.substring(1, 3),
                      )
              ],
            ),
            SizedBox(
              height: 20.toHeight,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                      child: Text(
                    widget.contact.tags != null &&
                            widget.contact.tags['name'] != null
                        ? widget.contact.tags['name']
                        : widget.contact.atSign.substring(1),
                    style: CustomTextStyles.primaryBold16,
                  )),
                ),
              ],
            ),
            SizedBox(
              height: 5.toHeight,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      widget.contact.atSign,
                      style: CustomTextStyles.secondaryRegular14,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.toHeight,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (Provider.of<TrustedContactProvider>(context)
                            .trustedContactOperation)
                        ? CircularProgressIndicator()
                        : CustomButton(
                            isOrange: true,
                            buttonText: 'Yes',
                            width: 200.toWidth,
                            onPressed: () async {
                              await Provider.of<TrustedContactProvider>(context,
                                      listen: false)
                                  .removeTrustedContacts(widget.contact);
                              await Provider.of<TrustedContactProvider>(context,
                                      listen: false)
                                  .setTrustedContact();
                              await Navigator.pop(context);
                            },
                          ),
                  ],
                ),
                SizedBox(height: 10.toHeight),
                (Provider.of<TrustedContactProvider>(context)
                        .trustedContactOperation)
                    ? SizedBox()
                    : CustomButton(
                        buttonText: 'No',
                        isInverted: true,
                        onPressed: () {
                          Provider.of<TrustedContactProvider>(context,
                                  listen: false)
                              .trustedContactOperation = false;
                          Navigator.pop(context);
                        },
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}