import 'dart:ui';
import 'package:astrobandhan/provider/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:astrobandhan/screens/chat/chat_room_screen.dart';

class OverlayButtonWidget extends StatefulWidget {
  const OverlayButtonWidget({Key? key}) : super(key: key);

  @override
  State<OverlayButtonWidget> createState() => _OverlayButtonWidgetState();
}

class _OverlayButtonWidgetState extends State<OverlayButtonWidget>
    with SingleTickerProviderStateMixin {
  double top = 0.0;
  double left = 0.0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;

      setState(() {
        top = 100;
        left = 60;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateInitialPosition(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (top == 0.0 && left == 0.0) {
      top = screenHeight - 100;
      left = screenWidth - 160;
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateInitialPosition(context);

    return Stack(
      children: [
        Positioned(
          top: top,
          left: left,
          child: GestureDetector(
            onPanUpdate: (details) {
              final screenSize = MediaQuery.of(context).size;
              final buttonHeight = 56.0; // Approx height of your button
              final buttonWidth = 160.0;
              final bottomNavBarHeight = 80.0;

              setState(() {
                top += details.delta.dy;
                left += details.delta.dx;

                // Clamp values to keep button inside visible area
                top = top.clamp(
                    0.0, screenSize.height - 220);
                left = left.clamp(0.0, screenSize.width - buttonWidth);
              });
            },
            child: _buildButton(context),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context, {bool forDrag = false}) {
    const double buttonWidth = 160.0;
    const double buttonHeight = 56.0;

    final Color primaryColor = Theme.of(context).primaryColor;
    final Color accentColor =
        HSLColor.fromColor(primaryColor).withLightness(0.3).toColor();

    return Container(
      width: buttonWidth,
      height: buttonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accentColor, primaryColor],
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.5),
            blurRadius: 12.0,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6.0,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.25),
          width: 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.0),
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(color: Colors.transparent),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.chat_rounded, color: Colors.white, size: 22),
                  SizedBox(width: 8),
                  Text(
                    "Join Chat",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                            color: Colors.black26,
                            offset: Offset(0, 1),
                            blurRadius: 2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!forDrag)
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Positioned(
                    top: 0,
                    left: -buttonWidth +
                        (_animationController.value * buttonWidth * 3),
                    child: Transform(
                      transform: Matrix4.skewX(-0.5),
                      child: Container(
                        width: buttonWidth / 2,
                        height: buttonHeight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.white.withOpacity(0.0),
                              Colors.white.withOpacity(0.4),
                              Colors.white.withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(28.0),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatRoomScreen(),
                    ),
                  );
                },
                splashColor: Colors.white.withOpacity(0.3),
                highlightColor: Colors.white.withOpacity(0.1),
                child: Container(
                  width: buttonWidth,
                  height: buttonHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
