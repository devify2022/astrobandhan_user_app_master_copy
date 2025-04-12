import 'dart:convert';
import 'dart:math';

import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/provider/balance_provider.dart';
import 'package:astrobandhan/widgets/custom_app_bar_widget.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:provider/provider.dart';

/// A sample screen that demonstrates how to integrate
/// PhonePe Payment SDK in a Flutter app.

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  // Replace these with your real credentials
  final String environmentValue = 'PRODUCTION'; // or 'STAGING'

  String saltkey = 'bcd3523e-d9bd-449d-9657-7b2fc3adf8a1';
  String appId = "null";
  String merchantId = "M22SRTNIKN7W4";
  String packageName = "com.phonepe.app";

  /// The package name for PhonePe.

  /// If you want logs from the PhonePe SDK, set to true.
  final bool enableLogging = true;

  /// Salt index (usually "1" unless your salt key changes).
  final String saltIndex = "1";

  /// For verifying payment status, we’ll call:
  /// https://api.phonepe.com/apis/hermes/pg/v1/status/{merchantId}/{merchantTransactionId}
  final String apiEndPoint = "/pg/v1/pay";
  final String statusEndPointBase =
      "https://api.phonepe.com/apis/hermes/pg/v1/status";

  /// Payment callback URL for PhonePe
  /// (can be any URL your backend listens on, or a webhook testing site).
  final String callbackUrl =
      "https://webhook.site/2b615807-fbb7-45a3-b521-e78fba3b8ff1";

  // Controllers and state
  final TextEditingController _amountController = TextEditingController();
  String selectedFilter = '';
  Random random = Random();

  // Will hold the final request body, transaction ID, and checksum
  String? merchantTransactionId;
  String? requestBody; // base64 JSON
  String? checksum;

  List<List<Map<String, String>>> chunkList(
      List<Map<String, String>> list, int chunkSize) {
    List<List<Map<String, String>>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(
          i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }

  late List<List<Map<String, String>>> rows;

  @override
  void initState() {
    super.initState();
    _initPhonePeSdk();
    rows = chunkList(items, 3);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  /// Step 1: Initialize the PhonePe SDK
  Future<void> _initPhonePeSdk() async {
    PhonePePaymentSdk.init(environmentValue, appId, merchantId, enableLogging)
        .then((val) {
      setState(() {
        debugPrint('PhonePe SDK Initialized: $val');
      });
    }).catchError((error) {
      debugPrint("PhonePe SDK init error -> $error");
    });
  }

  void _onAddMoneyPressed(BalanceProvider balanceProvider) {
    final userInput = _amountController.text.replaceAll('₹', '').trim();
    if (userInput.isEmpty) {
      showToastMessage("Please enter an amount");
      return;
    }

    double? amountDouble = double.tryParse(userInput);
    if (amountDouble == null || amountDouble <= 0) {
      showToastMessage("Please enter a valid numeric amount");
      return;
    }

    // Step 2: Generate a unique transaction ID
    final int randomNumber = random.nextInt(1000000);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    merchantTransactionId = "${timestamp}_$randomNumber";

    // Step 3: Build request body & checksum
    requestBody = _buildChecksumFromAmount(amountDouble);
    if (requestBody == null) {
      _showSnackBar("Error building payment request body");
      return;
    }

    // Step 4: Call startPgTransaction
    _startPgTransaction(balanceProvider);
  }

  /// Build the base64-encoded JSON body and the checksum string
  String? _buildChecksumFromAmount(double amountDouble) {
    try {
      // Multiply by 100 for minor units
      int amountInPaise = (amountDouble * 100).toInt();

      final Map<String, dynamic> requestData = {
        "merchantId": merchantId,
        "merchantTransactionId": merchantTransactionId ?? "",
        "merchantUserId": "MUID123",
        "amount": amountInPaise,
        "callbackUrl": callbackUrl,
        "mobileNumber": "",
        "paymentInstrument": {"type": "PAY_PAGE"}
      };

      // JSON -> base64
      String encodedJson = jsonEncode(requestData);
      String base64Body = base64.encode(utf8.encode(encodedJson));

      // checksum -> sha256(base64Body + /pg/v1/pay + saltKey) + ### + saltIndex
      final String dataToHash = base64Body + apiEndPoint + saltkey;
      final String sha256Hash =
          sha256.convert(utf8.encode(dataToHash)).toString();
      checksum = '$sha256Hash###$saltIndex';

      return base64Body; // Return the base64 string to be used in startTransaction
    } catch (e) {
      debugPrint("Error building checksum: $e");
      return null;
    }
  }

  /// Actually calls the PhonePe SDK’s startTransaction method
  void _startPgTransaction(BalanceProvider balanceProvider) {
    if (requestBody == null || checksum == null) {
      _showSnackBar("Missing requestBody or checksum");
      return;
    }

    PhonePePaymentSdk.startTransaction(
            requestBody!, callbackUrl, checksum!, packageName)
        .then((response) async {
      if (response == null) {
        debugPrint("Flow incomplete (null response).");
        return;
      }

      debugPrint("Payment response: $response");

      /// Typically, response will have a `status` key and an `error` if any.
      /// E.g.: {status: SUCCESS, error: null}
      String status = response['status']?.toString() ?? 'UNKNOWN';
      String error = response['error']?.toString() ?? '';

      if (status == 'SUCCESS') {
        /// Payment is successful from the client side,
        /// but it's good to cross-verify on the server side or via the next check.
        debugPrint("Flow completed - Status: Success");

        // Optionally, you can directly call checkPaymentStatus
        // to verify with PhonePe server:
        if (merchantTransactionId != null) {
          await _checkPaymentStatus(merchantTransactionId!, balanceProvider);
        }
      } else {
        debugPrint("Flow completed with status: $status, error: $error");
      }
    }).catchError((error) {
      debugPrint("startTransaction error: $error");
    });
  }

  /// (Optional) Step 5: Verify the transaction from PhonePe’s servers
  Future<void> _checkPaymentStatus(
      String mtxId, BalanceProvider balanceProvider) async {
    final String url = '$statusEndPointBase/$merchantId/$mtxId';

    // Generate the X-VERIFY header
    final String xVerify = _generateVerifyHeader(mtxId);

    // Prepare headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-VERIFY': xVerify, // e.g.: "sha256Hash###saltIndex"
      'X-MERCHANT-ID': merchantId
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      debugPrint("Status Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        bool success = data['success'] == true;
        String message = data['message'] ?? '';
        if (success) {
          // data['data']['state'] might be COMPLETED, PENDING, FAILED, etc.
          String state = data['data']['state'] ?? '';
          String transactionId = data['data']['transactionId'] ?? '';
          int amount = data['data']['amount'] ?? 0;

          if (state == 'COMPLETED') {
            // The payment is successful & verified
            debugPrint(
                "Payment success verified: $transactionId, amount: $amount");
            balanceProvider.addBalance(
                amount: amount / 100,
                transactionId: transactionId,
                amountType: 'credit');
            // await _addBalanceToBackend(
            //   amount: amount / 100, // Convert back to original amount
            //   transactionId: transactionId,
            //   amountType: "credit",
            // );
            // Navigate or show a success message, update wallet, etc.
          } else {
            debugPrint("Payment is $state: $message");
          }
        } else {
          // Possibly an error code + message
          debugPrint("Payment verification failed: $message");
        }
      } else {
        debugPrint("Failed to reach server: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Exception in checkPaymentStatus: $e");
    }
  }

  /// Creates the X-VERIFY header for the status check
  String _generateVerifyHeader(String mtxId) {
    /// Endpoint pattern: /pg/v1/status/{merchantId}/{merchantTransactionId}
    final String dataToHash = "/pg/v1/status/$merchantId/$mtxId$saltkey";
    final String sha256Hash =
        sha256.convert(utf8.encode(dataToHash)).toString();

    return '$sha256Hash###$saltIndex';
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  List<Map<String, String>> items = [
    {'amount': '25', 'message': 'Get ₹25'},
    {'amount': '50', 'message': 'Get ₹75'},
    {'amount': '100', 'message': 'Get ₹150'},
    {'amount': '199', 'message': 'Get ₹300'},
    {'amount': '500', 'message': 'Get 50% Extra'},
    {'amount': '1000', 'message': 'Get 6% Extra'},
    {'amount': '2000', 'message': 'Get 11% Extra'},
    {'amount': '3000', 'message': 'Get 11% Extra'},
    {'amount': '5000', 'message': 'Get 14% Extra'},
  ];

  /// Simple UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
          title: 'Add Money'.toUpperCase(), textAlignCenter: true),
      body: Consumer<BalanceProvider>(
          builder: (context, balanceProvider, child) => Container(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          enabled: false,
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.white, // Input text color
                          ),

                          cursorColor: Colors.white,
                          // Cursor color
                          decoration: InputDecoration(
                            labelText: "Amount",
                            labelStyle: TextStyle(
                              color: Colors.white, // Label text color
                            ),
                            hintText: "e.g. 200",
                            hintStyle: TextStyle(
                              color: Colors
                                  .white70, // Hint text color (slightly transparent)
                            ),
                            prefixText: "₹ ",
                            prefixStyle: TextStyle(
                              color: Colors.white, // Prefix text color
                              fontWeight: FontWeight.bold,
                            ),
                            filled: true,
                            fillColor: Colors.white10,
                            // Background fill color (optional)
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white, // Enabled border color
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white, // Focused border color
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red, // Error border color
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red, // Focused error border color
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          // Optionally, add validation logic
                          // onChanged: (value) {
                          //   // Validate input
                          // },
                        )),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      child: Column(
                        children: rows.map((rowItems) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: rowItems.map((item) {
                              return Expanded(
                                child: Container(
                                  margin: const EdgeInsets.all(4.0),
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 5,
                                        offset: Offset(0, 2), // Shadow position
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        item['message']!, // Dynamic message
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400, // Semi-bold
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      ChoiceChip(
                                        label: Text(
                                          "₹${item['amount']}",
                                          style: TextStyle(
                                            color: selectedFilter ==
                                                    item['amount']
                                                ? Colors
                                                    .black // Text color when selected (on light bg)
                                                : Colors
                                                    .white, // Text color when not selected (on dark bg)
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        selected:
                                            selectedFilter == item['amount'],
                                        selectedColor: Colors.green.shade100,
                                        backgroundColor: Colors
                                            .black87, // Optional: dark background for unselected
                                        onSelected: (selected) {
                                          setState(() {
                                            selectedFilter =
                                                selected ? item['amount']! : '';
                                            _amountController.text =
                                                item['amount']!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }).toList(),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        _onAddMoneyPressed(balanceProvider);
                      },
                      child: const Text("ADD MONEY"),
                    ),
                  ],
                ),
              )),
    );
  }
}
