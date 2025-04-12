import 'package:astrobandhan/helper/date_converter.dart';
import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/provider/balance_provider.dart';
import 'package:astrobandhan/utils/images.dart';
import 'package:astrobandhan/widgets/custom_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:astrobandhan/utils/app_colors.dart';
import 'package:astrobandhan/utils/text.styles.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String selectedFilter = 'Call History';

  static const _filters = ['Call History', 'Wallet'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    providerBalance.getAllCallHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: kBackgroundColor),
          centerTitle: true,
          title: Text("History",
              style: poppinsStyle600SemiBold.copyWith(fontSize: 17)),
        ),
        body: Consumer<BalanceProvider>(
            builder: (context, balanceProvider, child) => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: _buildFilterChips()),

                    Expanded(
                        child: balanceProvider.isLoading
                            ? Center(child: CircularProgressIndicator())
                            : selectedFilter == 'Call History'
                                ? _buildCallHistory(balanceProvider)
                                : _buildWalletHistory(balanceProvider)),

                    // BlocBuilder<WalletBloc, WalletState>(
                    //   builder: (context, state) {
                    //     if(state is WalletInitial){
                    //        context.read<WalletBloc>().add(FetchCallHistoryDataEvent());
                    //     }
                    //     if (state is WalletLoading) {
                    //       return const Center(child: CircularProgressIndicator());
                    //     } else if (state is WalletLoaded) {
                    //       return ListView.builder(
                    //         physics: NeverScrollableScrollPhysics(),
                    //         shrinkWrap: true,
                    //         itemCount: state.transactions.length,
                    //         itemBuilder: (context, index) {
                    //           final user = state.transactions[index];
                    //           return _buildWalletCard(user.transactionType,user.amount.toString(),user.createdAt);
                    //         },
                    //       );
                    //     } else if (state is ChatHistoryLoaded) {
                    //       return ListView.builder(
                    //         physics: NeverScrollableScrollPhysics(),
                    //         shrinkWrap: true,
                    //         itemCount: state.chatHistory.length,
                    //         itemBuilder: (context, index) {
                    //           final chat = state.chatHistory[index];
                    //           return ChatHistoryWidget(
                    //             date: chat.startedAt,
                    //             rate:
                    //                 chat.astrologerId!.pricePerCallMinute.toString(),
                    //             name: chat.astrologerId!.name,
                    //             duration: chat.duration.toString(),
                    //             imageUrl: chat.astrologerId!.avatar,
                    //           );
                    //         },
                    //       );
                    //     } else if(state is CallHistoryLoaded){
                    //         return ListView.builder(
                    //         physics: NeverScrollableScrollPhysics(),
                    //         shrinkWrap: true,
                    //         itemCount: state.callHistory.length,
                    //         itemBuilder: (context, index) {
                    //           final chat = state.callHistory[index];
                    //           return ChatHistoryWidget(
                    //             date: chat.startedAt,
                    //             rate:
                    //                 chat.astrologerId!.pricePerCallMinute.toString(),
                    //             name: chat.astrologerId!.name,
                    //             duration: chat.duration.toString(),
                    //             imageUrl: chat.astrologerId!.avatar,
                    //           );
                    //         },
                    //       );
                    //     }
                    //
                    //     else if (state is WalletError) {
                    //       return Center(child: Text("Error: ${state.message}"));
                    //     }
                    //     return const Center(child: Text("No Data Available"));
                    //   },
                    // ),
                  ],
                )));
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: _filters.map((label) {
          final isSelected = selectedFilter == label;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Text(label,
                  style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontSize: 14)),
              backgroundColor: const Color(0xFF303F9F),
              selectedColor: Colors.white,
              onSelected: (bool selected) {
                setState(() {
                  selectedFilter = label;
                  switch (selectedFilter) {
                    case 'Call History':
                      providerBalance.getAllCallHistory();
                      break;

                    case 'Chat History':
                      providerBalance.getAllChatHistory();
                      break;

                    case 'Wallet':
                      providerBalance.getBalanceHistory();

                      break;

                    default:
                      print('Call History');
                      break;
                  }
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWalletCard(
    String name,
    String deductmoney,
    String date,
  ) {
    return Container(
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
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(30),
              ),
              child: SvgPicture.asset(
                'assets/SVG/walletRupee.svg',
                width: 28,
                height: 28,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    '${Helper().utcConverter(date)}',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              "+\$ $deductmoney",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          )
        ],
      ),
    );
  }
}

