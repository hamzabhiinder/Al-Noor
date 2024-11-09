import 'package:alnoor/widgets/contact_card.dart';
import 'package:alnoor/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';

class DealersPage extends StatefulWidget {
  final bool isGuestUser;

  const DealersPage({Key? key, required this.isGuestUser}) : super(key: key);

  @override
  _DealersPageState createState() => _DealersPageState();
}

class _DealersPageState extends State<DealersPage> {
  late ValueNotifier<bool> _isMenuVisibleNotifier;
  FocusNode _focusNode = FocusNode();
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isMenuVisibleNotifier = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _isMenuVisibleNotifier.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    _isMenuVisibleNotifier.value = !_isMenuVisibleNotifier.value;
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size and apply scaling factors
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          _isMenuVisibleNotifier.value = false;
        },
        child: Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 8.0 : 16.0,
                        vertical: isSmallScreen ? 12.0 : 16.0,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: SvgPicture.asset(
                                  'assets/images/Logo_Black.svg',
                                  width: isSmallScreen ? 35 : 47,
                                  height: isSmallScreen ? 35 : 47,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              if (!widget.isGuestUser)
                                IconButton(
                                  icon: SvgPicture.asset(
                                    'assets/images/menu.svg',
                                    width: isSmallScreen ? 25 : 30,
                                    height: isSmallScreen ? 25 : 30,
                                  ),
                                  onPressed: _toggleMenu,
                                ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          ContactCard(
                            heading: "Karachi Design Studio",
                            address:
                                "24-C, 7th Commercial Lane, Main Khayaban-e-Bahria, Phase IV, Dha, Karachi.",
                            phone1: "+92 21 372 372 05",
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          ContactCard(
                            heading: "Lahore Design Studio",
                            address: "7-AI Sector XX, Phase 3, DHA, Lahore.",
                            phone1: "+92 21 372 372 05",
                          ),
                          Spacer(),
                          ElevatedButton(
                            onPressed: () async {
                              await EasyLauncher.url(
                                  url: "https://alnoormdf.com/dealers");
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff464444),
                              padding: EdgeInsets.symmetric(
                                vertical: isSmallScreen ? 12.0 : 16.0,
                                horizontal: isSmallScreen ? 24.0 : 32.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Find A Dealer",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: isSmallScreen ? 14 : 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isMenuVisibleNotifier,
                    builder: (context, isVisible, child) {
                      return (isVisible && !widget.isGuestUser)
                          ? Positioned(
                              top: constraints.maxHeight * 0.09,
                              right: 20,
                              child: HamburgerMenu(
                                isGuestUser: widget.isGuestUser,
                                isMenuVisible: isVisible,
                                onMenuToggle: _toggleMenu,
                              ),
                            )
                          : Container();
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
