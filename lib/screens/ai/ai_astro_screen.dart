import 'package:astrobandhan/datasource/model/astrologer_model.dart';
import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/provider/home_provider.dart';
import 'package:astrobandhan/utils/app_colors.dart';
import 'package:astrobandhan/utils/size.util.dart';
import 'package:astrobandhan/utils/text.styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AiAstroScreen extends StatefulWidget {
  const AiAstroScreen({super.key});

  @override
  State<AiAstroScreen> createState() => _AiAstroScreenState();
}

class _AiAstroScreenState extends State<AiAstroScreen> {
  final chips = ['All', 'Love', 'Career', 'Marriage', 'Health', 'Finance', 'Business', 'Education', 'Pregnancy', 'Legal'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    providerHome.getAstrologerAI();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, homeProvider, child) {
      return Column(
        children: [
          SizedBox(
              height: 50,
              child: ListView.builder(
                itemCount: chips.length,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChoiceChip(
                      label: Text(chips[index],
                          style: poppinsStyle400Regular.copyWith(color: homeProvider.selectedChip == index ? Colors.black : Colors.white)),
                      selected: homeProvider.selectedChip == index,
                      backgroundColor: kPrimaryColor,
                      selectedColor: Colors.white,
                      selectedShadowColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.white.withValues(alpha: 0.2), width: 1)),
                      onSelected: (value) {
                        homeProvider.setSelectedChip(index);
                        homeProvider.getAstrologerAI();
                      },
                    ),
                  );
                },
              )),

          spaceHeight10,
          Expanded(
            child: homeProvider.aiLoading
                ? Center(child: CircularProgressIndicator())
                : homeProvider.aiAstrologers.isEmpty
                    ? Center(child: Text('No Astrologer Found'))
                    : ListView.builder(
                        itemCount: homeProvider.aiAstrologers.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return _buildAstrologerCard(context,homeProvider.aiAstrologers[index]);
                        },
                      ),
          ),
        ],
      );
    });
  }

  Widget _buildAstrologerCard(context,AstrologerModel data) {

    return Container(
      margin:  EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient:  LinearGradient(
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
            offset:  Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.stretch, // Makes children stretch vertically
          children: [
            SizedBox(
              width: 120,
              child: ClipRRect(
                borderRadius:  BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.network(
                  data.avatar,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey,
                      child:  Icon(Icons.person, color: Colors.white),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children:  [
                            Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "${data.rating}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if(data.specialities.isNotEmpty) Text(
                      "${data.specialities[0]  }",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Hindi, English',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${data.experience} years",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${data.pricePerChatMinute?? "30"}/min",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Column(
                          children: [

                            SizedBox(
                              width: 75,
                              height: 28,
                              child: ElevatedButton(
                                onPressed: () {
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   SnackBar(
                                  //     content:
                                  //         Text("Not Available, Comming soon"),
                                  //   ),
                                  // );
                                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatScreen(data.id?? "679ea14630e6147cf0053e91",data.name?? "AI-Astro")));

                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                ),
                                child: const Text(
                                  'CHAT',
                                  style: TextStyle(
                                    color: Color(0xFF303F9F),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
