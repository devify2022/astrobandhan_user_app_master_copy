// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// // 1) Import your Astrologer model
//
//
// class AstrologerProfileScreen extends StatefulWidget {
//
//   final Astrologer astrologer; // <-- Pass the clicked Astrologer object here
//
//   const AstrologerProfileScreen({
//     super.key,
//     required this.astrologer, // <-- constructor param
//   });
//
//   @override
//   State<AstrologerProfileScreen> createState() => _AstrologerProfileScreenState();
// }
//
// class _AstrologerProfileScreenState extends State<AstrologerProfileScreen> {
//
//   String? _activeChatAstrologerId;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     _loadActiveChatState(); // <-- add this
//   }
//
//   Future<void> _loadActiveChatState() async {
//     final prefs = await SharedPreferences.getInstance();
//     final storedActiveChat = prefs.getString('activeChatAstrologerId');
//     if (storedActiveChat != null && storedActiveChat.isNotEmpty) {
//       setState(() {
//         _activeChatAstrologerId = storedActiveChat;
//       });
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           BackgroundImage(),
//           Column(
//             children: [
//               Expanded(
//                 child: _buildAppContent(context,widget.astrologer),
//               ),
//
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAppContent(BuildContext context, Astrologer astrologer) {
//     return SafeArea(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 20),
//           AppBarWidget(title: 'PROFILE'),
//           const SizedBox(height: 20),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: _buildContentCard(astrologer),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildContentCard(Astrologer astrologer) {
//
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         _buildAstrologerInfoCard(),
//         const SizedBox(height: 10),
//         _buildAboutSection(),
//         const SizedBox(height: 10),
//         _buildGift(),
//         const SizedBox(height: 10),
//         _buildReviewSection(),
//         const SizedBox(height: 10),
//         _buildReviewCard(),
//         const SizedBox(height: 10),
//         _buildReviewCard(),
//         const SizedBox(height: 20),
//         // _buildTrendingAstrologers(astrologer),
//         _buildAstrologerCardHori(astrologer),
//         const SizedBox(height: 10),
//       ],
//     );
//   }
//
//   // 2) Replace hard-coded data in the astrologer card with actual astrologer values
//   Widget _buildAstrologerInfoCard() {
//     final astro = widget.astrologer;
//
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.centerRight,
//           end: Alignment.topLeft,
//           colors: [
//             Color.fromRGBO(170, 255, 0, 0.4),
//             Color.fromRGBO(60, 0, 255, 0.4),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: Colors.white.withOpacity(0.1),
//           width: 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // Left side: avatar + rating + orders
//           Padding(
//             padding: const EdgeInsets.only(left: 10),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // 3) Show the astrologer's avatar or a default icon
//                 _buildAstrologerImage(astro.avatar,astro),
//                 const SizedBox(height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(
//                     // E.g., show up to 5 stars for astro.rating
//                     5,
//                         (index) => Icon(
//                       Icons.star,
//                       color: (index < astro.rating)
//                           ? Colors.yellow
//                           : Colors.white, // if rating < 5, fill partially
//                       size: 16,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 // Orders or totalRatingsCount?
//                 // If you have that data, show it. Otherwise, keep a placeholder:
//                 Text(
//                   '1999 Orders', // or: '${astro.totalRatingsCount} Orders'
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w300,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Right side: name, specialties, languages, experience, call/chat/video pricing
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Row with Astrologer name + follow button
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           astro.name.isNotEmpty
//                               ? astro.name
//                               : 'Astrologer Name',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       Container(height: 5,)
//                       // _buildFollowButton(""),
//                     ],
//                   ),
//                   const SizedBox(height: 5),
//
//                   // Specialties, languages, experience
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         astro.specialities.isNotEmpty
//                             ? astro.specialities.join(', ')
//                             : 'Specialty: Vedic Astrology',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w300,
//                         ),
//                       ),
//                       // If you store languages, show them. Otherwise, keep static:
//                       const Text(
//                         'Hindi, English',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w300,
//                         ),
//                       ),
//                       Text(
//                         'Exp: ${astro.experience} years',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w300,
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   // Buttons for call/chat/video
//                   Row(
//                     children: [
//
//                       Column(
//                         children: [
//                           _buildFollowButton('Chat',()async{
//                                var status =
//                                       await Permission.camera.request();
//
//                                   if (status.isGranted) {
//                                     print('Camera permission granted');
//                                   } else {
//                                     print('Camera permission denied');
//                                   }
//
//                                   status =
//                                       await Permission.microphone.request();
//
//                                   if (status.isGranted) {
//                                     print('Microphone permission granted');
//
//                                     setState(() {
//                                       _activeChatAstrologerId = astro.id;
//                                       print("==>_activeChatAstrologerId${_activeChatAstrologerId!}");
//                                     });
//
//                                     context
//                                         .read<ChatProvider>()
//                                         .startChat(astro.id);
//                                     // Save to prefs
//                                     final prefs =
//                                         await SharedPreferences.getInstance();
//                                     await prefs.setString(
//                                         'activeChatAstrologerId',
//                                         astro.id);
//                                     await prefs.setString(
//                                         'activeChat_userId', prefs.getString("user_id")??"" );
//                                     await prefs.setString(
//                                         'activeChat_avatar', astro.avatar);
//                                     await prefs.setString(
//                                         'activeChat_name', astro.name);
//
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             Chattingwithastrologer(
//                                           name: astro.name,
//                                           image: astro.avatar,
//                                           userId:
//                                                prefs.getString("user_id") ??
//                                         "", // Replace with actual user ID
//                                           astrologerId: astro
//                                               .id, // Replace with actual astrologer ID
//                                         ),
//                                       ),
//                                     ).then(
//                                       (value) {
//                                         setState(() {
//                                           _activeChatAstrologerId =
//                                               astro.id;
//                                           print("==>_activeChatAstrologerId${_activeChatAstrologerId!}");
//                                         });
//                                       },
//                                     );
//                                   } else {
//                                     print('Microphone permission denied');
//                                   }
//                           }),
//                           Text(
//                             '₹${astro.pricePerChatMinute}/min', // or astro.pricePerChatMinute
//                             style: const TextStyle(
//                               fontFamily: 'Inter',
//                               fontWeight: FontWeight.w400,
//                               fontSize: 14,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(width: 10),
//                       Column(
//                         children: [
//                           _buildFollowButton('Call',()async{
//                        final prefs = await SharedPreferences.getInstance();
//                              Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => AudioCallScreen(
//                                   userId: prefs.getString("user_id")??"", // Replace with actual user ID
//                                   astrologerId: astro.id,astrologerAvatar: astro.avatar,astrologerName: astro.name
//
//                                       , // Replace with actual astrologer ID
//                                 ),
//                               ),
//                             );
//
//                           }),
//                           Text(
//                             '₹${astro.pricePerCallMinute.toStringAsFixed(0)}/min',
//                             style: const TextStyle(
//                               fontFamily: 'Inter',
//                               fontWeight: FontWeight.w400,
//                               fontSize: 14,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(width: 10),
//
//                       Column(
//                         children: [
//                           _buildFollowButton('Video Call',()async{
//                                 final prefs = await SharedPreferences.getInstance();
//                               Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => VideoCallScreen(
//                                   userId:
//                                       prefs.getString("user_id") ??
//                                       "", // Replace with actual user ID
//                                   astrologerId: astro
//                                       .id,
//                                   astrologerName: astro.name,
//                                   astrologerAvatar: astro.avatar,// Replace with actual astrologer ID
//                                 ),
//                               ),
//                             );
//                           }),
//                           Text(
//                             '₹${astro.pricePerVideoCallMinute}/min', // or
//                             style: const TextStyle(
//                               fontFamily: 'Inter',
//                               fontWeight: FontWeight.w400,
//                               fontSize: 14,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // 4) Accept a dynamic avatar URL if available. Otherwise show default
//   Widget _buildAstrologerImage(String avatarUrl, Astrologer astro) {
//     // If you want to show the "Online" tag, we can place it in a Stack
//     print(astro.isAvailable);
//     return Stack(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: astro.isCallAvailable == true ? Colors.green : Colors.red, // Border color
//               width: 4, // Border width
//             ),
//           ),
//           child: CircleAvatar(
//             radius: 35,
//             backgroundColor: Colors.grey[300],
//             backgroundImage: (avatarUrl.isNotEmpty)
//                 ? NetworkImage(avatarUrl) as ImageProvider
//                 : null,
//             child: (avatarUrl.isEmpty)
//                 ? const Icon(Icons.person, size: 40)
//                 : null,
//           ),
//         ),
//         // "Online" badge
//         Positioned(
//           left: 17,
//           bottom: 0,
//           child: Container(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 8,
//               vertical: 2,
//             ),
//             decoration: BoxDecoration(
//               color: astro.isCallAvailable == true ? Colors.green : Colors.red,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Text(
//               astro.isCallAvailable == true? 'Online' : "Offline",
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 10,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFollowButton(String data, VoidCallback ontap) {
//
//     return ElevatedButton(
//       onPressed: ontap,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF1a237e),
//         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
//         minimumSize: const Size(0, 24),
//         maximumSize: const Size(double.infinity, 24),
//         textStyle: const TextStyle(
//           fontFamily: 'Inter',
//           fontWeight: FontWeight.w700,
//           fontSize: 14,
//         ),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(14),
//         ),
//         side: const BorderSide(
//           color: Colors.white,
//           width: 1,
//         ),
//       ),
//       child: Text(data),
//     );
//   }
//
//   // "About" section remains mostly unchanged
//   Widget _buildAboutSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'About Astrologer',
//           style: TextStyle(
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.w500,
//             fontSize: 24,
//             color: Colors.white,
//           ),
//         ),
//         const SizedBox(height: 8),
//         const Text(
//           'incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat...',
//           style: TextStyle(
//             fontFamily: 'Inter',
//             fontWeight: FontWeight.w400,
//             fontSize: 16,
//             color: Colors.white54,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildGift() {
//     return Padding(
//       padding: const EdgeInsets.all(2),
//       child: Container(
//         width: double.infinity,
//         height: 56,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         decoration: BoxDecoration(
//           color: const Color.fromRGBO(255, 255, 255, 0.08),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: Colors.white.withOpacity(0.1),
//             width: 1,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: GestureDetector(
//           onTap: (){
//             sendGiftModal(context);
//           },
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: const [
//                   Icon(
//                     Icons.card_giftcard,
//                     color: Colors.white,
//                     size: 24,
//                   ),
//                   SizedBox(width: 12),
//                   Text(
//                     'Send Gift',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//               const Icon(
//                 Icons.arrow_forward_ios,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//
// void sendGiftModal(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.black,
//       builder: (BuildContext context) {
//         return Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           margin: const EdgeInsets.only(top: 0),
//           decoration: const BoxDecoration(
//
//              gradient: LinearGradient(
//               begin: Alignment.centerRight, // Matches 270deg (right to left)
//               end: Alignment.centerLeft,
//               colors: [
//                 Color.fromRGBO(170, 255, 0, 0.32),
//                 Color.fromRGBO(60, 0, 255, 0.4),
//               ],
//             ),
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(24),
//               topRight: Radius.circular(24),
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Top bar with title and close button
//                InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Align(
//                   alignment: Alignment.centerRight,
//                   child: const Icon(
//                     Icons.close,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 5,),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     "Send Gift To Astrologer Name",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Text(
//                       "₹150",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//
//                 ],
//               ),
//               const SizedBox(height: 12),
//
//               // Price Display
//
//               const SizedBox(height: 12),
//
//               // Grid of Gifts
//               GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4,
//                   mainAxisSpacing: 12,
//                   crossAxisSpacing: 12,
//                   childAspectRatio: 0.8,
//                 ),
//                 itemCount: 8,
//                 itemBuilder: (context, index) {
//                   // Replace these with the actual gift data
//                   final List<String> giftIcons = [
//                     'assets/gift/send_gift1.png',
//                     'assets/gift/send_gift2.png',
//                     'assets/gift/send_gift3.png',
//                     'assets/gift/send_gift4.png',
//                     'assets/gift/send_gift5.png',
//                     'assets/gift/send_gift6.png',
//                     'assets/gift/send_gift7.png',
//                     'assets/gift/send_gift8.png',
//                   ];
//                   final List<int> giftPrices = [
//                     50,
//                     100,
//                     150,
//                     200,
//                     200,
//                     500,
//                     500,
//                     1000
//                   ];
//
//                   return Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         height: 60,
//                         width: 60,
//                         decoration: BoxDecoration(
//
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Center(
//                           child:
//                           // SvgPicture.asset(
//                           //   giftIcons[index],
//                           //   height: 36,
//
//                           // ),
//                           Image.asset(
//                           giftIcons[index],
//                           height: 36,
//                         )
//                         ),
//                       ),
//
//                       const SizedBox(height: 4),
//                       Text(
//                         "₹${giftPrices[index]}",
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//               const SizedBox(height: 16),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//
//   Widget _buildReviewSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Reviews',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.w500,
//                 color: Colors.white,
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 // Write a review logic
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 foregroundColor: const Color(0xFF1a237e),
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                 textStyle: const TextStyle(
//                   fontFamily: 'Inter',
//                   fontWeight: FontWeight.w700,
//                   fontSize: 14,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 side: const BorderSide(
//                   color: Colors.white,
//                   width: 1,
//                 ),
//               ),
//               child: const Text('WRITE A REVIEW'),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildReviewCard() {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: const Color.fromRGBO(255, 255, 255, 0.08),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: Colors.white.withOpacity(0.1),
//           width: 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: const Padding(
//         padding: EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Example user review
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundImage: AssetImage('assets/img/image.png'),
//                 ),
//                 SizedBox(width: 10),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Client Name',
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Icon(Icons.star, color: Colors.yellow, size: 16),
//                         Icon(Icons.star, color: Colors.yellow, size: 16),
//                         Icon(Icons.star, color: Colors.yellow, size: 16),
//                         Icon(Icons.star, color: Colors.yellow, size: 16),
//                         Icon(Icons.star, color: Colors.yellow, size: 16),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             Text(
//               'incididunt ut labor dolore magna aliqua. Ut enim ad minim ve exercitation ullamc labori.',
//               style: TextStyle(
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.w500,
//                 fontSize: 16,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // "Trending Astrologers" remains as is
//   Widget _buildTrendingAstrologers(Astrologer astrologer) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.centerRight,
//           end: Alignment.topLeft,
//           colors: [
//             Color.fromRGBO(170, 255, 0, 0.4),
//             Color.fromRGBO(60, 0, 255, 0.4),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: Colors.white.withOpacity(0.1),
//           width: 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Trending Astrologers',
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.white,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 16),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   _buildAstrologerImage('',astrologer), // Reuse the circle image code if needed
//                   const SizedBox(width: 12),
//                   _buildAstrologerImage('',astrologer),
//                   const SizedBox(width: 12),
//                   _buildAstrologerImage('',astrologer),
//                   const SizedBox(width: 12),
//                   _buildAstrologerImage('',astrologer),
//                   const SizedBox(width: 12),
//                   _buildAstrologerImage('',astrologer),
//                   const SizedBox(width: 12),
//                   _buildAstrologerImage('',astrologer),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAstrologerCardHori(Astrologer astrologer) {
//     bool isChatDisabled = _activeChatAstrologerId != null &&
//         _activeChatAstrologerId != astrologer.id; // But not THIS astrologer
//     final userProvider = context.watch<UserProvider>();
//     final user = userProvider.user;
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.centerRight,
//           end: Alignment.topLeft,
//           colors: [
//             Color.fromRGBO(170, 255, 0, 0.4),
//             Color.fromRGBO(60, 0, 255, 0.4),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: Colors.white.withOpacity(0.1),
//           width: 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: IntrinsicHeight(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Tranding Astrologer",
//                       style: TextStyle(
//                           color: Colors.white, fontWeight: FontWeight.w500),
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Row(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(right: 16.0),
//                           child: Column(
//                             children: [
//                               InkWell(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (_) => AstrologerProfileScreen(
//                                           astrologer: astrologer),
//                                     ),
//                                   );
//                                 },
//                                 child: Stack(
//                                   children: [
//                                     Container(
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         border: Border.all(
//                                           color: astrologer.isCallAvailable !=
//                                                   true
//                                               ? Colors.red
//                                               : Colors.green, // Border color
//                                           width: 4,
//                                         ),
//                                       ),
//                                       child: CircleAvatar(
//                                         radius: 35, // Reduced radius
//                                         backgroundColor: Colors.grey[300],
//                                         child: Image.network(
//                                           astrologer.avatar,
//                                           errorBuilder:
//                                               (context, error, stackTrace) {
//                                             return const Icon(
//                                               Icons.person, // User icon
//                                               size: 40,
//                                             );
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       left: 17,
//                                       bottom: 0,
//                                       child: Container(
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 8,
//                                           vertical: 2,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color:
//                                               astrologer.isCallAvailable != true
//                                                   ? Colors.red
//                                                   : Colors.green,
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         child: Text(
//                                           astrologer.isCallAvailable != true
//                                               ? 'Busy'
//                                               : 'Online',
//                                           style: const TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 10,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     Text(
//                       astrologer.name.toUpperCase(),
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 10,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
