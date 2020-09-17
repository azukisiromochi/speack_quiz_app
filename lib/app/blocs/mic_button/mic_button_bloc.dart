import 'package:quiz_app/app/utils/importer.dart';

import 'mic_button_event.dart';
import 'mic_button_state.dart';

class MicButtonBloc extends Bloc<MicButtonEvent, MicButtonState> {
  MicButtonBloc() : super();

  @override
  MicButtonState get initialState => MicButtonDefault();

  @override
  Stream<MicButtonState> mapEventToState(MicButtonEvent event) async* {
    if (event is MicButtonPush) {
      yield MicButtonPushed();
    } else if (event is MicButtonRelease) {
      yield MicButtonDefault();
    }
  }
}
