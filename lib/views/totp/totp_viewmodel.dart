import 'dart:async';

import 'package:domain/models/otp_code.dart';
import 'package:infrastructure/interfaces/iotp_service.dart';
import 'package:shared/page_view_model.dart';
import 'package:components/topt_entry_box/totp_entry_box.dart';

class TotpViewModel extends PageViewModel {
  late IOtpService _otpService;
  List<OtpCode> _secrets = [];
  List<OtpCode> get secrets => _secrets;
  int _seconds = 60;
  int get seconds => _seconds;
  TotpViewModel(super.context) {
    _otpService = getIt.get<IOtpService>();
  }

  ready() async {
    _secrets = await _otpService.get();

    _seconds = DateTime.now().second;
    Timer.periodic(Duration(seconds: 1), (timer) async {
      _seconds = 60 - DateTime.now().second;
      if (_seconds == 60) {
        _secrets = await _otpService.get();
        notifyListeners();
      }
    });

    notifyListeners();
  }

  String getCode(OtpCode elementAt) {
    return _otpService.getCode(elementAt.secret);
  }

  onDeletePressed(OtpCode elementAt) async {
    await _otpService.remove(elementAt.secret);
    _secrets = await _otpService.get();
    notifyListeners();
  }

  addTotpCode() {
    router.openDialog(
      TotpEntryBox(
        onSave: onSave,
      ),
      pageContext,
    );
  }

  onSave() async {
    router.dismissBar();
    await ready();
  }
}
