import 'package:alnoor/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DealorsPage extends StatefulWidget {
  final bool isGuestUser;

  const DealorsPage({Key? key, required this.isGuestUser}) : super(key: key);

  @override
  _DealorsPageState createState() => _DealorsPageState();
}

class _DealorsPageState extends State<DealorsPage> {
  late ValueNotifier<bool> _isMenuVisibleNotifier;

  @override
  void initState() {
    super.initState();
    _isMenuVisibleNotifier = ValueNotifier<bool>(false);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(onTap: () {
      _isMenuVisibleNotifier.value = false;
    }, child: Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Main content background
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [],
                    ),
                  ),
                ),
              ),
              // Top bar with logo and menu icon
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 0,
                    right: screenWidth * 0.02,
                    top: constraints.maxHeight * 0.03,
                    bottom: constraints.maxHeight * 0.03,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/images/Logo_Black.svg',
                          width: 47,
                          height: 47,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      if (!widget.isGuestUser)
                        IconButton(
                          icon: SvgPicture.asset(
                            'assets/images/menu.svg',
                            width: 30,
                            height: 30,
                          ),
                          onPressed: () {
                            _isMenuVisibleNotifier.value =
                                !_isMenuVisibleNotifier.value;
                          },
                        ),
                    ],
                  ),
                ),
              ),
              // Hamburger menu overlay
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
    ));
  }

  void _toggleMenu() {
    _isMenuVisibleNotifier.value = !_isMenuVisibleNotifier.value;
  }
}
