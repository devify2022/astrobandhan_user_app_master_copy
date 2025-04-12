import 'package:astrobandhan/utils/text.styles.dart';
import 'package:astrobandhan/widgets/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HoroscopeScreen extends StatefulWidget {
  const HoroscopeScreen({super.key});

  @override
  State<HoroscopeScreen> createState() => _HoroscopeScreenState();
}

class _HoroscopeScreenState extends State<HoroscopeScreen> {
  static const _gradientColors = [Color.fromRGBO(170, 255, 0, 0.4), Color.fromRGBO(60, 0, 255, 0.4)];

  final List<String> _zodiacSigns = [
    'Aries',
    'Taurus',
    'Gemini',
    'Cancer',
    'Leo',
    'Virgo',
    'Libra',
    'Scorpio',
    'Sagittarius',
    'Capricon',
    'Aquarius',
    'Pisces'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Horoscope', textAlignCenter: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 0.65, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
            itemCount: _zodiacSigns.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        height: 86,
                        width: 86,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(begin: Alignment.centerRight, end: Alignment.topLeft, colors: _gradientColors),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Color.fromRGBO(170, 255, 0, 0.50), width: 0.4),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4))],
                        ),
                        child: IconButton(
                          icon: SvgPicture.asset('assets/SVG/horoscope/${_zodiacSigns[index].toLowerCase()}.svg', width: 40, height: 40),
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setString('zodiac', _zodiacSigns[index]);

                            // await Navigator.pushReplacement(
                            //     context, MaterialPageRoute(builder: (context) => DailyHoroscopeScreen(zodiac: _zodiacSigns[index])));
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(_zodiacSigns[index], textAlign: TextAlign.center, style: poppinsStyle500Medium.copyWith(fontSize: 12, color: Colors.white)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

}
