import 'package:astrobandhan/Service/SocketService.dart';
import 'package:astrobandhan/datasource/model/others/chatRoom_model.dart';
import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/provider/socket_provider.dart';
import 'package:astrobandhan/utils/app_colors.dart';
import 'package:astrobandhan/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async'; // For timer functionality
import 'package:image_picker/image_picker.dart'; // Add this package to pubspec.yaml
import 'dart:io'; // For File handling
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  final ChatRoomModel chatRoomModel;

  const ChatScreen({Key? key, required this.chatRoomModel}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class Message {
  final String content;
  final bool isSent;
  final bool isImage;
  final String? messageType;
  final DateTime timestamp;

  Message({
    required this.content,
    required this.isSent,
    this.isImage = false,
    this.messageType,
    required this.timestamp,
  });
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isUploading = false; // Track upload progress
  bool _isLoading = false; // Loader state
  late Timer _timer;
  DateTime? _startTime;
  String _elapsedTime = "00:00:00";
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = []; // Use Message type instead of String
  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeTimer();
    _fetchChatMessages(); // Fetch chat messages from the API
    Provider.of<SocketProvider>(context, listen: false)
        .onMessageReceived((data) {
      print("Received message from socket: $data");

      final timestamp = data['timestamp'] != null
          ? DateTime.parse(data['timestamp'])
              .add(const Duration(hours: 5, minutes: 30))
          : DateTime.now();

      final newMessage = Message(
        content: data['message'],
        isSent: data['senderType'] == 'user',
        isImage: data['isImage'] ?? false,
        messageType: data['messageType'],
        timestamp: timestamp,
      );

      if (mounted) {
        setState(() {
          _messages.add(newMessage);
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    });
    Provider.of<SocketProvider>(context, listen: false).onChatEnded((data) {
      Navigator.pop(context); // Close the chat screen when the chat ends
    });
  }

  void _initializeTimer() {
    _startTime = _parseUpdatedAtToDateTime(widget.chatRoomModel.updatedAt);

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _updateTimer();
    });
  }

  DateTime _parseUpdatedAtToDateTime(UpdatedAt updatedAt) {
    final date = updatedAt.date; // format: dd-MM-yyyy
    final time = updatedAt.time; // format: h:mm a

    // Combine and parse using intl
    final dateTimeString = '$date $time';
    return DateFormat('dd-MM-yyyy h:mm a').parse(dateTimeString);
  }

  void _updateTimer() {
    if (_startTime == null) return;

    final now = DateTime.now();
    final duration = now.difference(_startTime!);
    setState(() {
      _elapsedTime = _formatDuration(duration);
    });
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  Future<void> _fetchChatMessages() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.post(
        Uri.parse(AppConstant.getCurrentChatHistoryURI),
        headers: {
          'Content-Type': 'application/json',
          // Add auth headers here if required
        },
        body: jsonEncode({
          'chatRoomId': widget.chatRoomModel.chatRoomId,
        }),
      );

      if (response.statusCode == 200) {
        print("API Response: ${response.body}");

        final data = jsonDecode(response.body);

        // Check if data is structured correctly
        if (data['statusCode'] == 200 &&
            data['data'] != null &&
            data['data'].isNotEmpty &&
            data['data'][0]['messages'] != null) {
          final List messages = data['data'][0]['messages'];

          final List<Message> fetchedMessages = messages.map<Message>((msg) {
            final timestamp = msg['timestamp'] != null
                ? DateTime.parse(msg['timestamp'])
                    .add(const Duration(hours: 5, minutes: 30))
                : DateTime.now();

            return Message(
              content: msg['message'],
              isSent: msg['senderType'] == 'user',
              isImage: msg['isImage'] ?? false,
              messageType: msg['messageType'],
              timestamp: timestamp,
            );
          }).toList();

          setState(() {
            _messages.insertAll(0, fetchedMessages);
          });

          print("Fetched ${fetchedMessages.length} messages.");
          Future.delayed(const Duration(seconds: 4), () {
            setState(() {
              _isLoading = false;
            });
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
        } else {
          print("No messages found or invalid response structure.");
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        print('API call failed: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching chat messages: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _clearTimerData() async {
    // Clear the start time if needed
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_start_time');
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        // Introduce a small delay to ensure the layout has fully rendered
        Future.delayed(Duration(milliseconds: 100), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 142, 142, 145),
                Color.fromARGB(150, 66, 146, 238)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  NetworkImage(widget.chatRoomModel.astrologer.avatar),
              radius: 20,
              backgroundColor: kPinkColor,
              foregroundColor: kTextColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chatRoomModel.astrologer.name,
                    style: const TextStyle(
                        color: whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 14, color: whiteColor.withOpacity(0.8)),
                      const SizedBox(width: 4),
                      Text(
                        _elapsedTime,
                        style: TextStyle(
                            fontSize: 13, color: whiteColor.withOpacity(0.9)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.videocam, color: whiteColor),
                  onPressed: () {
                    // Implement video call functionality
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.call, color: whiteColor),
                  onPressed: () {
                    // Implement call functionality
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: whiteColor),
            )
          : Column(
              children: [
                // Status bar with gradient
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color.fromARGB(255, 83, 81, 85), blueColor],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.circle, size: 10, color: lightGreenColor),
                      SizedBox(width: 6),
                      Text(
                        "Online",
                        style: TextStyle(color: whiteColor, fontSize: 14),
                      ),
                      Spacer(),
                      Text(
                        "Consultation Rate: ₹${widget.chatRoomModel.astrologer.consultation_rate}/min",
                        style: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),

                // Chat messages area
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/img/chat_bg.png'), // path to your asset
                        fit: BoxFit
                            .cover, // adjust as needed (cover, contain, fill, etc.)
                      ),
                    ),
                    child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          final formattedTime =
                              DateFormat('hh:mm a').format(message.timestamp);
                          if (message.content ==
                                  'Astrologer has joined the chat.' ||
                              message.content == 'User has joined the chat.') {
                            // System message style (full width centered)
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    message.content,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                          return Align(
                            alignment: message.isSent
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: message.isSent
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.75,
                                  ),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  padding: message.isImage
                                      ? const EdgeInsets.all(3)
                                      : const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: message.isSent
                                          ? [
                                              const Color.fromARGB(
                                                  255, 64, 146, 223),
                                              const Color.fromARGB(
                                                  255, 26, 25, 25)
                                            ]
                                          : [
                                              const Color.fromARGB(
                                                  255, 54, 53, 52),
                                              const Color.fromARGB(
                                                  255, 45, 62, 65)
                                            ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: message.isImage ||
                                          message.messageType == 'image'
                                      ? message.content == 'Uploading...'
                                          ? Center(
                                              child: CircularProgressIndicator(
                                                  color: Colors.white),
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => Scaffold(
                                                      backgroundColor:
                                                          Colors.black,
                                                      appBar: AppBar(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        elevation: 0,
                                                        iconTheme:
                                                            const IconThemeData(
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                      body: Center(
                                                        child: message.content!
                                                                .startsWith(
                                                                    'http')
                                                            ? Image.network(
                                                                message
                                                                    .content!)
                                                            : Image.file(File(
                                                                message
                                                                    .content!)),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                                child: message.content!
                                                        .startsWith('http')
                                                    ? Image.network(
                                                        message.content!,
                                                        fit: BoxFit.cover)
                                                    : Image.file(
                                                        File(message.content!),
                                                        fit: BoxFit.cover),
                                              ),
                                            )
                                      : Text(
                                          message.content,
                                          style: TextStyle(
                                              color: whiteColor, fontSize: 16),
                                        ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Text(
                                    formattedTime,
                                    style: TextStyle(
                                        color: Colors.grey[400], fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ),

                // Message input area with dark theme
                Container(
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        offset: const Offset(0, -2),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(106, 38, 244, 227),
                              Color.fromARGB(113, 79, 209, 90)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add_photo_alternate,
                              color: whiteColor, size: 22),
                          onPressed: () {
                            _showImageSourceOptions(context);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              controller: _messageController,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0)),
                              decoration: InputDecoration(
                                hintText: 'Type a message...',
                                hintStyle: TextStyle(
                                    color: const Color.fromARGB(255, 0, 0, 0)
                                        .withOpacity(0.6)),
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              maxLines: null,
                              textCapitalization: TextCapitalization.sentences,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(106, 38, 244, 227),
                              Color.fromARGB(113, 79, 209, 90)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.send,
                              color: whiteColor, size: 22),
                          onPressed: _sendMessage,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final messageText = _messageController.text.trim();
      final regex = RegExp(
        r'(\+?\d{10,15})|([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})|(facebook|fb|instagram|insta|twitter|tiktok|snapchat|linkedin|whatsapp|telegram|discord|youtube|t.me|wa.me|snap\.com|linkedin\.com|tiktok\.com|facebook\.com|instagram\.com|twitter\.com|youtube\.com)',
        caseSensitive: false,
      );
      if (regex.hasMatch(_messageController.text.trim())) {
        // Show a toast message if regex matches
        showToastMessage(
            "Please do not share personal information or social media links.");
        return; // Don't send the message if it matches the regex
      }

      final chatRoom = widget
          .chatRoomModel; // Access chatRoomModel from your context or provider

      // Prepare the payload for emitting
      final payload = {
        'chatRoomId': chatRoom.chatRoomId, // chat room ID
        'senderType': 'user', // sender type, you can adjust if needed
        'senderId': chatRoom.user.id, // senderId from the chatRoom model
        'recipientId':
            chatRoom.astrologer.id, // astrologer ID from the chatRoom model
        'messageType': 'text', // message type
        'message': messageText, // message content
      };

      // Access the SocketProvider
      final socketProvider =
          Provider.of<SocketProvider>(context, listen: false);

      // Send the message using the provider
      socketProvider.sendMessage(
        chatRoom.user.id, // userId
        chatRoom.astrologer.id, // astrologerId
        chatRoom.chatRoomId, // chatRoomId
        messageText, // message content
        'text',
        'user', // senderType
      );

      setState(() {
        // Add the user’s message to the UI
        _messages.add(Message(
            content: messageText,
            isSent: true,
            timestamp: DateTime.now().toLocal()));
        _messageController.clear(); // Clear the input field
      });
    }
  }

  void _showImageSourceOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Select Image Source",
              style: TextStyle(
                color: whiteColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageSourceOption(
                  icon: Icons.camera_alt,
                  label: "Camera",
                  onTap: () {
                    Navigator.pop(context);
                    _getImage(ImageSource.camera);
                  },
                ),
                _buildImageSourceOption(
                  icon: Icons.photo_library,
                  label: "Gallery",
                  onTap: () {
                    Navigator.pop(context);
                    _getImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [kPrimaryColor, darkBlueColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: kSecondaryColor),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(color: whiteColor, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        // Add "Uploading..." message to show loader
        final uploadingMessage = Message(
          content: 'Uploading...', // Show "Uploading..." text while uploading
          isSent: true,
          isImage: true,
          messageType: 'image', // No image path yet
          timestamp: DateTime.now().toLocal(),
        );

        setState(() {
          // Add uploading message to _messages list
          _messages.add(uploadingMessage);
        });

        // Upload the image to Cloudinary and get the image URL
        String? imageUrl = await uploadImageToCloudinary(pickedFile);

        if (imageUrl != null) {
          setState(() {
            // Remove the "Uploading..." message and replace it with the actual image message
            _messages
                .remove(uploadingMessage); // Remove the "Uploading..." message
            _messages.add(Message(
              content: imageUrl, // Set the image URL here
              isSent: true,
              isImage: true,
              messageType: 'image', // Store the image URL as the path
              timestamp: DateTime.now().toLocal(),
            ));
          });

          // Send the message with the image URL
          _sendImageMessage(imageUrl);
        } else {
          // If the upload failed, remove the placeholder and show an error message
          setState(() {
            _messages.remove(uploadingMessage);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to upload image"),
              backgroundColor: darkBlueColor,
            ),
          );
        }
      }
    } catch (e) {
      print("Image picking error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to pick image"),
          backgroundColor: darkBlueColor,
        ),
      );
    }
  }

  Future<String?> uploadImageToCloudinary(XFile imageFile) async {
    final cloudName = 'dlol2hjj8';
    final uploadPreset = 'chatting';

    final String url =
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['upload_preset'] = uploadPreset;
    request.files
        .add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final data = json.decode(responseData);
        return data['secure_url']; // Return the image URL
      } else {
        print('Cloudinary upload failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  void _sendImageMessage(String imageUrl) {
    final chatRoom = widget.chatRoomModel;

    // Prepare the payload for emitting with the image URL
    final payload = {
      'chatRoomId': chatRoom.chatRoomId,
      'senderType': 'user',
      'senderId': chatRoom.user.id,
      'recipientId': chatRoom.astrologer.id,
      'messageType': 'image',
      'message': imageUrl,
    };

    final socketProvider = Provider.of<SocketProvider>(context, listen: false);

    socketProvider.sendMessage(
      chatRoom.user.id,
      chatRoom.astrologer.id,
      chatRoom.chatRoomId,
      imageUrl,
      "image",
      'user',
    );

    _scrollToBottom(); // Scroll to the latest message
  }
}
