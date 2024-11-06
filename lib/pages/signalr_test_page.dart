import 'package:flutter/material.dart';
import '../helper/signalr_helper.dart';


class SignalRTestPage extends StatefulWidget {
  @override
  _SignalRTestPageState createState() => _SignalRTestPageState();
}

class _SignalRTestPageState extends State<SignalRTestPage> {
  // final String serverUrl = "https://pos-api.diner-tab.com/signalr/mart-task-hub"; // Replace with your server URL
  final String serverUrl = "https://pos-api.diner-tab.com/signalr/mart-task-hub"; // Replace with your server URL
  late SignalRHelper signalRHelper;
  String serverResponse = "";

  @override
  void initState() {
    super.initState();
    signalRHelper = SignalRHelper(serverUrl);
   // Register a method to handle responses from the server
    signalRHelper.on("OrderStatusChangeForMobile", (parameters) {
      setState(() {
        print("On State On Trigerred");
        print(parameters);
        serverResponse = "Server invoked aClientProvidedFunction!";
      });
    });
  }

  void connectToServer() async {
    await signalRHelper.connect();
  }

  void invokeServerMethod() async {
    // Create an instance of SignalRNotificationDto
    SignalRNotificationDto notification = SignalRNotificationDto("Testing Notifications");

    // Add it to a list
    List<SignalRNotificationDto> notifications = [notification];

    // Invoke the method with the list of SignalRNotificationDto
    await signalRHelper.invokeMethod("SendMessage", notifications);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SignalR Test"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: connectToServer,
              child: Text("Connect to SignalR Server"),
            ),
            ElevatedButton(
              onPressed: invokeServerMethod,
              child: Text("Invoke Server Method"),
            ),
            SizedBox(height: 20),
            Text("Server Response:"),
            Text(serverResponse),
          ],
        ),
      ),
    );
  }
}
