import 'package:alnoor/widgets/contact_card.dart';
import 'package:alnoor/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart'; // For opening Google Map links

class DealorsPage extends StatefulWidget {
  final bool isGuestUser;

  const DealorsPage({Key? key, required this.isGuestUser}) : super(key: key);

  @override
  _DealorsPageState createState() => _DealorsPageState();
}

class _DealorsPageState extends State<DealorsPage> {
  late ValueNotifier<bool> _isMenuVisibleNotifier;
  FocusNode _focusNode = FocusNode();
  TextEditingController _textController = TextEditingController();
  List<Map<String, String>> dealers = [];
  List<Map<String, String>> filteredDealers = [];

  @override
  void initState() {
    super.initState();
    _isMenuVisibleNotifier = ValueNotifier<bool>(false);

    dealers = [
      {
        'name': 'Dealer 1 | Alnoor Lasani Mdf SMCH Karachi',
        'url':
            'https://www.google.com/maps/place/University+of+Karachi/@24.9389065,67.1188609,17z/data=!3m1!4b1!4m6!3m5!1s0x3eb338980b4615af:0xe968e4f0fd0119cd!8m2!3d24.9389017!4d67.1237318!16zL20vMDV4Yjdx?entry=ttu&g_ep=EgoyMDI0MTAxNi4wIKXMDSoASAFQAw%3D%3D'
      },
      {
        'name': 'Dealer 2 | xyz area lorem ipsum block karachi',
        'url':
            'https://www.google.com/maps/place/University+of+Karachi/@24.9389065,67.1188609,17z/data=!3m1!4b1!4m6!3m5!1s0x3eb338980b4615af:0xe968e4f0fd0119cd!8m2!3d24.9389017!4d67.1237318!16zL20vMDV4Yjdx?entry=ttu&g_ep=EgoyMDI0MTAxNi4wIKXMDSoASAFQAw%3D%3D'
      },
      {
        'name': 'Dealer 3 | xyz area lorem ipsum block karachi',
        'url':
            'https://www.google.com/maps/place/University+of+Karachi/@24.9389065,67.1188609,17z/data=!3m1!4b1!4m6!3m5!1s0x3eb338980b4615af:0xe968e4f0fd0119cd!8m2!3d24.9389017!4d67.1237318!16zL20vMDV4Yjdx?entry=ttu&g_ep=EgoyMDI0MTAxNi4wIKXMDSoASAFQAw%3D%3D'
      },
      {
        'name': 'Dealer 4 | xyz area lorem ipsum block karachi',
        'url':
            'https://www.google.com/maps/place/University+of+Karachi/@24.9389065,67.1188609,17z/data=!3m1!4b1!4m6!3m5!1s0x3eb338980b4615af:0xe968e4f0fd0119cd!8m2!3d24.9389017!4d67.1237318!16zL20vMDV4Yjdx?entry=ttu&g_ep=EgoyMDI0MTAxNi4wIKXMDSoASAFQAw%3D%3D'
      },
      {
        'name': 'Dealer 5 | xyz area lorem ipsum block karachi',
        'url':
            'https://www.google.com/maps/place/University+of+Karachi/@24.9389065,67.1188609,17z/data=!3m1!4b1!4m6!3m5!1s0x3eb338980b4615af:0xe968e4f0fd0119cd!8m2!3d24.9389017!4d67.1237318!16zL20vMDV4Yjdx?entry=ttu&g_ep=EgoyMDI0MTAxNi4wIKXMDSoASAFQAw%3D%3D'
      },
      {
        'name': 'Dealer 6 | xyz area lorem ipsum block karachi',
        'url':
            'https://www.google.com/maps/place/University+of+Karachi/@24.9389065,67.1188609,17z/data=!3m1!4b1!4m6!3m5!1s0x3eb338980b4615af:0xe968e4f0fd0119cd!8m2!3d24.9389017!4d67.1237318!16zL20vMDV4Yjdx?entry=ttu&g_ep=EgoyMDI0MTAxNi4wIKXMDSoASAFQAw%3D%3D'
      },
      {
        'name': 'Dealer 7 | xyz area lorem ipsum block karachi',
        'url':
            'https://www.google.com/maps/place/University+of+Karachi/@24.9389065,67.1188609,17z/data=!3m1!4b1!4m6!3m5!1s0x3eb338980b4615af:0xe968e4f0fd0119cd!8m2!3d24.9389017!4d67.1237318!16zL20vMDV4Yjdx?entry=ttu&g_ep=EgoyMDI0MTAxNi4wIKXMDSoASAFQAw%3D%3D'
      },
    ];

    filteredDealers = dealers;

    _textController.addListener(() {
      _filterDealers(_textController.text);
    });
  }

