import 'package:custom_date_picker/core/provider/date_provider.dart';
import 'package:custom_date_picker/provider/dialog_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'provider/main_provider.dart';


class AllProvider {
  static final dateProvider = ChangeNotifierProvider.autoDispose((_) => DateProvider());

  static final dialogProvider = ChangeNotifierProvider.autoDispose((_) => DialogProvider());
  static final mainProvider = ChangeNotifierProvider.autoDispose((_) => MainProvider());
}
