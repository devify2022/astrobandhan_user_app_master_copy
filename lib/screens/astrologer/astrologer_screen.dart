import 'package:astrobandhan/Service/SocketService.dart';
import 'package:astrobandhan/datasource/model/call/agoraTokenModel.dart';
import 'package:astrobandhan/datasource/model/others/astrologer_model.dart';
import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/provider/agora_provider.dart';
import 'package:astrobandhan/provider/astrologer_provider.dart';
import 'package:astrobandhan/provider/overlay_provider.dart';
import 'package:astrobandhan/provider/socket_provider.dart';
import 'package:astrobandhan/screens/call/call_screen.dart';
import 'package:astrobandhan/screens/call/video_screen.dart';
import 'package:astrobandhan/screens/chat/chat_room_screen.dart';
import 'package:astrobandhan/screens/dashboard/dashboard_screen.dart';
import 'package:astrobandhan/utils/app_constant.dart';
import 'package:astrobandhan/provider/home_provider.dart';
import 'package:astrobandhan/utils/app_colors.dart';
import 'package:astrobandhan/utils/size.util.dart';
import 'package:astrobandhan/utils/text.styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../astrologer/astrologer_details_screen.dart';
import 'dart:convert';
import 'dart:ui'; // Required for ImageFilter.blur

class AstrologerScreen extends StatefulWidget {
  const AstrologerScreen({super.key});

  @override
  State<AstrologerScreen> createState() => _AstrologerScreenState();
}

