import 'package:astrobandhan/helper/Modal/addReview/addReview_modal.dart';
import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/provider/astrologer_provider.dart';
import 'package:astrobandhan/provider/user_provider.dart';
import 'package:astrobandhan/utils/app_colors.dart';
import 'package:astrobandhan/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helper/Modal/gift/gift_modal.dart';

class AstrologerDetailScreen extends StatefulWidget {
  final String astrologerId;

  const AstrologerDetailScreen({super.key, required this.astrologerId});

  @override
  _AstrologerDetailScreenState createState() => _AstrologerDetailScreenState();
}

class _AstrologerDetailScreenState extends State<AstrologerDetailScreen> {
  int currentPage = 1;
  final int reviewsPerPage = 2;
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // Fetch astrologer data when the screen loads
    Provider.of<AstrologerProvider>(context, listen: false)
        .fetchAstrologerData(widget.astrologerId);
  }

  @override
  Widget build(BuildContext context) {
    final astrologer = Provider.of<AstrologerProvider>(context).astrologerData;

    // ✅ Move calculations inside the build method
    int totalReviews = astrologer?['reviews']?.length ?? 0;
    int totalPages = (totalReviews / reviewsPerPage).ceil();

    int startIndex = (currentPage - 1) * reviewsPerPage;
    int endIndex = (startIndex + reviewsPerPage > totalReviews)
        ? totalReviews
        : startIndex + reviewsPerPage;

    final currentReviews =
        astrologer?['reviews']?.sublist(startIndex, endIndex) ?? [];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Astrologer Details',
          style: TextStyle(
            color: Colors.white, // Set the text color here
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<AstrologerProvider>(builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (provider.errorMessage != null) {
          return Center(child: Text(provider.errorMessage!));
        }

        var astrologer = provider.astrologerData;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundImage:
                            NetworkImage(astrologer?['avatar'] ?? ''),
                      ),
                      Positioned(
                        bottom: -10,
                        left: 60,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: astrologer?['rating'] != null
                                ? (astrologer?['rating'] < 3
                                    ? Colors.red
                                    : astrologer?['rating'] <= 4
                                        ? Colors.yellow
                                        : Colors.green)
                                : Colors
                                    .grey, // Default color if rating is null
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${astrologer?['rating'] ?? 0}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Name and Experience
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            (astrologer?['name'] ?? ''),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: kMainColor,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            astrologer?['isVerified'] == true
                                ? Icons.check_circle
                                : Icons.error,
                            color: astrologer?['isVerified'] == true
                                ? Colors.green
                                : Colors.red,
                            size: 20,
                          ),
                        ],
                      ),
                      SizedBox(width: 12),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: astrologer?['status'] == 'busy'
                              ? const Color.fromARGB(255, 255, 3, 3)
                              : astrologer?['status'] == 'available'
                                  ? const Color.fromARGB(255, 5, 236, 63)
                                  : const Color.fromARGB(244, 90, 90, 90),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          astrologer?['status'] == 'available'
                              ? 'Online'
                              : astrologer?['status'] == 'busy'
                                  ? "Busy"
                                  : "Offline",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 8),
                Text(
                  'Experience: ${astrologer?['experience']} years',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                // Specialities
                Text(
                  'Specialities:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  (astrologer?['specialities'] as List).join(', '),
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),

                // Services Available Section
                Text(
                  'Services Available:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Chat Button
                      SizedBox(
                        height: 46,
                        child: ElevatedButton(
                          onPressed: astrologer?['status'] == 'available'
                              ? () {
                                  // Navigate to chat screen
                                }
                              : () {
                                  showToastMessage(
                                      'Astrologer is currently ${astrologer?['status']}');
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                astrologer?['status'] == 'available'
                                    ? Colors.green
                                    : astrologer?['status'] == 'busy'
                                        ? Colors.red
                                        : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          child: Text(
                            'Chat : ₹${astrologer?['pricePerChatMinute'] != null ? '${astrologer!['pricePerChatMinute']} / min' : '--'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                          width: 12), // ⬅️ Horizontal space between buttons

                      // Call Button
                      SizedBox(
                        height: 46,
                        child: ElevatedButton(
                          onPressed: astrologer?['status'] == 'available'
                              ? () {
                                  // Navigate to chat screen
                                }
                              : () {
                                  showToastMessage(
                                      'Astrologer is currently ${astrologer?['status']}');
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                astrologer?['status'] == 'available'
                                    ? Colors.green
                                    : astrologer?['status'] == 'busy'
                                        ? Colors.red
                                        : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          child: Text(
                            'Call : ₹${astrologer?['pricePerCallMinute'] != null ? '${astrologer!['pricePerCallMinute']} / min' : '--'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                          width: 12), // ⬅️ Horizontal space between buttons

                      // Video Call Button
                      SizedBox(
                        height: 46,
                        child: ElevatedButton(
                          onPressed: astrologer?['status'] == 'available'
                              ? () {
                                  // Navigate to chat screen
                                }
                              : () {
                                  showToastMessage(
                                      'Astrologer is currently ${astrologer?['status']}');
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                astrologer?['status'] == 'available'
                                    ? Colors.green
                                    : astrologer?['status'] == 'busy'
                                        ? const Color.fromARGB(255, 235, 33, 19)
                                        : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          child: Text(
                            'Video Call : ₹${astrologer?['pricePerVideoCallMinute'] != null ? '${astrologer?['pricePerVideoCallMinute']} / min' : '--'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Reviews Section
// Reviews Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Reviews Section
                    Text(
                      'Reviews:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    if (currentReviews.isNotEmpty)
                      ...currentReviews.map<Widget>((review) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: Colors.white.withOpacity(0.1),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Username + Rating
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        review['userName'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.star,
                                              color: Colors.amber, size: 18),
                                          SizedBox(width: 4),
                                          Text(
                                            review['rating'].toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    review['comment'],
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList()
                    else
                      Text(
                        'No reviews available.',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),

                    SizedBox(height: 16),

                    // Pagination Buttons
                    if (totalPages > 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(totalPages, (index) {
                          final page = index + 1;
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: currentPage == page
                                    ? const Color.fromARGB(255, 255, 255, 255)
                                    : Colors.white24,
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(12),
                              ),
                              onPressed: () {
                                setState(() {
                                  currentPage = page;
                                });
                              },
                              child: Text(
                                '$page',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                  ],
                ),

                // Contact Button
                Container(
                  margin: const EdgeInsets.only(
                      top: 16.0), // 👈 Adds space at the top
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Send Gift Button
                      ElevatedButton(
                        onPressed: () {
                          final userProvider =
                              Provider.of<UserProvider>(context, listen: false);
                          showGiftModal(
                              context, widget.astrologerId, userProvider);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.card_giftcard,
                                color: Color.fromARGB(255, 0, 0, 0)),
                            SizedBox(width: 8),
                            Text(
                              'Send Gift',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),

                      // Write Review Button
                      ElevatedButton(
                        onPressed: () =>
                            showReviewModal(context, widget.astrologerId),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit,
                                color: Color.fromARGB(255, 0, 0, 0)),
                            SizedBox(width: 8),
                            Text(
                              'Write Review',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
