import 'package:custom_date_picker/provider/date_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'provider/main_provider.dart';


class AllProvider {
  static final dateProvider = ChangeNotifierProvider.autoDispose((_) => DateProvider());
  static final mainProvider = ChangeNotifierProvider.autoDispose((_) => MainProvider());
}
