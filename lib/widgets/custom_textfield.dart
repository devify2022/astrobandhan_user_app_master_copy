import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
const blackColor = Colors.black;
const whiteColor = Colors.white;
const greyColor = Colors.grey;
const redColor = Colors.red;
const interStyle500Medium = TextStyle(fontWeight: FontWeight.w500);
const interStyle400Regular = TextStyle(fontWeight: FontWeight.w400);
const spaceHeight10 = SizedBox(height: 10);

// Text formatters
class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
        text: newValue.text.toLowerCase(), selection: newValue.selection);
  }
}

class CapitalizeFirstLetterFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}

String capitalize(String value) {
  if (value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.enabled,
    this.obscureText,
    this.focusNode,
    this.onChanged,
    this.onSubmited,
    this.validation,
    this.controller,
    this.keyboardType,
    this.hintText,
    this.isShowTopText = true,
    this.labelText,
    this.isUnderlineInputBorder = false,
    this.isOutlineInputBorder = true,
    this.isOutlineInputBorderColor,
    this.maxLength,
    this.maxInputLength, // Renamed from inputFormatter for clarity
    this.onTap,
    this.fieldborderColor = blackColor,
    this.textFieldFillColor = Colors.transparent,
    this.fieldborderRadius = 7,
    this.maxLines,
    this.contentPaddingLeft,
    this.contentPaddingRight,
    this.contentPaddingTop,
    this.contentPaddingBottom,
    this.containerPadding,
    this.outlineTopLeftRadius = 4,
    this.outlineTopRightRadius = 4,
    this.outlineBottomLeftRadius = 4,
    this.outlineBottomRightRadius = 4,
    this.textColor = whiteColor,
    this.hintTextColor = whiteColor,
    this.errorBorderColor,
    this.hintFontSize = 16,
    this.textFontSize,
    this.textAlign,
    this.prefixIcon,
    this.nextFocusNode,
    this.suffixIcon,
    this.autofillHints,
    this.textInputAction = TextInputAction.next,
    this.onEditingComplete,
    this.autofocus = false,
    this.suffix,
    this.suffixIconConstraints,
    this.prefixIconConstraints,
    this.labelColor,
    this.isPrice = false,
    this.isPassword = false,
    this.isEmail = false,
    this.textCapitalization = false,
  });

  final bool? enabled;
  final bool? obscureText;
  final FocusNode? focusNode;
  final String? Function(String?)? onChanged;
  final String? Function(String?)? onSubmited;
  final String? Function(String?)? validation;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? hintText;
  final bool isShowTopText;
  final String? labelText;
  final bool isUnderlineInputBorder;
  final bool isOutlineInputBorder;
  final Color? isOutlineInputBorderColor;
  final int? maxLength;
  final int? maxInputLength; // Renamed for clarity
  final void Function()? onTap;
  final Color fieldborderColor;
  final Color textFieldFillColor;
  final double fieldborderRadius;
  final int? maxLines;
  final double? contentPaddingLeft;
  final double? contentPaddingRight;
  final double? contentPaddingTop;
  final double? contentPaddingBottom;
  final double? containerPadding;
  final double outlineTopLeftRadius;
  final double outlineTopRightRadius;
  final double outlineBottomLeftRadius;
  final double outlineBottomRightRadius;
  final Color textColor;
  final Color? hintTextColor;
  final Color? errorBorderColor;
  final double hintFontSize;
  final double? textFontSize;
  final TextAlign? textAlign;
  final Widget? prefixIcon;
  final FocusNode? nextFocusNode;
  final Widget? suffixIcon;
  final Iterable<String>? autofillHints;
  final TextInputAction textInputAction;
  final Function()? onEditingComplete;
  final bool autofocus;
  final Widget? suffix;
  final BoxConstraints? suffixIconConstraints;
  final BoxConstraints? prefixIconConstraints;
  final Color? labelColor;
  final bool isPrice;
  final bool isPassword;
  final bool isEmail;
  final bool textCapitalization;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPassword != oldWidget.isPassword) {
      setState(() {
        _obscureText = true; // Reset obscure text when isPassword changes
      });
    }
  }

  // Helper method to build borders
  InputBorder _buildBorder({Color? color}) {
    if (!widget.isUnderlineInputBorder && !widget.isOutlineInputBorder) {
      return InputBorder.none;
    }
    if (!widget.isOutlineInputBorder) {
      return UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: greyColor));
    }
    return OutlineInputBorder(
      borderSide: BorderSide(
        width: widget.isOutlineInputBorderColor != null ? 0 : 1,
        color: color ?? widget.isOutlineInputBorderColor ?? Colors.grey,
      ),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(widget.outlineTopLeftRadius),
        topRight: Radius.circular(widget.outlineTopRightRadius),
        bottomLeft: Radius.circular(widget.outlineBottomLeftRadius),
        bottomRight: Radius.circular(widget.outlineBottomRightRadius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isShowTopText)
          Container(
            padding: EdgeInsets.only(left: widget.containerPadding ?? 10),
            child: Text(
              widget.labelText ?? widget.hintText ?? "",
              style: interStyle500Medium.copyWith(
                  fontSize: 14, color: widget.labelColor ?? greyColor),
            ),
          )
        else
          const SizedBox.shrink(),
        spaceHeight10,
        TextFormField(
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          obscureText:
              widget.isPassword ? _obscureText : widget.obscureText ?? false,
          maxLength: widget.maxLength,
          maxLines: widget.maxLines ?? 1,
          focusNode: widget.focusNode,
          onTap: widget.onTap, // Fixed to properly use onTap callback
          validator: widget.validation,
          onChanged: widget.onChanged,
          onFieldSubmitted: (String value) {
            widget.nextFocusNode != null
                ? FocusScope.of(context).requestFocus(widget.nextFocusNode)
                : FocusScope.of(context).unfocus();
            if (widget.onSubmited != null) widget.onSubmited!(value);
          },
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          textAlign: widget.textAlign ?? TextAlign.left,
          autofillHints: widget.autofillHints,
          textInputAction: widget.textInputAction,
          onEditingComplete: widget.onEditingComplete,
          cursorColor: Colors.white,
          decoration: InputDecoration(
            suffixIconConstraints: widget.suffixIconConstraints,
            contentPadding: EdgeInsets.only(
              left: widget.contentPaddingLeft ?? 20,
              right: widget.contentPaddingRight ?? 12,
              top: widget.contentPaddingTop ?? 13,
              bottom: widget.contentPaddingBottom ?? 13,
            ),
            isDense: true,
            hintText: widget.hintText ?? "",
            hintStyle: interStyle400Regular.copyWith(
              fontSize: widget.hintFontSize,
              color: (widget.hintTextColor ?? greyColor).withOpacity(0.5),
            ),
            label: widget.hintText == null
                ? Text(widget.labelText ?? "",
                    style: TextStyle(color: widget.labelColor ?? greyColor))
                : null,
            helperStyle: const TextStyle(color: Colors.transparent),
            errorStyle: const TextStyle(color: redColor),
            prefixIcon: widget.prefixIcon,
            prefixIconConstraints: widget.prefixIconConstraints,
            suffixIcon: widget.isPassword
                ? InkWell(
                    onTap: _toggle,
                    child: Container(
                      padding: const EdgeInsets.only(right: 10),
                      alignment: Alignment.center,
                      width: 20,
                      child: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white.withOpacity(0.5),
                        size: 20,
                      ),
                    ),
                  )
                : widget.suffixIcon ?? widget.suffix,
            filled: true,
            fillColor: widget.textFieldFillColor,
            border: _buildBorder(),
            enabledBorder: _buildBorder(),
            focusedBorder: _buildBorder(),
            errorBorder: _buildBorder(color: redColor),
            disabledBorder: _buildBorder(
                color: widget.isOutlineInputBorderColor ?? redColor),
          ),
          inputFormatters: [
            if (widget.textCapitalization)
              CapitalizeFirstLetterFormatter()
            else if (widget.isEmail)
              LowerCaseTextFormatter()
            else if (widget.isPrice)
              FilteringTextInputFormatter.allow(
                  RegExp(r'^\d*\.?\d{0,2}')) // Allows decimals for prices
            else if (widget.keyboardType == TextInputType.number ||
                widget.keyboardType == TextInputType.phone)
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
            else if (widget.maxInputLength != null)
              LengthLimitingTextInputFormatter(widget.maxInputLength),
          ],
          style: TextStyle(
            color: widget.textColor,
            fontSize: widget.textFontSize ?? 15,
          ),
        ),
      ],
    );
  }
}
