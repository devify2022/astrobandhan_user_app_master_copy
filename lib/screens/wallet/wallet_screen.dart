import 'package:astrobandhan/helper/date_converter.dart';
import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/provider/balance_provider.dart';
import 'package:astrobandhan/screens/wallet/add_money_screen.dart';
import 'package:astrobandhan/utils/app_colors.dart';
import 'package:astrobandhan/utils/images.dart';
import 'package:astrobandhan/utils/size.util.dart';
import 'package:astrobandhan/utils/text.styles.dart';
import 'package:astrobandhan/widgets/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    providerBalance.getBalanceHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BalanceProvider>(builder: (context, balanceProvider, child) {
      return Scaffold(
        appBar: CustomAppBarWidget(title: 'WALLET', textAlignCenter: true),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainContent(balanceProvider),
            balanceProvider.isLoading
                ? spaceZero
                : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Recharge History', style: poppinsStyle500Medium.copyWith(fontSize: 20, color: Colors.white))),
            spaceHeight10,
            Expanded(child: _buildRideHistory(balanceProvider)),
          ],
        ),
      );
    });
  }

  Widget _buildMainContent(BalanceProvider balanceProvider) {
    return balanceProvider.isLoading
        ? spaceZero
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.topLeft,
                  colors: [
                    Color.fromRGBO(170, 255, 0, 0.4),
                    Color.fromRGBO(60, 0, 255, 0.4),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available Balance',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white60),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '₹${balanceProvider.balanceHistoryModel.balance}',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 32, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (loginUserModel.id != null) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddMoneyScreen()));
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => MerchantApp()));
                          } else {
                            print("object");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                            padding: const EdgeInsets.symmetric(horizontal: 16)),
                        child: const Text(
                          'ADD MONEY',
                          style: TextStyle(color: kTextColor, fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildRideHistory(BalanceProvider balanceProvider) {
    return balanceProvider.isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: balanceProvider.balanceHistoryModel.transactions!.map((transaction) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 1),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.topLeft,
                        colors: [Color.fromRGBO(170, 255, 0, 0.4), Color.fromRGBO(60, 0, 255, 0.4)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(30)),
                            child: SvgPicture.asset(ImageResources.rupi_circle_icon),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transaction.debitType ?? "Unknown",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                Text(
                                  DateConverter.estimatedDate(transaction.createdAt!),
                                  style: TextStyle(color: Colors.white70, fontSize: 15, fontFamily: 'Poppins'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            (transaction.debitType == 'credit' ? '+₹' : '-₹') + transaction.amount.toString(),
                            style: TextStyle(
                              color: transaction.debitType == 'credit'
                                  ? Colors.green // Green color for credit
                                  : Colors.redAccent, // Red color for debit
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
  }
}
