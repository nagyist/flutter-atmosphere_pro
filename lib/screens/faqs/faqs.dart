import 'package:atsign_atmosphere_pro/screens/common_widgets/app_bar.dart';
import 'package:atsign_atmosphere_pro/utils/colors.dart';
import 'package:atsign_atmosphere_pro/services/size_config.dart';
import 'package:atsign_atmosphere_pro/utils/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:atsign_atmosphere_pro/utils/faq_data.dart';

class FaqsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackButton: true,
        showTitle: true,
        title: TextStrings().faqs,
      ),
      body: Container(
        margin:
            EdgeInsets.symmetric(horizontal: 16.toWidth, vertical: 16.toHeight),
        child: ListView.separated(
          itemCount: FAQData.data.length,
          separatorBuilder: (context, index) => SizedBox(
            height: 10.toHeight,
          ),
          itemBuilder: (context, index) => ClipRRect(
            borderRadius: BorderRadius.circular(10.toFont),
            child: Container(
              color: ColorConstants.inputFieldColor,
              child: Theme(
                data: ThemeData(
                  dividerColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  title: Text(
                    FAQData.data[index]["question"],
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.toFont,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_down),
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        16.toWidth,
                        0,
                        16.toWidth,
                        14.toHeight,
                      ),
                      child: Text(
                        FAQData.data[index]["answer"],
                        style: TextStyle(
                            color: ColorConstants.fadedText,
                            fontSize: 12.toFont,
                            height: 1.7,
                            letterSpacing: 0.1),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
