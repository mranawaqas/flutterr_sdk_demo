import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class AppButton extends StatelessWidget {
  final String text;
  final String? fontFamily;
  final Color color;
  final Color textColor;
  final Function onTap;
  final double width;
  final double height;
  final double? letterSpacing;
  final double borderRadius;
  final double fontSize;
  final Color? borderColor;
  final FontWeight fontWeight;

  AppButton({
    this.text = '',
    this.color = accentColor,
    this.textColor = Colors.black,
    this.width = 10,
    this.height = 10,
    this.fontSize = 16,
    this.borderColor,
    this.fontWeight = FontWeight.w600,
    this.borderRadius = 10,
    this.letterSpacing,
    required this.onTap,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = borderColor ?? color;
    return ElevatedButton(
      onPressed: onTap as void Function()?,
      child: Text(
        text,
        textScaleFactor: 1,
        style: TextStyle(
          fontFamily: 'Gibson',
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: FontStyle.normal,
          color: textColor,
          letterSpacing: letterSpacing,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(color),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: width, vertical: height),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            side: BorderSide(color: effectiveBorderColor),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}

class EditText extends StatelessWidget {
  final Function(String)? onChange;
  final Function(String?)? onSaved;
  final Function(String?)? validator;
  final String? value;
  final String? hintText;
  final String? errorText;
  final String? prefixIcon;
  final String? suffixIcon;
  final String? fontFamily;
  final bool? setEnable;
  final bool obscure;
  final bool isContentPadding;
  final bool readOnly;
  final bool autoFocus;
  final double focusBorderRadius;
  final double enableBorderRadius;
  final double? fontSize;
  final int minLines;
  final TextInputAction? textInputAction;
  final IconData? icon;
  final IconData? prefixiconData;
  final TextInputType? textInputType;
  final Color? bordercolor;
  final Color? backgroundColor;
  final Color? focusBordercolor;
  final List<TextInputFormatter>? inputFormatter;
  final FocusNode? currentFocus;
  final FocusNode? nextFocus;
  final Function(String)? onFieldSubmitted;
  final TextEditingController? controller;
  final Function? onTap;
  final TextCapitalization textCapitalization;
  final bool isDropDown;
  final bool isPassword;
  final int maxLines;
  final int? maxLength;
  final Function? suffixClick;

  EditText({
    this.onChange,
    this.value,
    this.hintText,
    this.errorText,
    this.prefixIcon,
    this.maxLines = 1,
    this.fontFamily,
    this.fontSize,
    this.suffixIcon,
    this.isDropDown = false,
    this.onSaved,
    this.bordercolor = Colors.transparent,
    this.backgroundColor = Colors.transparent,
    this.enableBorderRadius = 0,
    this.focusBorderRadius = 0,
    this.readOnly = false,
    this.autoFocus = false,
    this.isPassword = false,
    this.minLines = 1,
    this.isContentPadding = true,
    this.validator,
    this.icon,
    this.prefixiconData,
    this.textCapitalization = TextCapitalization.none,
    this.setEnable,
    this.focusBordercolor = Colors.transparent,
    this.obscure = false,
    this.currentFocus,
    this.onTap,
    this.maxLength,
    this.nextFocus,
    this.textInputAction,
    this.controller,
    this.textInputType,
    this.inputFormatter,
    this.onFieldSubmitted,
    this.suffixClick,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: textCapitalization,
      maxLength: maxLength,
      controller: controller,
      autofocus: autoFocus,
      onTap: onTap as void Function()?,
      textAlignVertical: TextAlignVertical.center,
      validator: validator as String? Function(String?)?,
      enabled: setEnable,
      onChanged: onChange,
      readOnly: readOnly,
      onSaved: onSaved,
      minLines: minLines,
      maxLines: maxLines,
      focusNode: currentFocus,
      textInputAction: textInputAction,
      keyboardType: textInputType,
      inputFormatters: inputFormatter,
      obscureText: obscure,
      cursorColor: accentColor,
      initialValue: value,
      style: TextStyle(
        color: textColor,
        fontFamily: fontFamily,
        fontSize: fontSize,
      ),
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        errorText: errorText,
        errorStyle: TextStyle(
          fontFamily: 'Gibson',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: focusBordercolor!),
          borderRadius: BorderRadius.circular(focusBorderRadius),
        ),
        errorMaxLines: 1,
        contentPadding:
            isContentPadding
                ? EdgeInsets.only(left: 10, right: 10)
                : EdgeInsets.all(0),
        hintText: hintText,
        fillColor: backgroundColor,
        filled: true,
        hintMaxLines: 4,
        hintStyle: TextStyle(
          color: hintColor,
          fontSize: fontSize,
          fontFamily: 'Gibson',
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
        suffixIcon:
            isPassword
                ? IconButton(
                  splashColor: Colors.transparent,
                  icon: Icon(icon),
                  color: Color(0xff7c849c),
                  onPressed: suffixClick as void Function()?,
                )
                : isDropDown
                ? SizedBox(
                  width: 0,
                  height: 15,
                  child: Image.asset(suffixIcon!, scale: 2.5),
                )
                : suffixIcon != null
                ? GestureDetector(
                  onTap: suffixClick as void Function()?,
                  child: Image.asset(suffixIcon!, scale: 2.5),
                )
                : null,
        prefixIcon:
            prefixiconData != null
                ? Icon(prefixiconData, color: Colors.black)
                : prefixIcon != null
                ? Image.asset(prefixIcon!, scale: 2.5)
                : null,
        border: InputBorder.none,
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: bordercolor!),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: bordercolor!),
          borderRadius: BorderRadius.circular(enableBorderRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: focusBordercolor!),
          borderRadius: BorderRadius.circular(focusBorderRadius),
        ),
      ),
    );
  }
}

TextFormField buildMutiTextField({
  required String hintText,
  int minLines = 7,
  int maxLines = 7,
  bool enabled = true,
  Color? filledColor,
  Color borderColor = Colors.transparent,
  Color focusedColor = focusBorderColor,
  Function? onSaved,
  required TextEditingController controller,
  Function? onFieldSubmit,
  Function? validator,
  TextInputAction textInputAction = TextInputAction.done,
}) {
  return TextFormField(
    textAlign: TextAlign.justify,
    controller: controller,
    onFieldSubmitted: onFieldSubmit as void Function(String)?,
    validator: validator as String? Function(String?)?,
    enabled: enabled,
    keyboardType: TextInputType.multiline,
    textInputAction: textInputAction,
    minLines: minLines,
    maxLines: maxLines,
    onSaved: onSaved as void Function(String?)?,
    style: TextStyle(color: textColor, fontFamily: 'Gibson'),
    decoration: InputDecoration(
      errorStyle: TextStyle(
        fontFamily: 'Gibson',
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      border: InputBorder.none,
      contentPadding: EdgeInsets.all(8),
      hintStyle: TextStyle(
        fontFamily: 'Gibson',
        color: hintColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      ),
      fillColor: filledColor,
      filled: true,
      hintText: hintText,
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor),
        borderRadius: BorderRadius.circular(5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: focusedColor),
        borderRadius: BorderRadius.circular(5),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor),
        borderRadius: BorderRadius.circular(5),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: focusedColor),
        borderRadius: BorderRadius.circular(5),
      ),
    ),
  );
}
