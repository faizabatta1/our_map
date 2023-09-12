import 'dart:math';
import 'dart:ui';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.teal,
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.teal,
            elevation: 0,
            title: Text(
              "Help Page ",
              style: TextStyle(fontSize: 24),
            )),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              width: double.infinity,
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset("assets/images/help_banner_image.png"),
                      ),
                      SizedBox(height: 20,),
                      Text(
                        '''
Dear valued user,

We are glad to hear that you are using Flutter Google Maps in your project! We understand that sometimes you might run into issues or have questions regarding the usage of our platform. That's why we have put together this help page to assist you in resolving any issues you might encounter.

Here are some tips to help you get started with Flutter Google Maps:

Make sure you have a valid API key: To use Google Maps in your Flutter application, you will need a valid API key. If you don't already have one, you can obtain one by following the instructions on the Google Maps API website.

Familiarize yourself with the Flutter Google Maps API: Our API documentation provides a detailed overview of the available classes and methods you can use in your application. It's important to familiarize yourself with these concepts to make the most out of our platform.

Check out our sample projects: We have provided a number of sample projects on our GitHub page that demonstrate how to use Flutter Google Maps in various scenarios. You can use these as a starting point for your own application.

Debugging and troubleshooting: If you encounter any issues with your Flutter Google Maps implementation, our documentation provides detailed information on how to debug and troubleshoot common issues.

If you need further assistance, please don't hesitate to reach out to our support team. We are always here to help you with any questions or issues you might have.

Thank you for choosing Flutter Google Maps for your project.

Best regards,
The Flutter Google Maps Team
                        ''',
                        style: TextStyle(
                          fontSize: 18
                        ),
                      )
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
