import 'package:flutter/material.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:trial/widgets/automotive_grid_item.dart';

import 'Eira/eira_main.dart';

class BockHealthScreen extends StatelessWidget {
  const BockHealthScreen({super.key});

  void launchExternalApp() async {
    try {
      await LaunchApp.openApp(
        androidPackageName: 'com.example.flutter_application_1',
        //iosUrlScheme: 'example app://',
        openStore: true, // Redirect to the store if the app is not installed
      );
    } catch (e) {
      //print('Failed to launch app: $e');
    }
  }

  /*void launchAnotherApp() {
    const intent = AndroidIntent(
      action: 'android.intent.action.MAIN',
      package: 'com.example.flutter_application_1',
      category: 'android.intent.category.LAUNCHER',
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    intent.launch();
  }*/

  /*Future<void> openOrInstallApp({
    required String packageName,
    required String playStoreUrl,
  }) async {
    try {
      bool isInstalled = await DeviceApps.isAppInstalled(packageName);

      if (isInstalled) {
        final bool launched = await DeviceApps.openApp(packageName);
        if (launched != false) {
          AndroidIntent intent = const AndroidIntent(
              action: 'action_view',
              package: 'com.example.flutter_application_1',
          );
          await intent.launch();
        }
      } else {
        final Uri url = Uri.parse(playStoreUrl);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          throw 'Could not launch $playStoreUrl';
        }
      }
    } catch (e) {
      debugPrint('Error launching or installing app: $e');
    }
  }*/



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    Widget content=SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AutomotiveGridItem(
                  title: 'Eira',
                  height: 200,
                  //onTap: launchExternalApp,
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const EiraApp()));
                  },
                ),
              ),
              const SizedBox(width: 10,),
              Expanded(child: AutomotiveGridItem(title: 'Autonomous Hospital',height: 200,onTap: (){},)),
            ],
          ),
          const SizedBox(height: 10,),
          AutomotiveGridItem(title: 'Typhronex',height: 200,onTap: (){},),
          const SizedBox(height: 10,),
          AutomotiveGridItem(title: 'Pharmaceutical',height: 200,onTap: (){},),
        ],
      ),
    );

    if (screenWidth > 1200) {
      content=Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: AutomotiveGridItem(
                      title: 'Eira',
                      height: 300,
                      //onTap: launchExternalApp,
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const EiraApp()));
                      },
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(child: AutomotiveGridItem(title: 'Autonomous Hospital',height: 300,onTap: (){},)),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(child: AutomotiveGridItem(title: 'Typhronex',height: 300,onTap: (){},)),
                  const SizedBox(width: 20,),
                  Expanded(child: AutomotiveGridItem(title: 'Pharmaceutical',height: 300,onTap: (){},)),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEBDFF4), // Your background
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0), // Purple variant
        title: const Text("Bock Health", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: content
    );
  }
}
