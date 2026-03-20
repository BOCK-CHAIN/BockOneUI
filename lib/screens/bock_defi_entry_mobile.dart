import 'package:flutter/material.dart';

import 'package:bockchain/mobile/mobile_app.dart' as bock_defi;
import 'package:bockchain/mobile/screens/datbase_service.dart' as bock_defi_db;

Future<void> defiInitializeTables() {
  return bock_defi_db.DatabaseService.initializeTables();
}

Widget defiApp() {
  return const bock_defi.MobileApp();
}
