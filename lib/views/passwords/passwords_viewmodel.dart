import 'package:components/password_entry_box/password_entry_box.dart';
import 'package:domain/models/stored_secret.dart';
import 'package:infrastructure/interfaces/isecret_manager.dart';
import 'package:shared/page_view_model.dart';

class PasswordsViewModel extends PageViewModel {
  late ISecretManager _secretManger;

  List<StoredSecret> _secrets = [];
  List<StoredSecret> get secrets => _secrets;

  PasswordsViewModel(super.context) {
    _secretManger = getIt.get<ISecretManager>();
  }
  ready() async {
    _secrets = await _secretManger.getSecrets();

    notifyListeners();
  }

  onGeneratePassword() {
    var password = _secretManger.generateSecret();
    print(password);
    router.openDialog(
      PasswordEntryBox(
        password: password,
        onSave: onSave,
      ),
      pageContext,
    );
  }

  onSave() async {
    router.dismissBar(pageContext);
    await ready();
  }
}
