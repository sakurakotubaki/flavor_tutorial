
import 'package:flavor_tutorial/firebase_options_dev.dart';
import 'package:flavor_tutorial/main.dart';
import 'package:flutter/material.dart';

void main() async {
  // Print the current flavor for debugging
  debugPrint('Running with flavor: DEV');
  
  // Call the common main function with dev options
  await mainCommon(DefaultFirebaseOptions.currentPlatform, flavor: 'dev');
}