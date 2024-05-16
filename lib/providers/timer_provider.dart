import 'dart:async';
import 'package:eazy_sleep/providers/player_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class TimerProvider with ChangeNotifier {
  Timer? _timer;
  int _remainingTime = 0;

  int get remainingTime => _remainingTime;

  void startTimer(int minutes, context) {
    final player = Provider.of<PlayerProvider>(context, listen: false);
    _cancelTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      print(_remainingTime);
      if (_remainingTime > 0) {
        _updateRemainingTime();
      } else {
        _cancelTimer();
        player.pauseAll();
        print('Paused');
      }
    });

    _remainingTime = minutes;
    notifyListeners();
  }

  void cancelTimer() {
    _cancelTimer();
    _remainingTime = 0;
    notifyListeners();
  }

  void _updateRemainingTime() {
    _remainingTime--;
    notifyListeners();
  }

  void _cancelTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
  }
}
