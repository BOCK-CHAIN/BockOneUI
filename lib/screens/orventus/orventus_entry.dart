import 'package:flutter/widgets.dart';

import 'orventus_entry_stub.dart'
    if (dart.library.html) 'orventus_entry_web.dart' as orventus_entry_impl;

class OrventusEntry extends StatelessWidget {
  const OrventusEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return orventus_entry_impl.buildOrventusEntry();
  }
}
