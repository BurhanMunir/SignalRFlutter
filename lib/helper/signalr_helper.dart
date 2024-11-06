import 'package:logging/logging.dart';
import 'package:signalr_netcore/signalr_client.dart';

class SignalRHelper {
  final String serverUrl;
  late HubConnection hubConnection;

  SignalRHelper(this.serverUrl) {
    // Configure logging
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
    });
    final httpConnectionOptions = HttpConnectionOptions(
        accessTokenFactory: () => getAccessToken());

    // Setup connection
//     hubConnection = HubConnectionBuilder()
//         .withUrl(serverUrl,
//     options: HttpConnectionOptions(
//       accessTokenFactory:() async => await getAccessToken())).build();
// print(hubConnection.baseUrl);

    hubConnection = HubConnectionBuilder()
        .withUrl(serverUrl,
        options:httpConnectionOptions).build();
    print(hubConnection.baseUrl);
    // hubConnection.onclose((dynamic error) {
    //   print("Connection Closed: ${error?.toString()}");
    // } as ClosedCallback);


  }
  Future<String> getAccessToken() async{
    await Future.delayed(Duration(seconds: 1));
    return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjI0MzY0MTQ1NTIiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiUm9iZXJ0TiIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL2VtYWlsYWRkcmVzcyI6InJvYmVydG5peWl0YW5nYTNAZ21haWwuY29tIiwiQXNwTmV0LklkZW50aXR5LlNlY3VyaXR5U3RhbXAiOiJVNTM1QURFQzJXQlczVlRFV0YzRU1aRkVKVlZYM09MSiIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6IkN1c3RvbWVyIiwiaHR0cDovL3d3dy5hc3BuZXRib2lsZXJwbGF0ZS5jb20vaWRlbnRpdHkvY2xhaW1zL3RlbmFudElkIjoiMSIsInN1YiI6IjI0MzY0MTQ1NTIiLCJqdGkiOiI1NDk2ODE0Mi1jNTc2LTQwOWMtYjkwMi05NjQyNWE3MjIwM2QiLCJpYXQiOjE3MzA4MzI5MDgsIm5iZiI6MTczMDgzMjkwOCwiZXhwIjoxNzMwOTE5MzA4LCJpc3MiOiJMb2dpY1RlY2hzb2wiLCJhdWQiOiJMb2dpY1RlY2hzb2wifQ.H0bzp4rxEsJW0JI890hh032Q4wSjx0qU848G6dz9i6U"; // Replace with your hardcoded token
  }
  // Connect to the server
  Future<void> connect() async {
    if (hubConnection.state == HubConnectionState.Disconnected) {
      try {
        await hubConnection.start();
        print("Connected to SignalR Server at $serverUrl");
      } catch (e) {
        print("Server URL is: $serverUrl");
        print("Connection failed exception: $e");
      }
    } else {
      print("Already connected or connecting. Current state: ${hubConnection.state}");
    }
  }


  // Invoke a server method
  Future<void> invokeMethod(String methodName, List<SignalRNotificationDto>? args) async {
    try {
      // Convert SignalRNotificationDto objects to JSON maps
      List<Map<String, dynamic>> jsonArgs = args?.map((arg) => arg.toJson()).toList() ?? [];
       // print("Json Data : $jsonArgs");
       // print(await hubConnection.connectionId);
      // Call the server method with the serialized arguments
      final result = await hubConnection.invoke(methodName, args: ["admin","Test Notification"]);
      //final reslt1 = await hubConnection.send(methodName,args: ["Test Notifacation"]);
      print("Server response: $result");
      //print("Server response: ");
    } catch (e) {
      print("Method invocation failed: $e");
    }
  }

  // Register client method
  void on(String methodName, MethodInvocationFunc callback) {
    try{
      hubConnection.on(methodName, callback);
    }catch(ex){
      print("ON Method : $ex");
    }
  }

  // Disconnect from the server
  Future<void> disconnect() async {
    await hubConnection.stop();
    print("Disconnected from SignalR Server");
  }
}

Future<String> getAccessToken () async{
  await Future.delayed(Duration(seconds: 1));
  return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjI0MzY0MTQ1NTIiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiUm9iZXJ0TiIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL2VtYWlsYWRkcmVzcyI6InJvYmVydG5peWl0YW5nYTNAZ21haWwuY29tIiwiQXNwTmV0LklkZW50aXR5LlNlY3VyaXR5U3RhbXAiOiJVNTM1QURFQzJXQlczVlRFV0YzRU1aRkVKVlZYM09MSiIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6IkN1c3RvbWVyIiwiaHR0cDovL3d3dy5hc3BuZXRib2lsZXJwbGF0ZS5jb20vaWRlbnRpdHkvY2xhaW1zL3RlbmFudElkIjoiMSIsInN1YiI6IjI0MzY0MTQ1NTIiLCJqdGkiOiIzNDhkYTA1Yi0yYzEzLTRmYzAtODY0NS1mZmZlNjcwNjgxMjciLCJpYXQiOjE3MzA2NDcxMzYsIm5iZiI6MTczMDY0NzEzNiwiZXhwIjoxNzMwNzMzNTM2LCJpc3MiOiJMb2dpY1RlY2hzb2wiLCJhdWQiOiJMb2dpY1RlY2hzb2wifQ.Np1-hu7lv035hsRSKJd-Y9xKZ8HhKoV8bQ90h_B90ow";
}

class SignalRNotificationDto {
  String message;

  // Constructor
  SignalRNotificationDto(this.message);

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
