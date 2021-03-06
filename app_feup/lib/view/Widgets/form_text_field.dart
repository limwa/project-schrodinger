import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String description;
  final String labelText;
  final String hintText;
  final String emptyText;
  final int minLines;
  final int maxLines;
  final double bottomMargin;

  FormTextField(
    this.controller,
    this.icon, {
    this.description = '',
    this.minLines = 1,
    this.maxLines = 1,
    this.labelText = '',
    this.hintText = '',
    this.emptyText = 'Por favor escreve algo',
    this.bottomMargin = 0,
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin:  EdgeInsets.only(bottom: bottomMargin),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
           Text(
            description,
            style: Theme.of(context).textTheme.body1,
            textAlign: TextAlign.left,
          ),
           Row(children: <Widget>[
             Container(
                margin:  EdgeInsets.only(right: 15),
                child:  Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                )),
            Expanded(
                child:  TextFormField(
              // margins
              minLines: minLines,
              maxLines: maxLines,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: Theme.of(context).textTheme.body1,
                labelText: labelText,
                labelStyle: Theme.of(context).textTheme.body1,
              ),
              controller: controller,
              validator: (value) {
                if (value.isEmpty) {
                  return emptyText;
                }
                return null;
              },
            ))
          ])
        ],
      ),
    );
  }
}
