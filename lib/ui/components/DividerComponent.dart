 import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/icons.dart';

class DividerComponent extends StatelessWidget {
   const DividerComponent({Key? key}) : super(key: key);

   @override
   Widget build(BuildContext context) {
     return Row(
       children: [
         Expanded(
           child: Divider(
             thickness: 2,
             color: blackColor.withOpacity(0.25),
             indent: 20,
           ),
         ),
         getIcon(AppIcons.arrow_down, color: primaryColor),
         Expanded(
           child: Divider(
             thickness: 2,
             color: blackColor.withOpacity(0.25),
             endIndent: 20,
           ),
         ),
       ],
     );
   }
 }
