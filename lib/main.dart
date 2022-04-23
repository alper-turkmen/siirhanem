import 'package:camera/camera.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login.dart';
List<CameraDescription> cameras = [];

Future<void>  main()async {
  WidgetsFlutterBinding.ensureInitialized();


availableCameras().then((value) {
  for(int i = 0; i< value.length; i++){

    cameras.add(value[i]);
  }
});
  await Firebase.initializeApp();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.gentiumBookBasicTextTheme(),
        primarySwatch: Colors.deepOrange,
      ),
      home:Login(),
    );
  }
}

