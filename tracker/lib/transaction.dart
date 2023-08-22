import 'dart:ffi';

import 'package:flutter/material.dart';

class MyTransaction extends StatelessWidget {
  final String name;
  final String type;
  final int amount;

  MyTransaction({
    required this.name,
    required this.type,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.all(15),
          color: Colors.grey[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey[500]),
                    child: Center(
                      child: Icon(
                        Icons.attach_money_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(name,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      )),
                ],
              ),
              Text(type,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  )),
              type == 'income'?
              Text('\$' + amount.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                  ))
                  :Text('\$' + amount.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}