import 'package:connectivity_plus/connectivity_plus.dart';

class InternetConnectivity{
   static final Connectivity _connectivity = Connectivity();

   static Future<bool> isConnected() async {
     var connectivityResult = await _connectivity.checkConnectivity();
     return connectivityResult.isNotEmpty && (connectivityResult.contains(ConnectivityResult.mobile)  ||
            connectivityResult.contains(ConnectivityResult.wifi) ||
            connectivityResult.contains(ConnectivityResult.ethernet));
   }

   static Stream<ConnectivityResult> get connectivityStream {
     return _connectivity.onConnectivityChanged.map(
         (List<ConnectivityResult> results){
           return results.isNotEmpty ? results.first : ConnectivityResult.none;
         }

     );
   }
}