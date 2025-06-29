import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/provider/dashboard_provider.dart';
import 'package:astrobandhan/screens/astrologer/astrologer_screen.dart';
import 'package:astrobandhan/screens/chat/chat_screen.dart';
import 'package:astrobandhan/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:astrobandhan/provider/socket_provider.dart';
import 'package:astrobandhan/utils/app_colors.dart'; // Colors file import
import 'package:astrobandhan/datasource/model/others/chatRoom_model.dart';

class ChatRoomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat Room',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20, // Optional: Adjust font size
            fontWeight: FontWeight.bold, // Optional: Make it bold
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: Consumer<SocketProvider>(
        builder: (context, socketProvider, child) {
          final chatRoomModel = socketProvider.chatRoomModel;
          print("Chat Room Model: ${chatRoomModel?.toJson()}");
          if (chatRoomModel == null) {
            return const Center(
              child: Text(
                'No chat room available .',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  kPrimaryColor.withOpacity(0.1),
                  kPrimaryColor.withOpacity(0.05),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Pass the chatRoomModel instead of socketProvider
                  _buildGradientCard(context, chatRoomModel, socketProvider),
                  const SizedBox(height: 20),
                  // if (chatRoomModel.status == 'pending') _buildPendingStatus(),
                  // if (chatRoomModel.status == 'confirmed')
                  //   _buildConfirmedStatus(socketProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatTimeRemaining(int remainingSeconds) {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Widget _buildGradientCard(BuildContext context, ChatRoomModel chatRoomModel,
      SocketProvider socketProvider) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            kPrimaryColor.withOpacity(0.1),
            const Color.fromARGB(255, 41, 165, 11).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          width: 2,
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(chatRoomModel.astrologer.avatar),
                  radius: 30,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chatRoomModel.astrologer.name,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(chatRoomModel.status),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          chatRoomModel.status.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Created at: ${chatRoomModel.createdAt.date} ${chatRoomModel.createdAt.time}',
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Text(
                      //   'Updated at: ${chatRoomModel.updatedAt.date} ${chatRoomModel.updatedAt.time}',
                      //   style: const TextStyle(
                      //     fontSize: 12.0,
                      //     color: Colors.white70,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white54, thickness: 1),
            const SizedBox(height: 15),
            _buildStatusSection(context, chatRoomModel, socketProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context, ChatRoomModel chatRoomModel,
      SocketProvider socketProvider) {
    if (chatRoomModel.status == 'pending') {
      return Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align children to the left
        children: [
          _buildPendingStatus(),
          const SizedBox(height: 5), // 5px vertical gap
          SizedBox(
            width: double.infinity, // Makes the button take full width
            child: ElevatedButton(
              onPressed: () async {
                print("Chat Request Canceled");
                socketProvider.startChat(
                  chatRoomModel.user.id,
                  chatRoomModel.astrologer.id,
                  chatRoomModel.chatRoomId,
                  "cancel",
                );

                // Show loader dialog
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );

                await Future.delayed(
                    Duration(seconds: 3)); // Wait for 3 seconds

                // Close the loader
                Navigator.of(context, rootNavigator: true).pop();

                // Reset current index and navigate
                Provider.of<DashboardProvider>(context, listen: false)
                    .setCurrentIndex(0);
                Provider.of<DashboardProvider>(context, listen: false)
                    .setCurrentIndex(3);

                // Navigate to the root screen
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                alignment: Alignment
                    .center, // Aligns the text inside the button to the left
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text('Cancel Request'),
            ),
          ),
        ],
      );
    } else if (chatRoomModel.status == 'confirmed') {
      return Column(
        children: [
          ElevatedButton(
            onPressed: () {
              print("Chat Confirmed");
              socketProvider.startChat(
                chatRoomModel.user.id,
                chatRoomModel.astrologer.id,
                chatRoomModel.chatRoomId,
                "accept", // Confirm request logic
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ChatScreen(chatRoomModel: chatRoomModel),
                ),
              );
            },
            child: const Text('Confirm to Start Chat'),
          ),
          const Text(
            'Please confirm within 1 minute, or the chat will be automatically rejected.',
            style: TextStyle(color: Colors.redAccent, fontSize: 14),
            textAlign: TextAlign.left,
          ),
        ],
      );
    } else if (chatRoomModel.status == 'active') {
      return Row(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ChatScreen(chatRoomModel: chatRoomModel),
                ),
              );
            },
            child: const Text('Join Chat'),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () async {
              socketProvider.endChat(chatRoomModel.user.id,
                  chatRoomModel.astrologer.id, chatRoomModel.chatRoomId);
              showToastMessage('Chat Ended Successfully!', isError: false);
              // Show loader dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );

              await Future.delayed(Duration(seconds: 4)); // Wait for 4 seconds

              // Close the loader
              Navigator.of(context, rootNavigator: true).pop();

              // Reset current index and navigate
              Provider.of<DashboardProvider>(context, listen: false)
                  .setCurrentIndex(0);
              Provider.of<DashboardProvider>(context, listen: false)
                  .setCurrentIndex(3);

              // Navigate to the root screen
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text('End Chat'),
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildActiveStatus(
      SocketProvider socketProvider, ChatRoomModel chatRoomModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Join Chat Button
        ElevatedButton(
          onPressed: () {
            print("Joining the chat");

            final userId = chatRoomModel.user.id;
            final astrologerId = chatRoomModel.astrologer.id;
            final chatRoomId = chatRoomModel.chatRoomId;

            // Call the joinChat function
            socketProvider.startChat(
              userId,
              astrologerId,
              chatRoomId,
              'join', // Indicating join request
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Join Chat',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
        // End Chat Button
        ElevatedButton(
          onPressed: () {
            print("Ending the chat");

            final userId = chatRoomModel.user.id;
            final astrologerId = chatRoomModel.astrologer.id;
            final chatRoomId = chatRoomModel.chatRoomId;

            // Call the endChat function
            socketProvider.startChat(
              userId,
              astrologerId,
              chatRoomId,
              'end', // Indicating end request
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'End Chat',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'active':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildPendingStatus() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.hourglass_empty, color: Colors.white, size: 28),
              const SizedBox(width: 15),
              const Expanded(
                child: Text(
                  'Request Sent to Astrologer',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Please wait for the astrologer to accept your request.',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmedStatus(
      SocketProvider socketProvider, ChatRoomModel chatRoomModel) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              const Text(
                'Astrologer has accepted your request',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(
                      value: socketProvider.remainingSeconds / 60,
                      strokeWidth: 8,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        _formatTimeRemaining(socketProvider.remainingSeconds),
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'remaining',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  print("Chat has started0");

                  // Get data from chatRoomModel
                  final userId = chatRoomModel.user.id; // ✅ Correct
                  final astrologerId = chatRoomModel.astrologer.id; // ✅ Correct
                  final chatRoomId = chatRoomModel.chatRoomId; // ✅ Correct
                  final response = "accept"; // You can adjust based on flow

// Call the startChat function
                  socketProvider.startChat(
                    userId,
                    astrologerId,
                    chatRoomId,
                    response,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Confirm to Start Chat',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  print("Chat denied by user");

                  final userId = chatRoomModel.user.id; // ✅ Correct
                  final astrologerId = chatRoomModel.astrologer.id; // ✅ Correct
                  final chatRoomId = chatRoomModel.chatRoomId; // ✅ Correct
                  final response = "confirmed"; // You can adjust based on flow

// Call the startChat function
                  socketProvider.startChat(
                    userId,
                    astrologerId,
                    chatRoomId,
                    response,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.red, // changed color for cancel button
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Cancel Chat Request',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
