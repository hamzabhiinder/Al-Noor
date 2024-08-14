// import 'package:flutter/material.dart';

// class FourImageDragTargetContainer extends StatefulWidget {
//   @override
//   _FourImageDragTargetContainerState createState() =>
//       _FourImageDragTargetContainerState();
// }

// class _FourImageDragTargetContainerState
//     extends State<FourImageDragTargetContainer> {
//   String? _imageUrl1;
//   String? _imageUrl2;
//   String? _imageUrl3;
//   String? _imageUrl4;

//   @override
//   Widget build(BuildContext context) {
//     return DragTarget<String>(
//       onAcceptWithDetails: (DragTargetDetails<String> details) {
//         print(details.data);
//         final String newImageUrl = details.data;
//         setState(() {
//           if (_imageUrl1 == null || _imageUrl1!.isEmpty || _imageUrl1 == "") {
//             _imageUrl1 = newImageUrl;
//           } else if (_imageUrl2 == null ||
//               _imageUrl2!.isEmpty ||
//               _imageUrl2 == "") {
//             _imageUrl2 = newImageUrl;
//           } else if (_imageUrl3 == null ||
//               _imageUrl3!.isEmpty ||
//               _imageUrl3 == "") {
//             _imageUrl3 = newImageUrl;
//           } else if (_imageUrl4 == null ||
//               _imageUrl4!.isEmpty ||
//               _imageUrl4 == "") {
//             _imageUrl4 = newImageUrl;
//           } else {
//             _imageUrl1 = newImageUrl;
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
//           child: Column(
//             children: [
//               Expanded(
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: _imageUrl1 != null
//                           ? Image.network(
//                               _imageUrl1!,
//                               fit: BoxFit.cover,
//                               height: double.infinity,
//                             )
//                           : Container(),
//                     ),
//                     Container(
//                       width: 1.0,
//                       color: Colors.black,
//                     ),
//                     Expanded(
//                       child: _imageUrl2 != null
//                           ? Image.network(
//                               _imageUrl2!,
//                               fit: BoxFit.cover,
//                               height: double.infinity,
//                             )
//                           : Container(),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 height: 1.0,
//                 color: Colors.black,
//               ),
//               Expanded(
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: _imageUrl3 != null
//                           ? Image.network(
//                               _imageUrl3!,
//                               fit: BoxFit.cover,
//                               height: double.infinity,
//                             )
//                           : Container(),
//                     ),
//                     Container(
//                       width: 1.0,
//                       color: Colors.black,
//                     ),
//                     Expanded(
//                       child: _imageUrl4 != null
//                           ? Image.network(
//                               _imageUrl4!,
//                               fit: BoxFit.cover,
//                               height: double.infinity,
//                             )
//                           : Container(),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }











import 'package:flutter/material.dart';

class FourImageDragTargetContainer extends StatefulWidget {
  @override
  _FourImageDragTargetContainerState createState() =>
      _FourImageDragTargetContainerState();
}

class _FourImageDragTargetContainerState
    extends State<FourImageDragTargetContainer> {
  String? _imageUrl1;
  String? _imageUrl2;
  String? _imageUrl3;
  String? _imageUrl4;

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onWillAccept: (data) {
        return true;
      },
      onAcceptWithDetails: (DragTargetDetails<String> details) {
        final String newImageUrl = details.data;
        setState(() {
          if (_imageUrl1 == null || _imageUrl1!.isEmpty) {
            _imageUrl1 = newImageUrl;
          } else if (_imageUrl2 == null || _imageUrl2!.isEmpty) {
            _imageUrl2 = newImageUrl;
          } else if (_imageUrl3 == null || _imageUrl3!.isEmpty) {
            _imageUrl3 = newImageUrl;
          } else if (_imageUrl4 == null || _imageUrl4!.isEmpty) {
            _imageUrl4 = newImageUrl;
          } else {
            _imageUrl1 = newImageUrl;
          }
        });
      },
      builder: (BuildContext context, List<String?> candidateData,
          List<dynamic> rejectedData) {
        return Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _imageUrl1 != null
                          ? Image.network(
                              _imageUrl1!,
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
                      child: _imageUrl2 != null
                          ? Image.network(
                              _imageUrl2!,
                              fit: BoxFit.cover,
                              height: double.infinity,
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1.0,
                color: Colors.black,
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _imageUrl3 != null
                          ? Image.network(
                              _imageUrl3!,
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
                      child: _imageUrl4 != null
                          ? Image.network(
                              _imageUrl4!,
                              fit: BoxFit.cover,
                              height: double.infinity,
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
