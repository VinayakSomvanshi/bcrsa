import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Web3Service {
  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString('assets/images/abi.json');
    String contractAddress = contractAddress1;
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
  }

  Future<String> registerServiceRequest(
      String vehicle, Web3Client ethClient) async {
    var response = await callFunction(
        'registerServiceRequest', [vehicle], ethClient, private_key);
    Fluttertoast.showToast(
        msg: "Service request registered successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
    return response;
  }
}
