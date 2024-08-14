// import 'package:flutter/material.dart';

// class DragTargetContainer1 extends StatefulWidget {
//   @override
//   _DragTargetContainerState createState() => _DragTargetContainerState();
// }

// class _DragTargetContainerState extends State<DragTargetContainer1> {
//   String? _image1;
//   String? _image2;

//   @override
//   Widget build(BuildContext context) {
//     return DragTarget<String>(
//       onAcceptWithDetails: (DragTargetDetails<String> details) {
//         print(details.data);
//         final String newImageUrl = details.data;
//         setState(() {
//           if (_image1 == null || _image1!.isEmpty || _image1 == "") {
//             _image1 = newImageUrl;
//           } else if (_image2 == null || _image2!.isEmpty || _image2 == "") {
//             _image2 = newImageUrl;
//           } else {
//             _image1 = newImageUrl;
//           }
//         });
//       },
//       builder: (BuildContext context, List<String?> candidateData,
//           List<dynamic> rejectedData) {
//         return Container(
//           width: 40.0,
//           height: 40.0,
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.black),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: _image1 != null
//                     ? Image.network(
//                         _image1!,
//                         fit: BoxFit.cover,
//                         height: double.infinity,
//                       )
//                     : Container(),
//               ),
//               Container(
//                 width: 1.0,
//                 color: Colors.black,
//               ),
//               Expanded(
//                 child: _image2 != null
//                     ? Image.network(
//                         _image2!,
//                         fit: BoxFit.cover,
//                         height: double.infinity,
//                       )
//                     : Container(),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }












import 'package:flutter/material.dart';

class DragTargetContainer1 extends StatefulWidget {
  @override
  _DragTargetContainerState createState() => _DragTargetContainerState();
}

class _DragTargetContainerState extends State<DragTargetContainer1> {
  String? _image1;
  String? _image2;

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onWillAccept: (data) {
        return true;
      },
      onAcceptWithDetails: (DragTargetDetails<String> details) {
        final String newImageUrl = details.data;
        setState(() {
          if (_image1 == null || _image1!.isEmpty) {
            _image1 = newImageUrl;
          } else if (_image2 == null || _image2!.isEmpty) {
            _image2 = newImageUrl;
          } else {
            _image1 = newImageUrl;
          }
        });
      },
      builder: (BuildContext context, List<String?> candidateData,
          List<dynamic> rejectedData) {
        return Container(
          width: 40.0, // Adjusted width to fit two images side by side
          height: 40.0, // Adjusted height to match the FourImageDragTargetContainer
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _image1 != null
                    ? Image.network(
                        _image1!,
                        fit: BoxFit.cover,
                        height: double.infinity,
                      )
                    : Container(),
              ),
              Container(
                width: 1.0,
                color: Colors.black,
              ),
              Expanded(
                child: _image2 != null
                    ? Image.network(
                        _image2!,
                        fit: BoxFit.cover,
                        height: double.infinity,
                      )
                    : Container(),
              ),
            ],
          ),
        );
      },
    );
  }
}