// Widget _buildContentCard() {
//   switch (selectedFilter) {
//     case 'Call History':
//       return _buildHistoryCard(
//         child: _buildCallContent(),
//         useCircularImage: true,
//       );
//     case 'Chat History':
//       return _buildHistoryCard(
//         child: _buildChatContent(),
//         useCircularImage: true,
//       );
//     case 'Wallet':
//       return _buildHistoryCard(
//         // child: _buildWalletContent(),
//         child: _buildRideHistory(),
//         useCircularImage: false,
//       );
//     default:
//       return _buildHistoryCard(
//         child: _buildCallContent(),
//         useCircularImage: true,
//       );
//   }
// }

// Widget _buildHistoryCard(
//     {required Widget child, required bool useCircularImage}) {
//   return Container(
//     width: double.infinity,
//     margin: const EdgeInsets.only(bottom: 12),
//     decoration: BoxDecoration(
//       gradient: LinearGradient(
//         begin: Alignment.centerRight,
//         end: Alignment.topLeft,
//         colors: _gradientColors,
//       ),
//       borderRadius: BorderRadius.circular(12),
//       border: Border.all(
//         color: Colors.white.withOpacity(0.1),
//         width: 1,
//       ),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.2),
//           blurRadius: 8,
//           offset: const Offset(0, 4),
//         ),
//       ],
//     ),
//     child: child,
//   );
// }

// Widget _buildCallContent() {
//   return Row(
//     children: [
//       _buildCardImage(),
//       Expanded(
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildCardTitle('Astrologer Name'),
//               const SizedBox(height: 4),
//               ..._buildCallDetails(),
//             ],
//           ),
//         ),
//       ),
//     ],
//   );
// }

// Widget _buildChatContent() {
//   return Row(
//     children: [
//       _buildCardImage(),
//       Expanded(
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildCardTitle('Astrologer Name'),
//               const SizedBox(height: 4),
//               const Text(
//                 'Sit eget cursus faucibus interdum metus plac lobortis aliquet facilisis elit netus condimentum cursus.',
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: 15,
//                   fontFamily: 'Poppins',
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ],
//   );
// }

// Widget _buildWalletContent() {
//   return Row(
//     children: [
//       Padding(
//         padding: const EdgeInsets.all(12),
//         child: Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             color: Colors.white24,
//             borderRadius: BorderRadius.circular(30),
//           ),
//           child: SvgPicture.asset(
//             'assets/SVG/walletRupee.svg',
//             width: 28,
//             height: 28,
//           ),
//         ),
//       ),
//       Expanded(
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: const [
//               Text(
//                 'Placerat netus',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                   fontFamily: 'Poppins',
//                 ),
//               ),
//               Text(
//                 '12 May 24',
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: 15,
//                   fontFamily: 'Poppins',
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       const Padding(
//         padding: EdgeInsets.all(12),
//         child: Text(
//           '+\$25.00',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.w500,
//             fontFamily: 'Poppins',
//           ),
//         ),
//       ),
//     ],
//   );
// }

Widget _buildWalletHistory(BalanceProvider balanceProvider) {
  // Check if the transactions list is null or empty
  if (balanceProvider.balanceHistoryModel.transactions == null ||
      balanceProvider.balanceHistoryModel.transactions!.isEmpty) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          "No Data Found",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
        ),
      ),
    );
  }

  return SingleChildScrollView(
    physics: BouncingScrollPhysics(),
    child: Column(
      children:
          balanceProvider.balanceHistoryModel.transactions!.map((transaction) {
        return Padding(
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
                    Color.fromRGBO(60, 0, 255, 0.4)
                  ]),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: Colors.white.withOpacity(0.1), width: 1),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(30)),
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
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                              fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    (transaction.debitType == 'credit' ? '+₹' : '-₹') +
                        transaction.amount.toString(),
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

Widget _buildCallHistory(BalanceProvider balanceProvider) {
  return SingleChildScrollView(
    physics: BouncingScrollPhysics(),
    child: Column(
      children: [
        // Check if callHistory is empty
        if (balanceProvider.callHistory.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "No Data Found",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'),
              ),
            ),
          )
        else
          // Otherwise, display the list of call history
          ...balanceProvider.callHistory.map((callHistory) {
            return Padding(
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
                        Color.fromRGBO(60, 0, 255, 0.4)
                      ]),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.1), width: 1),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4)),
                  ],
                ),
                child: ChatHistoryWidget(
                  name: callHistory.astrologerId!.name!,
                  rate: callHistory.astrologerId!.pricePerCallMinute.toString(),
                  duration: callHistory.duration.toString(),
                  date: DateConverter.convertStringToDatetime(
                      callHistory.startedAt!),
                  imageUrl: callHistory.astrologerId!.avatar!,
                ),
              ),
            );
          }).toList(),
      ],
    ),
  );
}

