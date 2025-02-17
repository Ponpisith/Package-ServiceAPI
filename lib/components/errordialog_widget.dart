// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';


class ErrorDialogWidget extends StatelessWidget {
  final String? title;
  final String? description;
  final String? textButton;
  const ErrorDialogWidget({
    super.key,
    required this.title,
    required this.description,
    this.textButton,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
              title ?? 'เกิดข้อผิดพลาด',
              style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text(
              description ?? 'รายละเอียดข้อผิดพลาด',
              style: TextStyle(
                  fontFamily: 'Readex Pro',
                  fontSize: 16,
                  color: Colors.black,
                ),
              textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              Align(
              alignment: Alignment.bottomRight,
              child: Container(
                decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16.0),
                ),
                child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  textButton ?? 'ปิด',
                  style: TextStyle(
                    fontFamily: 'Readex Pro',
                    color: Colors.pink,
                    fontSize: 18,
                    ),
                ),
                ),
              ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
