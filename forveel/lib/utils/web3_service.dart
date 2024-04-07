import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'constants.dart'; // Ensure this file contains your constants
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http; // Import the http package

class Web3Service {
 final String infuraUrl = infura_url;
 final http.Client httpClient = http.Client(); // Use http.Client
 Web3Client ethClient;
 DeployedContract contract;

 Web3Service() {
    init();
 }

 Future<void> init() async {
    ethClient = Web3Client(infuraUrl, httpClient);
    String abi = await rootBundle.loadString('assets/abi/servicerequest.abi.json');
    // Ensure contractAddress1 is correctly defined in your constants.dart
    String contractAddress = contractAddress1;
    contract = DeployedContract(
        ContractAbi.fromJson(abi, 'ServiceRequest'),
        EthereumAddress.fromHex(contractAddress));
 }

 Future<String> callFunction(String funcname, List<dynamic> args,
      String privateKey) async {
    EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
    final ethFunction = contract.function(funcname);
    try {
      final result = await ethClient.sendTransaction(
          credentials,
          Transaction.callContract(
            contract: contract,
            function: ethFunction,
            parameters: args,
          ),
          chainId: null,
          fetchChainIdFromNetworkId: true);
      // Consider checking the transaction receipt or response here
      return result;
    } catch (e) {
      // Handle error appropriately
      print('Error sending transaction: $e');
      throw e; // Rethrow the error or handle it as needed
    }
 }

 Future<String> registerServiceRequest(String vehicleName, String vtype,
      String privateKey) async {
    var response = await callFunction(
        'registerServiceRequest', [vehicleName, vtype], privateKey);
    // Consider moving the toast message to where you confirm the transaction was successful
    Fluttertoast.showToast(
        msg: "Service request registered successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
    return response;
 }
}