Widget _buildCardImage() {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Image.asset(
        'assets/img/image.png',
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget _buildCardTitle(String title) {
  return Text(
    title,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins',
    ),
  );
}

List<Widget> _buildCallDetails() {
  const textStyle = TextStyle(
    color: Colors.white70,
    fontSize: 15,
  );

  return const [
    Text('Rate: ₹20/min', style: textStyle),
    SizedBox(height: 4),
    Text('Duration: 5 min', style: textStyle),
    SizedBox(height: 4),
    Text('12 May 24, 03:06 pm', style: textStyle),
  ];
}

class AstrologerCard extends StatelessWidget {
  final String name;
  final double ratePerMin;
  final int durationMin;
  final DateTime appointmentTime;
  final String imageUrl;

  const AstrologerCard({
    Key? key,
    required this.name,
    required this.ratePerMin,
    required this.durationMin,
    required this.appointmentTime,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF3a0ca3), // Deep purple
            Color(0xFF2d6a4f), // Forest green
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Profile Image
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Information Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rate: ₹${ratePerMin.toStringAsFixed(0)}/min',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Duration: $durationMin min',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${appointmentTime.day} ${_getMonth(appointmentTime.month)} ${appointmentTime.year}, '
                    '${appointmentTime.hour.toString().padLeft(2, '0')}:'
                    '${appointmentTime.minute.toString().padLeft(2, '0')} '
                    '${appointmentTime.hour >= 12 ? 'pm' : 'am'}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}

class ChatHistoryWidget extends StatelessWidget {
  final String? name;
  final String? rate;
  final String? duration;
  final DateTime? date;
  final String? imageUrl;

  const ChatHistoryWidget(
      {this.name = "",
      this.rate = "",
      this.duration = "",
      this.date,
      this.imageUrl = "",
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF3a0ca3), Color(0xFF2d6a4f)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              // Text('$imageUrl!'),
              Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CustomCachedNetworkImage(
                      url: imageUrl!, width: 30, height: 30)),
              // CircleAvatar(child: Helper().cacheImages(context, imageUrl!), radius: 30.0),
              SizedBox(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name!,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Poppins',
                        color: Colors.white),
                  ),
                  SizedBox(height: 5.0),
                  Text('Rate: $rate',
                      style: TextStyle(fontSize: 14.0, color: Colors.white70)),
                  SizedBox(height: 5.0),
                  Text('Duration: $duration',
                      style: TextStyle(fontSize: 14.0, color: Colors.white70)),
                  SizedBox(height: 5.0),
                  date == null
                      ? SizedBox.shrink()
                      : Text("${Helper().utcConverter(date.toString())}",
                          style:
                              TextStyle(fontSize: 14.0, color: Colors.white70)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
