import 'package:flutter/material.dart';

Widget buildTaskItem(Map map) => Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 40,
            child: Text("${map["time"]}"),
          ),
          SizedBox(width: 20.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${map["title"]}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Text(
                "${map["date"]}",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          )
        ],
      ),
    );
