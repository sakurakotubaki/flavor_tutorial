
import 'package:flavor_tutorial/firebase_options_staging.dart';
import 'package:flavor_tutorial/main.dart';
import 'package:flutter/material.dart';

void main() async {
  // Print the current flavor for debugging
  debugPrint('Running with flavor: STAGING');
  
  // Call the common main function with staging options
  await mainCommon(DefaultFirebaseOptions.currentPlatform, flavor: 'staging');
}