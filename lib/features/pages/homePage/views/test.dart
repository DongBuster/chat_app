// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// import '../widgets/input_chip.dart';
// import 'create_group_chat.dart';

// const List<String> _pizzaToppings = <String>[
//   'Olives',
//   'Tomato',
//   'Cheese',
//   'Pepperoni',
//   'Bacon',
//   'Onion',
//   'Jalapeno',
//   'Mushrooms',
//   'Pineapple',
// ];

// void main() => runApp(const EditableChipFieldApp());

// class EditableChipFieldApp extends StatelessWidget {
//   const EditableChipFieldApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(useMaterial3: true),
//       home: const EditableChipFieldExample(),
//     );
//   }
// }

// class EditableChipFieldExample extends StatefulWidget {
//   const EditableChipFieldExample({super.key});

//   @override
//   EditableChipFieldExampleState createState() {
//     return EditableChipFieldExampleState();
//   }
// }

// class EditableChipFieldExampleState extends State<EditableChipFieldExample> {
//   final FocusNode _chipFocusNode = FocusNode();
//   List<String> _toppings = <String>[_pizzaToppings.first];
//   List<String> _suggestions = <String>[];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: <Widget>[
//         Row(
//           children: [
//             const Padding(
//               padding: EdgeInsets.only(left: 10),
//               child: Text(
//                 'Thành viên: ',
//                 style: TextStyle(
//                   fontSize: 17,
//                   color: Colors.grey,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: ChipsInput<String>(
//                 values: _toppings,
//                 decoration: InputDecoration(
//                   contentPadding: const EdgeInsets.only(left: 9),
//                   hintText: 'Search for name friends',
//                   hintStyle: TextStyle(color: Colors.grey.shade400),
//                   focusedBorder:
//                       const OutlineInputBorder(borderSide: BorderSide.none),
//                   border: const OutlineInputBorder(borderSide: BorderSide.none),
//                 ),
//                 strutStyle: const StrutStyle(fontSize: 15),
//                 onChanged: _onChanged,
//                 onSubmitted: _onSubmitted,
//                 chipBuilder: _chipBuilder,
//                 onTextChanged: _onSearchChanged,
//               ),
//             ),
//           ],
//         ),
//         if (_suggestions.isNotEmpty)
//           Expanded(
//             child: ListView.builder(
//               itemCount: _suggestions.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return ToppingSuggestion(
//                   _suggestions[index],
//                   onTap: _selectSuggestion,
//                 );
//               },
//             ),
//           ),
//       ],
//     );
//   }

//   Future<void> _onSearchChanged(String value) async {
//     final List<String> results = await _suggestionCallback(value);
//     setState(() {
//       _suggestions = results
//           .where((String topping) => !_toppings.contains(topping))
//           .toList();
//     });
//   }

//   Widget _chipBuilder(BuildContext context, String topping) {
//     return ToppingInputChip(
//       topping: topping,
//       onDeleted: _onChipDeleted,
//       onSelected: _onChipTapped,
//     );
//   }

//   void _selectSuggestion(String topping) {
//     setState(() {
//       _toppings.add(topping);
//       _suggestions = <String>[];
//     });
//   }

//   void _onChipTapped(String topping) {}

//   void _onChipDeleted(String topping) {
//     setState(() {
//       _toppings.remove(topping);
//       _suggestions = <String>[];
//     });
//   }

//   void _onSubmitted(String text) {
//     if (text.trim().isNotEmpty) {
//       setState(() {
//         _toppings = <String>[..._toppings, text.trim()];
//       });
//     } else {
//       _chipFocusNode.unfocus();
//       setState(() {
//         _toppings = <String>[];
//       });
//     }
//   }

//   void _onChanged(List<String> data) {
//     setState(() {
//       _toppings = data;
//     });
//   }

//   FutureOr<List<String>> _suggestionCallback(String text) {
//     if (text.isNotEmpty) {
//       return _pizzaToppings.where((String topping) {
//         return topping.toLowerCase().contains(text.toLowerCase());
//       }).toList();
//     }
//     return const <String>[];
//   }
// }

// class ToppingSuggestion extends StatelessWidget {
//   const ToppingSuggestion(this.topping, {super.key, this.onTap});

//   final String topping;
//   final ValueChanged<String>? onTap;

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       key: ObjectKey(topping),
//       leading: CircleAvatar(
//         child: Text(
//           topping[0].toUpperCase(),
//         ),
//       ),
//       title: Text(topping),
//       onTap: () => onTap?.call(topping),
//     );
//   }
// }

// // class ToppingInputChip extends StatelessWidget {
// //   const ToppingInputChip({
// //     super.key,
// //     required this.topping,
// //     required this.onDeleted,
// //     required this.onSelected,
// //   });

// //   final String topping;
// //   final ValueChanged<String> onDeleted;
// //   final ValueChanged<String> onSelected;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       margin: const EdgeInsets.only(right: 3),
// //       child: InputChip(
// //         label: Text(
// //           topping,
// //           style: const TextStyle(fontSize: 10),
// //         ),
// //         avatar: CircleAvatar(
// //           child: Text(topping[0].toUpperCase()),
// //         ),
// //         onDeleted: () => onDeleted(topping),
// //         onSelected: (bool value) => onSelected(topping),
// //         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
// //         padding: const EdgeInsets.all(2),
// //       ),
// //     );
// //   }
// // }
