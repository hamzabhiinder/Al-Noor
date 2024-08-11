import 'package:alnoor/widgets/Four_Image_Grid.dart';
import 'package:alnoor/widgets/Two_Image_Grid.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddToCompareRow extends StatelessWidget {
  const AddToCompareRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Drag To View",
                style: GoogleFonts.poppins(
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
          const SizedBox(
              height: 10), // Add spacing between the two rows if needed
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.zero,
                ),
                child: IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 20),
              DragTargetContainer1(),
              const SizedBox(width: 20),
              FourImageDragTargetContainer(),
            ],
          ),
        ],
      ),
    );
  }
}
