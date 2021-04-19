import 'dart:ui';

import 'package:flutter/material.dart';

Widget customCard( String title, icon , color) {

  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    margin: EdgeInsets.all(10.0),
    child: Container(
      decoration: BoxDecoration(
        color:  Colors.grey,
        borderRadius: BorderRadius.circular(10),

      ),
      child:  ButtonTheme(
        child:

        ElevatedButton(onPressed: (){},
          child: Padding(
        padding: const EdgeInsets.all(5),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(
              icon,
              size: 40.0,
              color: color,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                SizedBox(
                  height: 5.0,
                ),
                Text(

                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ],
        ),),
      ),

  )));
}
/*onPressed:*/