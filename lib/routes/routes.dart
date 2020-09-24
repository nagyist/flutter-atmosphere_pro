import 'package:atsign_atmosphere_app/routes/route_names.dart';
import 'package:atsign_atmosphere_app/screens/contact/add_contact.dart';
import 'package:atsign_atmosphere_app/screens/contact/contact.dart';
import 'package:atsign_atmosphere_app/screens/faqs/faqs.dart';
import 'package:atsign_atmosphere_app/screens/home/home.dart';
import 'package:atsign_atmosphere_app/screens/welcome_screen/welcome_screen.dart';
import 'package:flutter/material.dart';

class SetupRoutes {
  static String initialRoute = Routes.HOME;

  static Map<String, WidgetBuilder> get routes {
    return {
      Routes.HOME: (context) => Home(),
      Routes.WELCOME_SCREEN: (context) => WelcomeScreen(),
      Routes.FAQ_SCREEN: (context) => FaqsScreen(),
      Routes.CONTACT_SCREEN: (context) => ContactScreen(),
      Routes.ADD_CONTACT_SCREEN: (context) => AddContactScreen(),
    };
  }
}