  void _filterDealers(String query) {
    setState(() {
      filteredDealers = dealers
          .where((dealer) =>
              dealer['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onSearchSubmit() {
    _focusNode.unfocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _isMenuVisibleNotifier.dispose();
    super.dispose();
  }

  Future<void> _openMap(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open the map.';
    }
  }

  void _toggleMenu() {
    _isMenuVisibleNotifier.value = !_isMenuVisibleNotifier.value;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        _isMenuVisibleNotifier.value = false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(left: 16, right: 16, top: 100),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: screenHeight * 0.035,
                                child: TextField(
                                  controller: _textController,
                                  focusNode: _focusNode,
                                  onSubmitted: (text) {
                                    _onSearchSubmit();
                                  },
                                  decoration: InputDecoration(
                                    suffixIcon: _textController.text.isNotEmpty
                                        ? IconButton(
                                            icon: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              child: Icon(
                                                Icons.close,
                                                size: screenWidth * 0.03,
                                                color: Colors.black,
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _textController.clear();
                                              });
                                              _onSearchSubmit();
                                            },
                                          )
                                        : null,
                                    filled: true,
                                    fillColor: Color(0xFFEFEFEF),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.038),
                                  ),
                                  style:
                                      TextStyle(fontSize: screenHeight * 0.015),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              if (!_focusNode.hasFocus &&
                                  _textController.text.isEmpty)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.search,
                                        color: Colors.grey,
                                        size: screenHeight * 0.02),
                                    SizedBox(width: screenWidth * 0.02),
                                    Text(
                                      'Search Dealers Near Me',
                                      style: GoogleFonts.poppins(
                                        fontSize: screenHeight * 0.012,
                                        color: Color(0xFF9A9A9A),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            height: 180,
                            decoration: BoxDecoration(
                              color: Color(0xFFF8F8F8),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount: filteredDealers.length,
                                  itemBuilder: (context, index) {
                                    final dealer = filteredDealers[index];
                                    return ListTile(
                                      title: Text(
                                        dealer['name']!,
                                        style: TextStyle(
                                          fontSize: screenHeight * 0.012,
                                          color: Color(0xFF9A9A9A),
                                        ),
                                      ),
                                      onTap: () {
                                        _openMap(dealer['url']!);
                                      },
                                      dense:
                                          true, // Reduces vertical spacing inside the tile
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      visualDensity: VisualDensity(
                                          vertical:
                                              -4), // Reduces vertical spacing between tiles
                                    );
                                  },
                                )),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ContactCard(
                                      heading: "Head Office Karachi",
                                      address:
                                          "Al-Noor Building, 96-A, SMCHS, Karachi.",
                                      email: "info@alnoorlasani.com",
                                      phone1: "+92 21 3438 9272",
                                      phone2: "+92 21 3455 9853"),
                                  SizedBox(width: 0), // Space between cards
                                  ContactCard(
                                      heading: "Head Office Karachi",
                                      address:
                                          "Al-Noor Building, 96-A, SMCHS, Karachi.",
                                      email: "info@alnoorlasani.com",
                                      phone1: "+92 21 3438 9272",
                                      phone2: "+92 21 3455 9853")
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: Column(
                            children: [
                              Text(
                                'Find Our Dealers',
                                style: TextStyle(
                                  fontSize: constraints.maxHeight * 0.02,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20),
                              Container(
                                width: double.infinity,
                                child: Image.asset(
                                  'assets/images/map.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: constraints.maxHeight * 0.03,
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
                              _toggleMenu();
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                // Hamburger menu visibility logic
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
    );
  }
}
