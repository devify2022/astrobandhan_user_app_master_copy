import 'package:astrobandhan/datasource/model/others/astrologer_model.dart';
import 'package:astrobandhan/helper/helper.dart';
import 'package:astrobandhan/helper/snakbar.dart';
import 'package:astrobandhan/provider/dashboard_provider.dart';
import 'package:astrobandhan/provider/home_provider.dart';
import 'package:astrobandhan/screens/astromall/astromall.dart';
import 'package:astrobandhan/utils/app_colors.dart';
import 'package:astrobandhan/utils/images.dart';
import 'package:astrobandhan/utils/size.util.dart';
import 'package:astrobandhan/utils/text.styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../astrologer/astrologer_details_screen.dart';
import 'package:astrobandhan/datasource/model/others/top_astrologer_model.dart';

class HomeScrren extends StatefulWidget {
  const HomeScrren({super.key});

  @override
  State<HomeScrren> createState() => _HomeScrrenState();
}

class _HomeScrrenState extends State<HomeScrren> {
  @override
  void initState() {
    super.initState();
    // Call fetchTopAstrologers during initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).fetchTopAstrologers();
    });
  }

  final List<IconButtonClass> _learningSection = [
    IconButtonClass(position: 0, icon: ImageResources.tv, title: 'TV'),
    IconButtonClass(
        position: 1, icon: ImageResources.matrimony, title: 'Matrimony'),
    IconButtonClass(
        position: 2,
        icon: ImageResources.learnastrology,
        title: 'Learn Astrology'),
    IconButtonClass(
        position: 3, icon: ImageResources.numerology, title: 'Numerology'),
    IconButtonClass(
        position: 4, icon: ImageResources.lalkitab, title: 'Lal Kitab'),
    IconButtonClass(
        position: 5,
        icon: ImageResources.dailypanchang,
        title: 'Daily Panchang'),
    IconButtonClass(
        position: 6, icon: ImageResources.magazine, title: 'Magazine'),
    IconButtonClass(
        position: 7, icon: ImageResources.bookapooja, title: 'Book A Pooja'),
  ];

  List<IconButtonClass> topSectionIcons = [
    IconButtonClass(position: 0, icon: ImageResources.kundli, title: 'Kundli'),
    IconButtonClass(
        position: 1, icon: ImageResources.matching, title: 'Matching'),
    IconButtonClass(
        position: 2, icon: ImageResources.horoscope, title: 'Horoscope'),
    IconButtonClass(
        position: 3, icon: ImageResources.astromall, title: 'AstroMall'),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, homeProvider, child) {
      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        children: [
          _buildFeatureGrid(),
          spaceHeight25,
          Text(
            'Top Astrologer',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          spaceHeight25,
          Container(
              child: homeProvider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _buildAstrologerList(homeProvider.topAstrologersList)),
          homeProvider.isLoading ? spaceHeight25 : spaceZero,
          _buildAstroBandhanButton(112),
          spaceHeight10,
       Text(
  'Live Now',
  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
),
          spaceHeight25,
          _buildLiveAstrologerList(),
          spaceHeight20,
          _buildAutoSuggestCard(),
          spaceHeight25,
          _buildLearningSection(),
          spaceHeight10,
          _buildAstroBandhanButton(112),
          spaceHeight10,
          _buildShareButton(),
          spaceHeight20,
        ],
      );
    });
  }

  Widget _buildShareButton() {
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Not Available, Comming soon")),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Share App With Friends',
                style: poppinsStyle600SemiBold.copyWith(
                    fontSize: 14, color: Color(0xFF2B2B69))),
            const SizedBox(width: 8),
            SvgPicture.asset(ImageResources.share_icon, height: 16, width: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLearningSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.63,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0),
        itemCount: _learningSection.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                height: 70,
                width: 88,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.topLeft,
                    colors: gradientColors,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Color.fromRGBO(170, 255, 0, 0.50),
                    width: 0.4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Image.asset(
                    _learningSection[index].icon,
                    width: 40,
                    height: 40,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // PanchangScreen
                    if (_learningSection[index] == "tv") {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const YouTubePlayerPage(
                      //         videoId:
                      //         'LQcHz0JIPq4'), // Replace with your video ID
                      //   ),
                      // );
                    } else {
                      showTopSnackBar(context, "comming soon");
                    }

                    // else if (_learningSection[index] == "DailyPanchang") {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => PanchangScreen()),
                    //   );
                    // } else if (_learningSection[index] == "Numerology") {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => NumeroScreen()),
                    //   );
                    // }
                  },
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _learningSection[index].title,
                style: interStyle400Regular.copyWith(fontSize: 12),
                textAlign: TextAlign.center,
                // style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              const SizedBox(height: 3),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAutoSuggestCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: gradientColors),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Image.asset('assets/img/OBJECTS.png', width: 97, height: 86),
          const SizedBox(width: 30),
          Expanded(child: _buildAutoSuggestContent()),
        ],
      ),
    );
  }

  Widget _buildAutoSuggestContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Not sure Whom To Connect?',
            style: poppinsStyle500Medium.copyWith(fontSize: 16)),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            // _autoSuggestBottomModal(context);
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, foregroundColor: Colors.black),
          child: Text('AUTO SUGGEST',
              style: poppinsStyle600SemiBold.copyWith(
                  color: Color(0xff18185E), fontSize: 13)),
        ),
      ],
    );
  }

  Widget _buildLiveAstrologerList() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return _buildLiveAstrologerItem();
        },
      ),
    );
  }

  Widget _buildLiveAstrologerItem() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              showTopSnackBar(context, "comming soon");
            },
            child: Stack(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 40),
                ),
                Positioned(
                  left: 18,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Live',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your Name',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildAstroBandhanButton(double height) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(ImageResources.home_banner,
            width: screenWeight, height: height, fit: BoxFit.cover));
  }

  Widget _buildAstrologerList(List<TopAstrologerModel> astrologerList) {
    return SizedBox(
      height: 105,
      width: screenWeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: astrologerList.length,
        itemBuilder: (context, index) {
          return _buildAstrologerItem(astrologerList[index]);
        },
      ),
    );
  }

  Widget _buildAstrologerItem(TopAstrologerModel astrologer) {
    return Container(
      margin: const EdgeInsets.only(right: 1.0),
      height: 60,
      width: 80,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AstrologerDetailScreen(astrologerId: astrologer.id),
                ),
              );
            },
            child: Stack(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: astrologer.status == 'available'
                              ? Colors.green
                              : astrologer.status == 'busy'
                                  ? Colors.red
                                  : Colors.grey, // offline or any other case
                          width: 4)),
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(astrologer.avatar),
                            fit: BoxFit.cover)),
                  ),
                ),
                Positioned(
                  left: 17,
                  bottom: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6), // Reduced height from 8 to 6
          Text(
            (astrologer.name.split(' ').first),
            style: interStyle400Regular.copyWith(fontSize: 12),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis, // Prevents text overflow
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildFeatureItem(
            topSectionIcons[0].icon,
            topSectionIcons[0].title,
            onPressed: () => {
              // showTopSnackBar(context, "comming soon")
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => KundliScreen()))
            },
          ),
        ),
        spaceWeight10,
        Expanded(
          child: _buildFeatureItem(
            topSectionIcons[1].icon,
            topSectionIcons[1].title,
            onPressed: () => {
              // showTopSnackBar(context, "comming soon")
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => MatchingScreen()))
            },
          ),
        ),
        spaceWeight10,
        Expanded(
          child: _buildFeatureItem(
            topSectionIcons[2].icon,
            topSectionIcons[2].title,
            //     onPressed: () => {
            //   Navigator.push(context, MaterialPageRoute(builder: (context) => HoroscopeScreen()))
            // }
          ),
        ),
        spaceWeight10,
        Expanded(
          child: _buildFeatureItem(
              topSectionIcons[3].icon, topSectionIcons[3].title,
              onPressed: () => Helper.toReplacementScreenSlideLeftToRight(
                  context, AstromallScreen())),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String iconPath, String label,
      {VoidCallback? onPressed}) {
    return Column(
      children: [
        _buildFeatureItemContainer(iconPath, onPressed: onPressed),
        const SizedBox(height: 8),
        Center(
            child: Text(label,
                style: interStyle400Regular.copyWith(fontSize: 12))),
      ],
    );
  }

  Widget _buildFeatureItemContainer(String iconPath,
      {VoidCallback? onPressed}) {
    return Container(
      height: 75.522,
      width: 75.522,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            colors: gradientBorderColors,
            stops: [0.1, 0.9]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4))
        ],
      ),
      child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: gradientColors,
                  stops: [0.1, 0.9]),
              borderRadius: BorderRadius.circular(16)),
          child: Center(
              child: IconButton(
                  icon: Image.asset(iconPath, width: 40, height: 40),
                  onPressed: onPressed))),
    );
  }

  Widget _buildSection(String title,
      {bool isViewAll = false, void Function()? onPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Text(title,
                style: poppinsStyle500Medium.copyWith(fontSize: 18))),
        if (isViewAll)
          InkWell(
              onTap: onPressed,
              child: SvgPicture.asset(ImageResources.forward,
                  width: 10,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                      const Color.fromARGB(255, 255, 255, 255),
                      BlendMode.srcIn))),
      ],
    );
  }
}

class IconButtonClass {
  final int position;
  final String icon;
  final String title;

  IconButtonClass(
      {required this.position, required this.icon, required this.title});
}
