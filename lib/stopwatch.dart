import 'dart:async';
import 'package:flutter/material.dart';

class StopWatchPage extends StatefulWidget {
  const StopWatchPage({Key? key}) : super(key: key);

  @override
  State<StopWatchPage> createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage> {
  int elapsedSeconds = 0, elapsedMinutes = 0, elapsedHours = 0;

  String formattedSeconds = "00", formattedMinutes = "00", formattedHours = "00";

  Timer? timer;
  bool isRunning = false;
  List<String> laps = [];

  // Stop the stopwatch
  void stopStopwatch() {
    timer!.cancel();
    setState(() {
      isRunning = false;
    });
  }

  // Reset the stopwatch
  void resetStopwatch() {
    timer!.cancel();
    setState(() {
      elapsedSeconds = 0;
      elapsedMinutes = 0;
      elapsedHours = 0;

      formattedSeconds = "00";
      formattedMinutes = "00";
      formattedHours = "00";
      isRunning = false;
    });
  }

  // Add a lap to the list
  void addLap() {
    String lapTime = "$formattedHours:$formattedMinutes:$formattedSeconds";
    setState(() {
      laps.add(lapTime);
    });
  }

  // Start or pause the stopwatch
  void startOrPauseStopwatch() {
    setState(() {
      isRunning ? stopStopwatch() : startStopwatch();
    });
  }

  // Start the stopwatch
  void startStopwatch() {
    isRunning = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int localSeconds = elapsedSeconds + 1;
      int localMinutes = elapsedMinutes;
      int localHours = elapsedHours;

      if (localSeconds > 59) {
        if (localMinutes > 59) {
          localHours++;
          localMinutes = 0;
        } else {
          localMinutes++;
          localSeconds = 0;
        }
      }

      setState(() {
        elapsedSeconds = localSeconds;
        elapsedMinutes = localMinutes;
        elapsedHours = localHours;

        // Format the time with leading zeros
        formattedSeconds = (elapsedSeconds >= 10) ? "$elapsedSeconds" : "0$elapsedSeconds";
        formattedMinutes = (elapsedMinutes >= 10) ? "$elapsedMinutes" : "0$elapsedMinutes";
        formattedHours = (elapsedHours >= 10) ? "$elapsedHours" : "0$elapsedHours";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111328),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "STOPWATCH",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "$formattedHours:$formattedMinutes:$formattedSeconds",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 80.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                height: 300.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFF1D1E33),
                ),
                child: ListView.builder(
                  itemCount: laps.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Lap ${index + 1}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "${laps[index]}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        startOrPauseStopwatch();
                      },
                      child: Text((isRunning) ? "Pause" : "Start"),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFFEA1E63),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0,),
                  IconButton(
                    onPressed: () {
                      addLap();
                    },
                    color: Colors.white,
                    icon: Icon(Icons.flag_circle),
                  ),
                  SizedBox(width: 8.0,),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        resetStopwatch();
                      },
                      style: OutlinedButton.styleFrom(
                        primary: Colors.white,
                        side: BorderSide(color: const Color(0xFFEA1E63)), // Set border color
                      ),
                      child: Text("Reset"),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