class _AstrologerScreenState extends State<AstrologerScreen> {
  late ScrollController _scrollController;
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _initialLoadComplete = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ModalRoute.of(context)!.isCurrent) {
        _refreshData();
      }
    });
  }

  Widget _buildOverlay() {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.3),
          ),
        ),
        Center(
          child: Text(
            "Overlay is Active",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ],
    );
  }

  void _loadInitialData() {
    final astrologerProvider =
        Provider.of<AstrologerProvider>(context, listen: false);
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    homeProvider.getAstrologers(page: 1, isFirstTime: true);
    astrologerProvider.getAstrologerCategories();
  }

  // Call this method whenever you want to refresh the data
  void _refreshData() {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final astrologerProvider =
        Provider.of<AstrologerProvider>(context, listen: false);
    setState(() {
      _currentPage = 1;
    });
    astrologerProvider.getAstrologerCategories();
    homeProvider.getAstrologers(page: 1, isFirstTime: true);
  }

  void _scrollListener() {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final astrologerProvider =
        Provider.of<AstrologerProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !homeProvider.bottomLoading &&
        homeProvider.hasNextData &&
        !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
        _currentPage = homeProvider.page + 1;
      });
      astrologerProvider.getAstrologerCategories();
      homeProvider.getAstrologers(page: _currentPage).then((_) {
        setState(() {
          _isLoadingMore = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeProvider, AstrologerProvider>(
      builder: (context, homeProvider, astrologerProvider, child) {
        final allCategories = [
          'All',
          ...astrologerProvider.categories.map((c) => c.name)
        ];

        return Column(
          children: [
            // Category Chips
            SizedBox(
              height: 50,
              child: ListView.builder(
                itemCount: allCategories.length,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ChoiceChip(
                      label: Text(
                        allCategories[index],
                        style: poppinsStyle400Regular.copyWith(
                          color: homeProvider.selectedChip == index
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                      selected: homeProvider.selectedChip == index,
                      backgroundColor: kPrimaryColor,
                      selectedColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      onSelected: (value) async {
                        homeProvider.setSelectedChip(index);
                        if (index == 0) {
                          await homeProvider.getAstrologers(
                              page: 1, isFirstTime: true);
                        } else {
                          final categoryId =
                              astrologerProvider.categories[index - 1].id;
                          await homeProvider
                              .getAstrologersByCategory(categoryId);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            spaceHeight10,

            // Astrologer List
            Expanded(
              child: homeProvider.aiLoading && homeProvider.astrologers.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : homeProvider.astrologers.isEmpty
                      ? const Center(child: Text('No Astrologer Found'))
                      : NotificationListener<ScrollNotification>(
                          onNotification: (scrollNotification) {
                            if (scrollNotification is ScrollEndNotification &&
                                _scrollController.position.pixels >=
                                    _scrollController.position.maxScrollExtent -
                                        200 &&
                                !homeProvider.bottomLoading &&
                                homeProvider.hasNextData &&
                                !_isLoadingMore) {
                              setState(() {
                                _isLoadingMore = true;
                                _currentPage = homeProvider.page + 1;
                              });
                              homeProvider
                                  .getAstrologers(page: _currentPage)
                                  .then((_) {
                                setState(() {
                                  _isLoadingMore = false;
                                });
                              });
                              return true;
                            }
                            return false;
                          },
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: homeProvider.astrologers.length +
                                (homeProvider.bottomLoading ? 1 : 0),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              if (index < homeProvider.astrologers.length) {
                                return _buildAstrologerCard(
                                  context,
                                  homeProvider.astrologers[index],
                                );
                              } else {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }
                            },
                          ),
                        ),
            ),
          ],
        );
      },
    );
  }

  // Rest of your code remains the same...
  Widget _buildAstrologerCard(context, AstrologerModel data) {
    return Container(
      margin: EdgeInsets.only(bottom: 16, left: 12, right: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.topLeft,
          colors: [
            Color.fromRGBO(0, 239, 36, 0.485),
            Color.fromRGBO(60, 0, 255, 0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFFAA88FF).withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 6),
            spreadRadius: 2,
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Column(
          children: [
            // Top part with image and details
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar with premium indicator
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 110,
                      height: 140,
                      margin: EdgeInsets.only(left: 16, top: 16, bottom: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.amber.withOpacity(0.7),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          data.avatar,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Color(0xFF3D1C70),
                              child: Icon(Icons.person,
                                  color: Colors.white60, size: 50),
                            );
                          },
                        ),
                      ),
                    ),
                    // Premium badge
                    if (data.isFeatured && data.rating == 5)
                      Positioned(
                        top: 8,
                        right: -8,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, color: Colors.white, size: 14),
                              SizedBox(width: 2),
                              Text(
                                'PREMIUM',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (data.isFeatured &&
                        (data.rating <= 4 && data.rating >= 2))
                      Positioned(
                        top: 8,
                        right: -8,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, color: Colors.white, size: 14),
                              SizedBox(width: 2),
                              Text(
                                'Top Choice',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Online indicator
                    if (data.status == "available")
                      Positioned(
                        bottom: 4,
                        right: -4,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (data.status == "busy")
                      Positioned(
                        bottom: 4,
                        right: -4,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 0, 0),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),

                    if (data.status == "offline")
                      Positioned(
                        bottom: 4,
                        right: -4,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 84, 80, 80),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                // Details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Name
                            Expanded(
                              child: Text(
                                data.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Rating
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "${data.rating}",
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        // Specialties with icon
                        if (data.specialities.isNotEmpty)
                          SizedBox(
                            height: 20, // Fixed container height
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment
                                    .center, // Vertically center all elements
                                children: [
                                  Icon(Icons.psychology,
                                      color: Colors.purple[200],
                                      size: 16), // Smaller icon to match height
                                  SizedBox(width: 4), // Reduced spacing
                                  ...data.specialities.map((spec) => Padding(
                                        padding: EdgeInsets.only(right: 6),
                                        child: Container(
                                          height: 20, // Match parent height
                                          alignment: Alignment
                                              .center, // Perfect vertical centering
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.purple.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: Colors.purple[200]!,
                                              width: 0.8,
                                            ),
                                          ),
                                          child: Text(
                                            spec,
                                            style: TextStyle(
                                              color: Colors.purple[100],
                                              fontSize:
                                                  10, // Smaller font for compact size
                                              height:
                                                  1.0, // Remove extra line height
                                            ),
                                            textAlign: TextAlign
                                                .center, // Horizontal centering
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        SizedBox(height: 6),
                        // Languages with icon
                        SizedBox(
                          height: 20,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.language,
                                    color: Colors.blue[200], size: 16),
                                SizedBox(width: 4),
                                ...[
                                  'Hindi',
                                  'English',
                                  'Bengali',
                                  'Tamil',
                                  'Urdu'
                                ].map(
                                  (language) => Padding(
                                    padding: EdgeInsets.only(right: 6),
                                    child: Container(
                                      height: 20,
                                      padding: EdgeInsets.zero,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.blue[200]!,
                                            width: 0.8),
                                      ),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          language,
                                          style: TextStyle(
                                            color: Colors.blue[100],
                                            fontSize: 10,
                                            height: 1.2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 6),
                        // Experience with icon
                        SizedBox(
                          height: 20,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.history,
                                color: Colors.amber[200],
                                size: 16,
                              ),
                              SizedBox(
                                  width:
                                      4), // Reduced spacing to match other rows
                              Container(
                                height: 20,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.amber[200]!,
                                    width: 0.8,
                                  ),
                                ),
                                child: Text(
                                  "${data.experience} years experience",
                                  style: TextStyle(
                                    color: Colors.amber[100],
                                    fontSize: 10, // Matching font size
                                    height:
                                        1.2, // For perfect vertical centering
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6),
                        InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AstrologerDetailScreen(
                                      astrologerId: data.id))),
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            height: 28,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.description, // New icon
                                  color: const Color.fromARGB(
                                      255, 147, 233, 169), // Purple accent
                                  size: 18,
                                ),
                                SizedBox(width: 6),
                                Container(
                                  height: 28,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color:
                                            Color.fromARGB(255, 147, 233, 169)!,
                                        width: 0.8),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "View Profile", // Changed text to match icon
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 147, 233, 169),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Icon(
                                        Icons
                                            .chevron_right_rounded, // Simpler arrow
                                        size: 14,
                                        color:
                                            Color.fromARGB(255, 147, 233, 169),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                color: Colors.white.withOpacity(0.2),
                thickness: 1,
              ),
            ),
            // Actions row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Chat Button
                  _buildActionButton(
                    icon: Icons.chat_bubble_rounded,
                    label: "Chat",
                    price: "${data.pricePerChatMinute ?? '30'}/min",
                    color: data.status == 'busy'
                        ? Color.fromARGB(130, 243, 21, 21)
                        : data.status == 'offline'
                            ? Color.fromARGB(255, 97, 95, 95)
                            : Color.fromARGB(130, 155, 117, 233),
                    onPressed: () async {
                      if (data.status == 'busy') {
                        showToastMessage(
                            "Astrologer is busy, please try again later.");
                        return;
                      } else if (data.status == 'offline') {
                        showToastMessage(
                            "Astrologer is offline. We’ll notify you when they’re available.");
                        return;
                      }

                      try {
                        final prefs = await SharedPreferences.getInstance();
                        final userInfo = prefs.getString(AppConstant.userInfo);

                        if (userInfo == null) {
                          print("User info not found in preferences.");
                          // Optionally show login prompt
                          return;
                        }

                        final decodedUser = jsonDecode(userInfo);
                        final String? userId = decodedUser['_id'];

                        if (userId == null || userId.isEmpty) {
                          print("User ID is missing or empty.");
                          return;
                        }

                        final String? astrologerId = data.id;
                        const chatType = "text";

                        if (astrologerId == null || astrologerId.isEmpty) {
                          print("Astrologer ID is missing.");
                          return;
                        }

                        final socketProvider =
                            Provider.of<SocketProvider>(context, listen: false);
                        final chatRoomModel = socketProvider.chatRoomModel;
                        if (chatRoomModel != null) {
                          showToastMessage(
                              "Please cancel you on going chat first.");
                          return;
                        }
                        socketProvider.emitRequestChat(
                            userId, astrologerId, chatType);

                        showToastMessage("Chat request sent successfully!",
                            isError: false);

                        // Optional delay before navigating (can be removed if not needed)
                        await Future.delayed(const Duration(seconds: 3));

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatRoomScreen(),
                          ),
                        );
                      } catch (e) {
                        print("Error in onPressed: $e");
                        showToastMessage(
                            "Something went wrong. Please try again.");
                      }
                    },
                  ),
                  // Call Button
                  _buildActionButton(
                      icon: Icons.call,
                      label: "Call",
                      price: "${data.pricePerCallMinute ?? '50'}/min",
                      color: data.status == 'busy'
                          ? Color.fromARGB(141, 243, 21, 21) // Red
                          : data.status == 'offline'
                              ? Color.fromARGB(255, 97, 95, 95)
                              : Color.fromARGB(
                                  141, 241, 196, 89), // Default (your original)

                      onPressed: () async {
                        if (data.status == 'offline' || data.status == 'busy') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Astrologer is not available for call')),
                          );
                          return;
                        }
                        final prefs = await SharedPreferences.getInstance();
                        final userInfo = prefs.getString(AppConstant.userInfo);

                        if (userInfo == null) {
                          print("User info not found in preferences.");
                          // Optionally show login prompt
                          return;
                        }

                        final decodedUser = jsonDecode(userInfo);
                        final String? userId = decodedUser['_id'];

                        if (userId == null || userId.isEmpty) {
                          print("User ID is missing or empty.");
                          return;
                        }
                        int generateUidFromString(String userId) {
                          return userId.hashCode &
                              0x7FFFFFFF; // keep it positive 32-bit int
                        }

                        final agoraProvider =
                            Provider.of<AgoraProvider>(context, listen: false);
                        final String appId = AppConstant.agoraAppId;
                        final int uid =
                            generateUidFromString(userId); // or email
                        final String channelName =
                            '${userId}_${data.id}_${DateTime.now().millisecondsSinceEpoch}';

                        try {
                          final AgoraTokenModel tokenModel =
                              await agoraProvider.fetchToken(
                                  channelName: channelName,
                                  uid: uid,
                                  userId: userId,
                                  astrologerId: data.id);
                          final socketProvider = Provider.of<SocketProvider>(
                              context,
                              listen: false);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CallScreen(
                                  appId: AppConstant.agoraAppId,
                                  channelName: channelName,
                                  token: tokenModel.token,
                                  uid: uid,
                                  avatar: data.avatar,
                                  name: data.name,
                                  id: data.id,
                                  socketProvider: socketProvider),
                            ),
                          );
                        } catch (e) {
                          print('Error: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to start call')),
                          );
                        }
                      }),
                  // Video Call Button
                  _buildActionButton(
                    icon: Icons.videocam_rounded,
                    label: "Video",
                    price: "${data.pricePerVideoCallMinute ?? '100'}/min",
                    color: data.status == 'busy'
                        ? const Color.fromARGB(146, 243, 21, 21) // Red for busy
                        : data.status == 'offline'
                            ? const Color.fromARGB(
                                255, 97, 95, 95) // Grey for offline
                            : const Color.fromARGB(
                                146, 19, 163, 229), // Blue default
                    onPressed: () async {
                      if (data.status == 'offline' || data.status == 'busy') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Astrologer is not available for call')),
                        );
                        return;
                      }

                      final prefs = await SharedPreferences.getInstance();
                      final userInfo = prefs.getString(AppConstant.userInfo);

                      if (userInfo == null) {
                        print("User info not found in preferences.");
                        return;
                      }

                      final decodedUser = jsonDecode(userInfo);
                      final String? userId = decodedUser['_id'];

                      if (userId == null || userId.isEmpty) {
                        print("User ID is missing or empty.");
                        return;
                      }

                      int generateUidFromString(String userId) {
                        return userId.hashCode &
                            0x7FFFFFFF; // Keep it positive 32-bit int
                      }

                      final agoraProvider =
                          Provider.of<AgoraProvider>(context, listen: false);
                      final socketProvider =
                          Provider.of<SocketProvider>(context, listen: false);
                      final int uid = generateUidFromString(userId);
                      final String channelName =
                          '${userId}_${data.id}_${DateTime.now().millisecondsSinceEpoch}';

                      try {
                        final AgoraTokenModel tokenModel =
                            await agoraProvider.fetchTokenVideoCall(
                          channelName: channelName,
                          uid: uid,
                          userId: userId,
                          astrologerId: data.id,
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PremiumVideoScreen(
                              appId: AppConstant.agoraAppId,
                              channelName: channelName,
                              token: tokenModel.token,
                              uid: uid,
                              avatar: data.avatar,
                              name: data.name,
                              id: data.id,
                              socketProvider: socketProvider,
                            ),
                          ),
                        );
                      } catch (e) {
                        print('Error: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to start call')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required String price,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 1,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), // Increased blur
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.6),
                    color.withOpacity(0.3),
                  ],
                  stops: [0.1, 0.9], // Sharper gradient transition
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3), // Brighter border
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Stack(
                children: [
                  // Enhanced shiny effect
                  Positioned(
                    top: -30,
                    left: -30,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(0.25),
                            Colors.white.withOpacity(0.01),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Button content with centered text
                  ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Centered vertically
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 20),
                        SizedBox(height: 4),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Container(
                          // Ensures text centering
                          alignment: Alignment.center,
                          child: Text(
                            price,
                            textAlign: TextAlign.center, // Explicit centering
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
