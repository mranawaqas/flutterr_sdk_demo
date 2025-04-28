import 'package:flutter/material.dart';
import 'package:mapmetricflutterdemo/views.dart';

import 'main.dart';

class Dialogs {
  static Widget alertDialog({
    String? title,
    String? content,
    Widget? contentWidget,
    double height = 18,
    double width = 30,
    TextEditingController? reasonController,
    bool reason = false,
    required String leftBtnText,
    required String rightBtnText,
    required Function leftBtnTap,
    required Function rightBtnTap,
  }) {
    return AlertDialog(
      scrollable: true,
      title:
          title != null
              ? Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Gibson',
                  color: Color(0xff000000),
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 0.48,
                ),
              )
              : const SizedBox(height: 5),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (contentWidget != null)
            contentWidget
          else
            Text(
              content ?? '',
              style: const TextStyle(
                fontFamily: 'Gibson',
                color: Color(0xff000000),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                letterSpacing: 0.28,
              ),
            ),
          if (reason)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 6),
                const Text(
                  "Enter reason",
                  style: TextStyle(
                    fontFamily: 'Gibson',
                    color: Color(0xff000000),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0.28,
                  ),
                ),
                const SizedBox(height: 6),
                buildMutiTextField(
                  filledColor: const Color(0xffb2b9c8).withOpacity(0.17),
                  controller: reasonController!,
                  maxLines: 4,
                  minLines: 2,
                  textInputAction: TextInputAction.send,
                  hintText: 'Reason',
                ),
              ],
            ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child:
                    leftBtnText != ""
                        ? TextButton(
                          onPressed: () => leftBtnTap(),
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Text(
                              leftBtnText,
                              style: const TextStyle(
                                fontFamily: 'Gibson',
                                color: Color(0xff78849e),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        )
                        : const SizedBox.shrink(),
              ),
              AppButton(
                height: height,
                width: width,
                text: rightBtnText,
                borderRadius: 23,
                color: buttonBackground,
                textColor: Colors.white,
                onTap: () => rightBtnTap(),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
    );
  }
}
