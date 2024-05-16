import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eazy_sleep/providers/player_provider.dart';
import 'package:eazy_sleep/providers/timer_provider.dart';

class TimerSelectionPopup extends StatefulWidget {
  const TimerSelectionPopup({Key? key}) : super(key: key);

  @override
  State<TimerSelectionPopup> createState() => _TimerSelectionPopupState();
}

class _TimerSelectionPopupState extends State<TimerSelectionPopup> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    final playerProvider = Provider.of<PlayerProvider>(context);

    return IconButton(
      icon: const Icon(
        Icons.timer_outlined,
        color: Colors.white,
      ),
      onPressed: () async {
        await showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return _buildBottomSheetContent(
                context, timerProvider, playerProvider);
          },
        );
      },
    );
  }

  Widget _buildBottomSheetContent(BuildContext context,
      TimerProvider timerProvider, PlayerProvider playerProvider) {
    return _RemainingTimeListener(
      timerProvider: timerProvider,
      child: timerProvider.remainingTime != 0
          ? TimerBottomSheetContent(
              remainingTime: timerProvider.remainingTime,
              onCancel: () {
                timerProvider.cancelTimer();
                Navigator.pop(context);
              },
            )
          : Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[900], // Dark background color
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTimerOption(context, 5),
                  _buildTimerOption(context, 10),
                  _buildTimerOption(context, 15),
                  _buildTimerOption(context, 20),
                  _buildTimerOption(context, 30),
                  _buildTimerOption(context, 60),
                  ListTile(
                    title: const Text(
                      'Custom min',
                      style: TextStyle(
                        color: Colors.white, // Text color in dark mode
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Enter minute'),
                            content: TextField(
                              keyboardType: TextInputType.number,
                              controller: _textEditingController,
                              decoration: const InputDecoration(
                                  hintText: 'Max: 999 Min'),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (_textEditingController.text.isNotEmpty &&
                                      _textEditingController.text.length < 4) {
                                    _startTimer(int.tryParse(
                                        _textEditingController.text)!);
                                    Navigator.of(context).pop();
                                  }
                                  print(
                                      'Entered text: ${_textEditingController.text}');
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  void _startTimer(int minutes) {
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
    timerProvider.startTimer(minutes, context);
  }
}

class _RemainingTimeListener extends StatefulWidget {
  final Widget child;
  final TimerProvider timerProvider;

  const _RemainingTimeListener({
    Key? key,
    required this.child,
    required this.timerProvider,
  }) : super(key: key);

  @override
  __RemainingTimeListenerState createState() => __RemainingTimeListenerState();
}

class __RemainingTimeListenerState extends State<_RemainingTimeListener> {
  @override
  void initState() {
    super.initState();
    widget.timerProvider.addListener(_onRemainingTimeChanged);
  }

  @override
  void dispose() {
    widget.timerProvider.removeListener(_onRemainingTimeChanged);
    super.dispose();
  }

  void _onRemainingTimeChanged() {
    if (mounted) {
      setState(() {}); // Rebuild the widget when remaining time changes
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class TimerBottomSheetContent extends StatefulWidget {
  final int remainingTime;
  final VoidCallback onCancel;

  const TimerBottomSheetContent({
    Key? key,
    required this.remainingTime,
    required this.onCancel,
  }) : super(key: key);

  @override
  _TimerBottomSheetContentState createState() =>
      _TimerBottomSheetContentState();
}

class _TimerBottomSheetContentState extends State<TimerBottomSheetContent> {
  late int _remainingTime;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.remainingTime;
    _startUpdatingRemainingTime();
  }

  void _startUpdatingRemainingTime() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey[900], // Dark background color
      child: Column(
        children: [
          const Text(
            'Remaining Time:',
            style: TextStyle(
              color: Colors.white, // Text color in dark mode
              fontSize: 16,
            ),
          ),
          Text(
            '${(_remainingTime ~/ 60).toString().padLeft(2, '0')}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
            style: const TextStyle(
              color: Colors.white, // Text color in dark mode
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: widget.onCancel,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent, // Button color in dark mode
            ),
            child: const Text(
              'Cancel Timer',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildTimerOption(BuildContext context, int minutes) {
  return ListTile(
    title: Text(
      '$minutes min',
      style: const TextStyle(
        color: Colors.white, // Text color in dark mode
        fontSize: 16,
      ),
    ),
    onTap: () {
      // Start timer
      final timerProvider = Provider.of<TimerProvider>(context, listen: false);
      timerProvider.startTimer(minutes, context);
      Navigator.pop(context);
    },
  );
}
