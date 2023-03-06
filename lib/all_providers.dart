import 'package:custom_date_picker/provider/date_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AllProvider {
  static final dateProvider = ChangeNotifierProvider.autoDispose((_) => DateProvider());
}
