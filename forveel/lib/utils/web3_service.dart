import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'constants.dart'; // Ensure this file contains your constants
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http; // Import the http package

class Web3Service {
  final String infura_url =
      "https://sepolia.infura.io/v3/89c8111a87c44426a9ecfe8bd150cf1c";
  final http.Client httpClient = http.Client(); // Use http.Client

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString('assets/images/abi.json');
    String contractAddress =
        contractAddress1; // Ensure this is defined in your constants
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, 'ServiceRequest'),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<String> callFunction(String funcname, List<dynamic> args,
      Web3Client ethClient, String privateKey) async {
    EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
    DeployedContract contract = await loadContract();
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
      return result;
    } catch (e) {
      // Handle error appropriately
      print('Error sending transaction: $e');
      throw e; // Rethrow the error or handle it as needed
    }
  }

  Future<String> registerServiceRequest(String vehicleName, String vtype,
      String privateKey, Web3Client ethClient) async {
    var response = await callFunction(
        'registerServiceRequest', [vehicleName, vtype], ethClient, privateKey);
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
